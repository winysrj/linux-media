Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RLMUrf007503
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 17:22:30 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RLMHxH018394
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 17:22:17 -0400
Received: by wf-out-1314.google.com with SMTP id 25so2252749wfc.6
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 14:22:16 -0700 (PDT)
Message-ID: <412bdbff0805271422q10ca3efdq213c3f8bd63e697a@mail.gmail.com>
Date: Tue, 27 May 2008 17:22:14 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080527180048.6a27dbf7@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522223700.2f103a14@core> <20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
	<412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
	<20080527180048.6a27dbf7@gaivota>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] video4linux: Push down the BKL
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello Mauro,

On Tue, May 27, 2008 at 5:00 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>> I'm not sure yet exactly how that's going to work, but it's something
>> that might prompt you to defer converting it from a mutex until we
>> have that worked out.
>
>
> The hybrid device mode lock is somewhat complex. The simplest solution would be
> to block an open() call, if the device is already used by a different mode.
>
> This will minimize things like firmware reload, on xc3028 devices, where you
> have different firmwares for analog and digital modes.
>
> Also, some USB devices (like HVR-900/HVR-950) switches off analog audio and tv
> demod chips when in digital mode (the reverse is also true - e.g. digital demod
> is switched off at analog mode).
>
> So, if you are in digital mode, on HVR-900, and changes to analog, you'll need
> to re-initialize tvp5150/msp3400. The current code for those devices handles
> this at open(). If we let this to happen later, we'll need to re-send the video
> and audio parameters to all I2C connected devices, when switching mode.
>
> On the other hand, some userspace apps, like mythtv, opens both analog and
> digital API's. I'm not sure if it does this at the same time, but, if so, a
> lock at open() will cause a regression there (someone told me that this is the
> case - I didn't test it here yet).
>
> One possible solution of providing a proper code to change mode, and not
> blocking open() would be to write something like this:
>
> static int check_and_switch_mode(void *priv, int digital)
> {
>        struct dev_foo *dev = priv;
>
>        mutex_lock(dev->lock);
>
>        if (digital)
>                return change_to_digital(dev);
>        else
>                return change_to_analog(dev);
>
>        mutex_unlock(dev->lock);
> }
>
> Since this should be called for every valid V4L2 and DVB ioctl, the better
> place for it would be to add this as a new function callback, at video_ioctl2.
> Something like [1]:
>
> --- a/linux/drivers/media/video/videodev.c      Tue May 27 16:02:56 2008 -0300
> +++ b/linux/drivers/media/video/videodev.c      Tue May 27 17:34:04 2008 -0300
> @@ -821,6 +821,10 @@
>                v4l_print_ioctl(vfd->name, cmd);
>                printk("\n");
>        }
> +
> +       if (_IOC_TYPE(cmd)=='v') || _IOC_TYPE(cmd)=='V') &&
> +               vfd->vidioc_switch_mode)
> +               ret=vfd->vidioc_switch_mode(fh, 0);
>
>  #ifdef CONFIG_VIDEO_V4L1_COMPAT
>        /***********************************************************
>
>
>
> And something like this, at dvb core [2]:
>
> diff -r b94d587ee596 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c   Tue May 27 16:02:56 2008 -0300
> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c   Tue May 27 17:35:57 2008 -0300
> @@ -784,6 +784,9 @@
>             cmd == FE_DISEQC_RECV_SLAVE_REPLY))
>                return -EPERM;
>
> +       if (fe->ops.switch_mode)
> +               err = fe->ops.switch_mode(fe, 1);
> +
>        if (down_interruptible (&fepriv->sem))
>                return -ERESTARTSYS;
>
> [1] The code can be more conservative, changing mode only if S_STD or a video
> stream ioctl is called.
>
> [2] We need to think more about the proper places for the DVB changing mode. I
> suspect that we'll need to add the mode change callback there and/or at other
> different places.
>
> PS.: I suspect that the real code will be much more complex than the above skeletons.
>
> Cheers,
> Mauro

These are all good points (and I had come to some of the same
conclusions).  I was just trying to say that the fact that we haven't
worked through these details is a good reason to not attempt to
optimize the locking routines in the em28xx driver at this point.  But
it seems like Arjan's comments make that a moot argument anyway.

Thanks,

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

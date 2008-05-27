Return-path: <video4linux-list-bounces@redhat.com>
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080527180048.6a27dbf7@gaivota>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
	<20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
	<412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
	<20080527180048.6a27dbf7@gaivota>
Content-Type: text/plain
Date: Tue, 27 May 2008 19:48:58 -0400
Message-Id: <1211932138.3197.29.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
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

On Tue, 2008-05-27 at 18:00 -0300, Mauro Carvalho Chehab wrote:
> Hi Devin,
> 
> On Tue, 27 May 2008 15:26:27 -0400
> "Devin Heitmueller" <devin.heitmueller@gmail.com> wrote:
> 
> > Hello Mauro,
> > 
> > On Tue, May 27, 2008 at 2:59 PM, Mauro Carvalho Chehab
> > <mchehab@infradead.org> wrote:
> > > For example, em28xx has already a lock at the operations that change values at
> > > "dev" struct, including open() method. However, since the lock is not called at
> > > get operations, it needs to be fixed. I would also change it from mutex to a
> > > read/write semaphore, since two (or more) get operations can safely happen in
> > > parallel.
> > 
> > Please bear in mind that we have not worked out the locking semantics
> > for hybrid tuner devices, and it's entirely possible that the get()
> > routines will need to switch the tuner mode, which would eliminate any
> > benefits of converting to a read/write semaphore.
> 
> Arjan pointed some good reasons about why we shouldn't use r/w semaphores. So,
> it seems better to keep using mutexes.
> 
> > I'm not sure yet exactly how that's going to work, but it's something
> > that might prompt you to defer converting it from a mutex until we
> > have that worked out.
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

MythTV's mythbackend can open both sides of the card at the same time
and the cx18 driver supports it.  On my HVR-1600, MythTV may have the
digital side of the card open pulling EPG data off of the ATSC
broadcasts, when I open up the MythTV frontend and start watching live
TV on the analog side of the card.  MythTV also supports
Picture-in-Picture using both the analog and digital parts of the
HVR-1600.



> One possible solution of providing a proper code to change mode, and not
> blocking open() would be to write something like this:
> 
> static int check_and_switch_mode(void *priv, int digital)
> {
> 	struct dev_foo *dev = priv;
> 
> 	mutex_lock(dev->lock);
> 
> 	if (digital)
> 		return change_to_digital(dev);
> 	else
> 		return change_to_analog(dev);
> 
> 	mutex_unlock(dev->lock);
> }
> 
> Since this should be called for every valid V4L2 and DVB ioctl, the better
> place for it would be to add this as a new function callback, at video_ioctl2.
> Something like [1]:
> 
> --- a/linux/drivers/media/video/videodev.c	Tue May 27 16:02:56 2008 -0300
> +++ b/linux/drivers/media/video/videodev.c	Tue May 27 17:34:04 2008 -0300
> @@ -821,6 +821,10 @@
>  		v4l_print_ioctl(vfd->name, cmd);
>  		printk("\n");
>  	}
> +
> +	if (_IOC_TYPE(cmd)=='v') || _IOC_TYPE(cmd)=='V') &&
> +		vfd->vidioc_switch_mode)
> +		ret=vfd->vidioc_switch_mode(fh, 0);
>  
>  #ifdef CONFIG_VIDEO_V4L1_COMPAT
>  	/***********************************************************
> 
> 
> 
> And something like this, at dvb core [2]:
> 
> diff -r b94d587ee596 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Tue May 27 16:02:56 2008 -0300
> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Tue May 27 17:35:57 2008 -0300
> @@ -784,6 +784,9 @@
>  	     cmd == FE_DISEQC_RECV_SLAVE_REPLY))
>  		return -EPERM;
>  
> +	if (fe->ops.switch_mode)
> +		err = fe->ops.switch_mode(fe, 1);
> +
>  	if (down_interruptible (&fepriv->sem))
>  		return -ERESTARTSYS;
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
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

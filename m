Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DGQ5og010740
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 11:26:05 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1DGPW9l002490
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 11:25:33 -0500
Received: by wa-out-1112.google.com with SMTP id j37so99544waf.7
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 08:25:22 -0800 (PST)
Message-ID: <ad2672040802130825m29cb1d57q9522a7846c3c8d9d@mail.gmail.com>
Date: Wed, 13 Feb 2008 11:25:22 -0500
From: "Ken Bender" <bender647@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: Support for IVC4300 (go7007 / saa7113)
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

> > Where would I start if I wanted to try and make the go7007 driver
> > work for this card?
>
> Hard to tell without having suitable hardware. As ivtv maintainer (for
> the Conexant cx23415/6 MPEG encoder/decoder chips) I have a vested
> interest in getting MPEG boards to work. So I'm willing to help with
> advice and some coding to try to get this driver into the kernel.
> However, without actual hardware there isn't much I can do.
>
> The go7007 driver is a typical driver made by a company without much
> regard to future inclusion with the kernel: e.g. proprietry ioctls,
> hardcoded saa7113/5 support instead of relying on the corresponding
> kernel modules, etc. Not very nice.
>
> I just tried to compile the 0.9.8 driver and it looks like the
> snd-go7007.c source is the one that has the most problems. I'm no ALSA
> expert so I can't tell whether it is just a matter of some missing
> includes or whether it needs more work. Besides that the use of
> AUDC_SET_INPUT needs to be fixed and should be replaced with
> VIDIOC_INT_S_AUDIO_ROUTING (see the media/v4l2-common.h header from the
> kernel). This is just to get it to compile. To get it into the kernel
> would require a lot more changes.
>
> Regards,
>
>         Hans

I know this is an old thread, but I'd love it if the go7007 drivers didn't
break on every kernel sublevel patch.  If loaning out my Plextor TV-402U
would help, let me know.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37158 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2CHXUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 18:20:14 -0500
Received: by ghrr11 with SMTP id r11so605952ghr.19
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2012 15:20:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1203072340320.2356@banach.math.auburn.edu>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com>
 <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
 <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
 <20120304082531.1307a9ed@tele> <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com>
 <20120305182736.563df8b4@tele> <CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com>
 <4F55DB8B.8050907@redhat.com> <CAKnx8Y4z6Ai14RRdG6zd=CEDfHqfNr6Mx=x=XtfU9=KZEwmaNA@mail.gmail.com>
 <alpine.LNX.2.00.1203061727300.2208@banach.math.auburn.edu>
 <CAKnx8Y7J7PGrw3ekLGhO=uw2mneHEvCzmt4HtArTtk_iJQ3RuQ@mail.gmail.com> <alpine.LNX.2.00.1203072340320.2356@banach.math.auburn.edu>
From: Xavion <xavion.0@gmail.com>
Date: Fri, 9 Mar 2012 10:19:54 +1100
Message-ID: <CAKnx8Y63szyBdmUxfxZejW6h47tpAc53x7jusV6ztyUTP7HA5w@mail.gmail.com>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux anymore
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: "Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Theodore

> > It looks like I'll have to keep checking eBay for cheap USB v3 (HD)
> > webcams periodically.
>
> Which somebody will need to support because they will probably not work
> out of the box with an OEM driver CD ;-)

Ah yes, there is that aspect to think about before making a purchase
:-).  Actually, I think Linus will be pretty keen to rush support for
USB v3 webcams into the kernel.  Hopefully it won't take too long for
a few cheapies to work in Linux.

> Some of the cheap cameras do work pretty well, actually. But as far as I
> know any resolution better than 640*480 seems to be pretty unusual. Lots
> of "interpolated" higher resolution meaning they have inflated the
> pictures, of course. But some of the 640x480 cameras do better than
> others. And also I should point out that if 4 fps is OK with you then some
> of the cameras do not even do compression. If you could get hold of an old
> SQ905 camera that will do 640x480 it runs on bulk transport and there is
> no compression of frame data at all. Also, what is interesting is that
> with all the cheap cameras they cut corners, of course. But the SQ905
> cameras always seemed to me to tend to have better optics than a lot of
> the other cheap cams. Where they really cut down on features was with the
> controller chip. It will do practically nothing compared to some others.
> The SQ905 used to be advertised as the cheapest camera controller chip on
> the market, once upon a time. But the images one gets from those cameras
> sometimes are not half bad.

Thanks for letting me know about that model.  I think I'll be able to
stay with my SN9C201 for now, especially since I've started using
Motion's auto-brightness setting.  It almost seemed like the sun was
in the room with me last night :-).

> Also I should mention that if one wants to get better images out then it
> is best somehow to capture and save the raw data and process it later.
> This is true for any camera which either produces an uncompressed bitmap
> raw image, and also for any camera which does compression of said bitmap
> image before sending it down to the computer. Everything but JPEG, pretty
> much. Why is this? Because the image processing used with webcams must
> necessarily have speed as the number one priority, else the frame rate
> suffers severely. If one is not thus constrained, it is possible to do a
> much better job with that raw data. But remember that you can maximize
> image quality, or you can maximize frame rate. Choose one of the two.

Yeah, I had a feeling that would be the case.  The following is an
extract from Motion's configuration file.  If I want to maximise
quality, which of these options do you think I should choose?  As you
can see, I've been using the default one (8) lately.

# v4l2_palette allows to choose preferable palette to be use by motion
# to capture from those supported by your videodevice. (default: 8)
# E.g. if your videodevice supports both V4L2_PIX_FMT_SBGGR8 and
# V4L2_PIX_FMT_MJPEG then motion will by default use V4L2_PIX_FMT_MJPEG.
# Setting v4l2_palette to 1 forces motion to use V4L2_PIX_FMT_SBGGR8
# instead.
#
# Values :
# V4L2_PIX_FMT_SN9C10X : 0  'S910'
# V4L2_PIX_FMT_SBGGR8  : 1  'BA81'
# V4L2_PIX_FMT_MJPEG   : 2  'MJPEG'
# V4L2_PIX_FMT_JPEG    : 3  'JPEG'
# V4L2_PIX_FMT_RGB24   : 4  'RGB3'
# V4L2_PIX_FMT_UYVY    : 5  'UYVY'
# V4L2_PIX_FMT_YUYV    : 6  'YUYV'
# V4L2_PIX_FMT_YUV422P : 7  '422P'
# V4L2_PIX_FMT_YUV420  : 8  'YU12'
; v4l2_palette 8

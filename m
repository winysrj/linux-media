Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55879 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbcEDVpx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 17:45:53 -0400
Date: Wed, 4 May 2016 23:45:40 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
Message-ID: <20160504234540.42dd381d@mir>
In-Reply-To: <CA+55aFxQSUHBvOSqyiqdt2faY6VZSXP0p-cPzRm+km=fk7z4kQ@mail.gmail.com>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
	<CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
	<20160504063902.0af2f4d7@mir>
	<CA+55aFyE82Hi29az_MG9oG0=AEg1o++Wng_DO2RvNHQsSOz87g@mail.gmail.com>
	<20160504212845.21dab7c8@mir>
	<CA+55aFxQSUHBvOSqyiqdt2faY6VZSXP0p-cPzRm+km=fk7z4kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 2016-05-04, Linus Torvalds wrote:
> On Wed, May 4, 2016 at 12:28 PM, Stefan Lippers-Hollmann <s.l-h@gmx.de> wrote:
> >
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -875,7 +875,7 @@ void __media_device_usb_init(struct medi
> >                              const char *board_name,
> >                              const char *driver_name)
> >  {
> > -#ifdef CONFIG_USB
> > +#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)  
> 
> Ok, that should be fine. Can you verify that it builds and works even
> if USB isn't compiled in, but the media core code is?
> 
> IOW, can you test the
> 
>   CONFIG_USB=m
>   CONFIG_MEDIA_CONTROLLER=y
>   CONFIG_MEDIA_SUPPORT=y

Builds (without warnings in drivers/media/media-device.*) and works fine
as well.

> case? Judging by your oops stack trace, I think you currently have
> MEDIA_SUPPORT=m.

My usual configuration (which, as mentioned in the previous mail, now 
builds and works as well) is:

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_CONTROLLER=y
CONFIG_USB=m

> Also, I do wonder if we should move that #if to _outside_ the
> function. Because inside the function, things will compile but
> silently not work (like you found), if it is ever mis-used. Outside
> that function, you'll get link-errors if you try to misuse that
> function.

That would probably be the best approach.

Regards
	Stefan Lippers-Hollmann

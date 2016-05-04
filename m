Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:33209 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbcEDUtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 16:49:53 -0400
MIME-Version: 1.0
In-Reply-To: <20160504212845.21dab7c8@mir>
References: <20160315080552.3cc5d146@recife.lan>
	<20160503233859.0f6506fa@mir>
	<CA+55aFxAor=MJSGFkynu72AQN75bNTh9kewLR4xe8CpjHQQvZQ@mail.gmail.com>
	<20160504063902.0af2f4d7@mir>
	<CA+55aFyE82Hi29az_MG9oG0=AEg1o++Wng_DO2RvNHQsSOz87g@mail.gmail.com>
	<20160504212845.21dab7c8@mir>
Date: Wed, 4 May 2016 13:49:52 -0700
Message-ID: <CA+55aFxQSUHBvOSqyiqdt2faY6VZSXP0p-cPzRm+km=fk7z4kQ@mail.gmail.com>
Subject: Re: [GIT PULL for v4.6-rc1] media updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 4, 2016 at 12:28 PM, Stefan Lippers-Hollmann <s.l-h@gmx.de> wrote:
>
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -875,7 +875,7 @@ void __media_device_usb_init(struct medi
>                              const char *board_name,
>                              const char *driver_name)
>  {
> -#ifdef CONFIG_USB
> +#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)

Ok, that should be fine. Can you verify that it builds and works even
if USB isn't compiled in, but the media core code is?

IOW, can you test the

  CONFIG_USB=m
  CONFIG_MEDIA_CONTROLLER=y
  CONFIG_MEDIA_SUPPORT=y

case? Judging by your oops stack trace, I think you currently have
MEDIA_SUPPORT=m.

Also, I do wonder if we should move that #if to _outside_ the
function. Because inside the function, things will compile but
silently not work (like you found), if it is ever mis-used. Outside
that function, you'll get link-errors if you try to misuse that
function.

              Linus

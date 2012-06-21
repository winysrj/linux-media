Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34441 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2FUCce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 22:32:34 -0400
Received: by obbuo13 with SMTP id uo13so233314obb.19
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 19:32:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20120621T040939-677@post.gmane.org>
References: <4FA96365.3090705@yahoo.fr>
	<4FA964E8.8080209@iki.fi>
	<CAGoCfiy4qkVQwy+zPH+r8jMxMX7heJk6BLPnOMJxF73FnBms+A@mail.gmail.com>
	<loom.20120621T040939-677@post.gmane.org>
Date: Wed, 20 Jun 2012 22:32:33 -0400
Message-ID: <CAGoCfiyWxnmBz0ViJGFsuDXfUK-woT_-FcCJe7Q0Z6_jr6CuHg@mail.gmail.com>
Subject: Re: em28xx : can work on ARM beagleboard ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Julia <julia.cheung723@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2012 at 10:12 PM, Julia <julia.cheung723@gmail.com> wrote:
> hi Devin,
> i don't understand what you mean when you say "analog support for the em28xx is
> known to be broken on ARM right now'', I hope you can give me some advice.
>
> I use Pinnacle DVC100 capture card on cm-t3530 card to capture analog images.
> cm-t3530 uses linux 2.6.32 kernel. at first the card can be correctly detected
> and by the cm-t3530 and generated as the device file /dev/video1.
>
>
> but when I use some application to capture the images by use of v4l2,there is
> something wrong and the strace of the application shows the error message is
> "ioctl(3, VIDIOC_DQBUF, 0xbeeb4a00)      = ? ERESTARTSYS (To be restarted)". The
> same application can correctly capture my usb-camera images.
>  does the problem can be solved?  I am yearning for  your advice.

Hello Julia,

Yeah, the driver is broken with analog on ARM.  I did some work for a
commercial customer (in fact, also on a Compulab board), but haven't
had a chance to clean up any of the patches and get them upstream.

It's likely the problem you are hitting can be fixed by the patch
described here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg28194.html

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

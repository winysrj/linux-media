Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62508 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZLDPnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 10:43:53 -0500
Received: by fxm5 with SMTP id 5so2598371fxm.28
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 07:43:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <44c6f3de0912040631m7a8c195bldf9df89af7df36fa@mail.gmail.com>
References: <44c6f3de0912032000g3aa2a7cbla26b5132d229a6ac@mail.gmail.com>
	 <829197380912032021t3232e391qc3a4c840529f7ed6@mail.gmail.com>
	 <829197380912032117h1d01f80akf3b1ed7d81e3c6bf@mail.gmail.com>
	 <44c6f3de0912040631m7a8c195bldf9df89af7df36fa@mail.gmail.com>
Date: Fri, 4 Dec 2009 10:43:59 -0500
Message-ID: <829197380912040743q620feb3es60f8cd292c26eb7a@mail.gmail.com>
Subject: Re: Hauppage hvr-950q au0828 transfer problem affecting audio and
	perhaps video
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: John S Gruber <johnsgruber@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 4, 2009 at 9:31 AM, John S Gruber <johnsgruber@gmail.com> wrote:
> I produced the dump of URB sizes you requested by adding that printk() line. The
> results are at http://pastebin.com/f26f29133

Hi John,

This is good info (especially since you have kernel timestamps enabled).

Did you have a specific reference to the USB audio spec which said the
packet size has to be on an integer boundary?  I took a look at the
spec last night and didn't see anything to that end.

Do you have a proposed patch to usbaudio.c which "works for you"?  If
so, feel free to send it along and I will review and provide comments.
 If the spec does not require the packets to be on an integer
boundary, perhaps the driver just improperly assumes they will be (and
they were for whatever developer wrote the original code).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

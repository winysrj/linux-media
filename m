Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35070 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZLDOb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 09:31:26 -0500
Received: by bwz27 with SMTP id 27so1984496bwz.21
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 06:31:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912032117h1d01f80akf3b1ed7d81e3c6bf@mail.gmail.com>
References: <44c6f3de0912032000g3aa2a7cbla26b5132d229a6ac@mail.gmail.com>
	<829197380912032021t3232e391qc3a4c840529f7ed6@mail.gmail.com>
	<829197380912032117h1d01f80akf3b1ed7d81e3c6bf@mail.gmail.com>
From: John S Gruber <johnsgruber@gmail.com>
Date: Fri, 4 Dec 2009 09:31:11 -0500
Message-ID: <44c6f3de0912040631m7a8c195bldf9df89af7df36fa@mail.gmail.com>
Subject: Re: Hauppage hvr-950q au0828 transfer problem affecting audio and
	perhaps video
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I am definitely seeing what you are saying with regards to the channel
> flipping back and forth.  Do you know what size URBs are being
> delivered?  If you've got a hacked up version of usbaudio.c, how about
> adding a printk() line which dumps out the URB size and send me a
> dump?
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
I produced the dump of URB sizes you requested by adding that printk() line. The
results are at http://pastebin.com/f26f29133

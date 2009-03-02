Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:39777 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbZCBNVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2009 08:21:32 -0500
Date: Mon, 2 Mar 2009 14:20:04 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Thomas Champagne <lafeuil@gmail.com>
Cc: Anders Blomdell <anders.blomdell@control.lth.se>,
	Linux Media <linux-media@vger.kernel.org>,
	Thomas Kaiser <v4l@kaiser-linux.li>
Subject: Re: Topro 6800 driver
Message-ID: <20090302142004.35aedd1d@free.fr>
In-Reply-To: <1d4c7fd50903010833m78953db6j10cf1bd0a16203ca@mail.gmail.com>
References: <49A8661A.4090907@control.lth.se>
	<20090228113135.4bbbc294@free.fr>
	<49A95428.1090306@control.lth.se>
	<1d4c7fd50903010833m78953db6j10cf1bd0a16203ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 1 Mar 2009 17:33:32 +0100
Thomas Champagne <lafeuil@gmail.com> wrote:

> I have already tried to create a module for my webcam (Topro TP6800).
> It have the same usb id (06a2:0003).
> But I have the same problem as you about the image data. I don't know
> what is the comment tag (FF:FE). I tried to skip the tag or to skip
> the comment with the length after this tag but the image is never
> good. I don't know where start the image. If you want an example of
> the bad result you can download this image :
> http://lafeuil.free.fr/webcam/images/1.jpg
> So, I am also in the dark.

Hi Thomas and Anders,

I add a look at your image (the samplesY is odd) and also at some other
ones in the USB snoop you sent me, and, yes, the exact start and the
parameters of the image are not easy to find.

I tried to ignore the first 7 to 25 bytes without any success. The
image samplesY should be 0x21 (it is not 0x22 - can it be something
else?).

If the webcam can record photos or if the MS-win driver could output
raw images, it would help. Is it possible?

The last solution is to trace the tiny JPEG decoder changing the input
offset until it does not see error of the Huffman code anymore...

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

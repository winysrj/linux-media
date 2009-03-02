Return-path: <linux-media-owner@vger.kernel.org>
Received: from sperry-03.control.lth.se ([130.235.83.190]:57893 "EHLO
	sperry-03.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029AbZCBQ62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 11:58:28 -0500
Message-ID: <49AC102D.4040900@control.lth.se>
Date: Mon, 02 Mar 2009 17:58:21 +0100
From: Anders Blomdell <anders.blomdell@control.lth.se>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Thomas Champagne <lafeuil@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>,
	Thomas Kaiser <v4l@kaiser-linux.li>
Subject: Re: Topro 6800 driver
References: <49A8661A.4090907@control.lth.se>	<20090228113135.4bbbc294@free.fr>	<49A95428.1090306@control.lth.se>	<1d4c7fd50903010833m78953db6j10cf1bd0a16203ca@mail.gmail.com> <20090302142004.35aedd1d@free.fr>
In-Reply-To: <20090302142004.35aedd1d@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 1 Mar 2009 17:33:32 +0100
> Thomas Champagne <lafeuil@gmail.com> wrote:
> 
>> I have already tried to create a module for my webcam (Topro TP6800).
>> It have the same usb id (06a2:0003).
>> But I have the same problem as you about the image data. I don't know
>> what is the comment tag (FF:FE). I tried to skip the tag or to skip
>> the comment with the length after this tag but the image is never
>> good. I don't know where start the image. If you want an example of
>> the bad result you can download this image :
>> http://lafeuil.free.fr/webcam/images/1.jpg
>> So, I am also in the dark.
> 
> Hi Thomas and Anders,
> 
> I add a look at your image (the samplesY is odd) and also at some other
> ones in the USB snoop you sent me, and, yes, the exact start and the
> parameters of the image are not easy to find.
Thanks for trying, though...

> I tried to ignore the first 7 to 25 bytes without any success. The
> image samplesY should be 0x21 (it is not 0x22 - can it be something
> else?).
Beats me.
> 
> If the webcam can record photos or if the MS-win driver could output
> raw images, it would help. Is it possible?
Don't know. The driver states 'TWAIN/VFW/Direct show' compatibility, but if any
of those can be used to get RAW images (do you by this mean JPEG as it comes
from the camera, or truly RAW images [RGB/YUV]).

> The last solution is to trace the tiny JPEG decoder changing the input
> offset until it does not see error of the Huffman code anymore...
Where can I find that?

I have also tried to backtrack through the distributor chain in order to try to
get technical info, since TOPRO doesn't seem to answer emails from ordinary
users. Will see if that gives any results...

Best regards

Anders

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden

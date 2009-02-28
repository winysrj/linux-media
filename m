Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:55864 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZB1PyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 10:54:12 -0500
Message-ID: <49A95E20.9000104@kaiser-linux.li>
Date: Sat, 28 Feb 2009 16:54:08 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: Anders Blomdell <anders.blomdell@control.lth.se>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Champagne <lafeuil@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Topro 6800 driver
References: <49A8661A.4090907@control.lth.se> <20090228113135.4bbbc294@free.fr> <49A95428.1090306@control.lth.se>
In-Reply-To: <49A95428.1090306@control.lth.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Anders

Anders Blomdell wrote:
> Jean-Francois Moine wrote:
>> On Fri, 27 Feb 2009 23:15:54 +0100
>> About the JPEG images, the Huffman table is always the same 
> Does this mean that it's the same for all JPEG images or only for one 
> camera?
> 
> If it's the same for all images, it should mean that I have a way to 
> determine how much I have to chop off after the 0xfffe tag (no illegal 
> huffman codes -> possibly chop at the correct position).
> 
> Comments anyone?
> 

As per definition of JPEG, the Huffman table is always calculated 
especially for each picture to get the best compression. Thus the 
Huffman table and the DQT has to be in the JPEG stream like you see on 
JPEG picture on your HD.
With webcams, it is a bit an other story. The webcam hardware is usually 
not powerful enough to calculate the Huffman table for each frame. 
Therefor a static Huffman table is used. This Huffman table should fit 
more less to the image the camera is producing. With the drawback that 
we cannot achieve the highest compression possible. On the other hand 
the Huffman table is always the same the cam has not to send this in the 
video stream and the stream has less overhead.

In short, the Huffman table is always the same for a given webcam.

I don't think 0xfffe is a valid JPEG marker. 0xfffe is a comment marker 
and the next 2 bytes after this markers tells the length of the comment 
(including the two length byte). So, your comment would be 10300 Bytes 
long. I don't think that such many Bytes are used for a comment when 
they try to have as less as possible overhead.
I think 0xfffe is the start of the compressed data stream and has 
nothing to do with JPEG markers.

Thomas

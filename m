Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58847 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751649AbZEYKJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 06:09:52 -0400
Message-ID: <4A1A6E6E.4030807@gmx.de>
Date: Mon, 25 May 2009 12:09:50 +0200
From: Stefan Below <stefanbelow@gmx.de>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: CPen driver development / image format
References: <4A193230.3040205@gmx.de> <1243176519.3175.74.camel@palomino.walls.org>
In-Reply-To: <1243176519.3175.74.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2009-05-24 at 13:40 +0200, Stefan Below wrote:
>   
> Why does the PBM image have this text in it:
>
> 	# CREATOR: GIMP PNM Filter Version 1.1
>
> if it came from Windows?  Also why does the filename have "crop" in it?
> Did you do some manipulation of the output file from the Windows
> application?
>   
The Problem with the Cpen OCR Software is, that i cannot grab the real 
image form the pen. I can only get an somehow processed image from the 
Cpen software  that i copied to gimp.

I did also some scans with lines etc. and i hope i can figure it out.

I am quite sure that the firmware on the pen gives me only an (inverted) 
black/white image.

Thanks for your hints,
Stefan

> I ask because it may be the case that the C-Pen puts out a format very
> close to the default format the Windows app software would like to save
> things in.  Comparing that default save format to the data in the URBs
> may provide some insight.
>
>
> Also a solid field isn't very helpful for making deductions about the
> image data format.  Try a series of images: vertical line, horizontal
> line, diagonal line, ellipse, rectangle, triangle, and square grid.
> Then comparison of those source images vs the data bytes might give you
> more insight into the format.
>
>
> Godd Luck,
> Andy
>
>   
>> I hope someone can help me to :-)
>>
>> Stefan
>>     
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


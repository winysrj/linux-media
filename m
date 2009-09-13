Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.lie-comtel.li ([217.173.238.89]:56885 "EHLO
	smtp2.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbZIMP7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 11:59:46 -0400
Message-ID: <4AAD16F3.7050805@kaiser-linux.li>
Date: Sun, 13 Sep 2009 17:59:47 +0200
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: leandro Costantino <lcostantino@gmail.com>
CC: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: image quality of Labtec Webcam 2200
References: <4AA9F7A0.5080802@freemail.hu> <20090913092015.485fdbcd@tele>	 <4AACD0D5.1090109@freemail.hu> <c2fe070d0909130742u2b471f7do7ff7bc8a3b6cd688@mail.gmail.com>
In-Reply-To: <c2fe070d0909130742u2b471f7do7ff7bc8a3b6cd688@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2009 04:42 PM, leandro Costantino wrote:
> Actually it based on pac7302. Pac7311/02 also has support ( since gspca1 ).
> 
> I checked some old logs of the pac, and the driver init for 7302 seems ok.
> 
> The "ff ff ff" sequence, seems to been taken in account on conversion.
> (libv4lconvert)
> 
> /* Special Pixart versions of the *_nbits functions, these remove the special
>    ff ff ff xx sequences pixart cams insert from the bitstream */
> #define pixart_fill_nbits(reservoir,nbits_in_reservoir,stream,nbits_wanted) \
> 
> This is really a tricky cam. I be back on windows to do further test.

Hey All

I thought Hans will come in, in this discussion.......

Anyway, I introduced support for the PAC7311 in gspcaV1 in 2006 [1]

Pixart is using a proprietary JEPG Format to code the image. It took me 
(and help from Jörg Schummer) more than a year to find out the basics 
to decode a frame.

They have this 0xffffffxx markers in the stream, I don't know for what 
this is good, just skip it. And they have a "MCU marker" for each MCU. 
As we know so far, this MCU marker tells what Quantization table should 
be used for decoding the MCU.

Hans did implement my findings into lib4vl and improved it :-)

So, when you get this errors, this is due to a unknown format Pixart is 
using.

I guess we should know what marker you get and how the image should look 
like.

Don't forget, this is all re-engineered -> guess work!

Thomas


[1] http://www.kaiser-linux.li/index.php?title=PAC7311

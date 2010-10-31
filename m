Return-path: <mchehab@gaivota>
Received: from smtp-roam1.Stanford.EDU ([171.67.219.88]:60401 "EHLO
	smtp-roam.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753725Ab0JaXHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Oct 2010 19:07:52 -0400
Message-ID: <4CCDF6B7.1040708@stanford.edu>
Date: Sun, 31 Oct 2010 16:07:35 -0700
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Bastian Hecht <hechtb@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New media framework user space usage
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>	<AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>	<201010290139.10204.laurent.pinchart@ideasonboard.com>	<AANLkTinWnGtb32kBNwoeN27OcCh7sVvZOoC=Vi1BtOua@mail.gmail.com>	<AANLkTimJu-QDToxGNWKPj_B4QM_iO_x6G6eE4U2WnDPB@mail.gmail.com>	<AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com>	<AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>	<4CCB1443.9080509@stanford.edu> <AANLkTimY+sWWxF9+9P5uq8nDeSPdq0jRegtkfvEWRj-+@mail.gmail.com>
In-Reply-To: <AANLkTimY+sWWxF9+9P5uq8nDeSPdq0jRegtkfvEWRj-+@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 10/31/2010 4:51 AM, Bastian Hecht wrote:
> The output format of the sensor is
> R   Gr
> Gb B
>
> The same colorspace is given as example in spruf98k on page 1409.
> There I am still confused about the sematic of 1 pixel. Is it the
> quadruple of the bayer values or each component? Or does it depend on
> the context? Does the the sensor send 5MP data to the isp or 5MPx4
> bayer values? Does the 12-bit width belong to each bayer value? In the
> sensor you read from right to left, I don't know if the ISP doc means
> reading left to right. And so on and so on...
>
To clarify this: The number of pixels in an image sensor is typically 
simply the number of independent photosites - so the 5-MP MT9P031 sensor 
will give you a raw image with 5 million 12-bit values in it. (not 5x3 
million, or 5x4 million, just 5 million)

Each photosite is covered by a single color filter, so each 12-bit raw 
value represents a single color channel, and it is the only color 
channel measured at that pixel.

Which color channel is recorded for each pixel depends on the 
arrangement of the color filters. The most common arrangement is the 
Bayer pattern, which you wrote:
G R G R G R G R
B G B G B G B G
G R G R G R G R
B G B G B G B G
So the top-left pixel in the sensor is covered by a green filter, the 
one to the right of it is covered by a red filter, the one below it is a 
blue filter. The pattern tiles across the whole sensor in this fashion. 
(Note that which color is the top-leftmost does vary between sensors, 
but the basic repeating tile is the same - two greens for each red and 
blue, diagonally arranged)

To convert this 5-million-pixel raw image into a 5-million-pixel RGB 
image, you have to demosaic the image - come up with the missing two 
color values for each pixel. It suffices to say that there are lots of 
ways to do this, of varying levels of complexity and quality.

The OMAP3 ISP preview pipe runs such a method in hardware, to give you a 
3-channel YUV 4:2:2 output from a raw sensor image, with 5 million Y 
values, 2.5 million U, and 2.5 million V values.  There is a 3x3 color 
conversion matrix inside the preview pipeline that converts from the 
sensor's RGB space to a standard RGB space (at least if you set up the 
matrix right), and then a second matrix to go from that RGB space to 
YUV. The number of bits per channel also gets reduced from 10 to 8 using 
a gamma lookup table.

So if you ask the ISP for raw data, you get 5 million 16-bit values (of 
which only the lower 10 or 12 bits are valid) total. If you ask it for 
YUV data, you'll get 10 million 8-bit values.

Hope that clarifies, and doesn't further confuse things.

Eino-Ville Talvala
Stanford University





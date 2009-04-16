Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:59482 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZDPFOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 01:14:40 -0400
Received: by yx-out-2324.google.com with SMTP id 31so216628yxl.1
        for <linux-media@vger.kernel.org>; Wed, 15 Apr 2009 22:14:39 -0700 (PDT)
From: Kyle Guinn <elyk03@gmail.com>
To: kilgota@banach.math.auburn.edu
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
Date: Thu, 16 Apr 2009 00:14:32 -0500
Cc: Thomas Kaiser <v4l@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu> <49AE3EA1.3090504@kaiser-linux.li>
In-Reply-To: <49AE3EA1.3090504@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904160014.32558.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 March 2009 02:41:05 Thomas Kaiser wrote:
> Hello Theodore
>
> kilgota@banach.math.auburn.edu wrote:
> > Also, after the byte indicator for the compression algorithm there are
> > some more bytes, and these almost definitely contain information which
> > could be valuable while doing image processing on the output. If they
> > are already kept and passed out of the module over to libv4lconvert,
> > then it would be very easy to do something with those bytes if it is
> > ever figured out precisely what they mean. But if it is not done now it
> > would have to be done then and would cause even more trouble.
>
> I sent it already in private mail to you. Here is the observation I made
> for the PAC207 SOF some years ago:
>
>  From usb snoop.
> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
> 1. xx: looks like random value
> 2. xx: changed from 0x03 to 0x0b
> 3. xx: changed from 0x06 to 0x49
> 4. xx: changed from 0x07 to 0x55
> 5. xx: static 0x96
> 6. xx: static 0x80
> 7. xx: static 0xa0
>
> And I did play in Linux and could identify some fields :-) .
> In Linux the header looks like this:
>
> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
> 1. xx: don't know but value is changing between 0x00 to 0x07
> 2. xx: this is the actual pixel clock
> 3. xx: this is changing according light conditions from 0x03 (dark) to
> 0xfc (bright) (center)
> 4. xx: this is changing according light conditions from 0x03 (dark) to
> 0xfc (bright) (edge)
> 5. xx: set value "Digital Gain of Red"
> 6. xx: set value "Digital Gain of Green"
> 7. xx: set value "Digital Gain of Blue"
>
> Thomas

I've been looking through the frame headers sent by the MR97310A (the Aiptek 
PenCam VGA+, 08ca:0111).  Here are my observations.

FF FF 00 FF 96 6x x0 xx xx xx xx xx

In binary that looks something like this:

11111111 11111111 00000000 11111111
10010110 011001aa a1010000 bbbbbbbb
bbbbbbbb cccccccc ccccdddd dddddddd

All of the values look to be MSbit first.  A looks like a 3-bit frame sequence 
number that seems to start with 1 and increments for each frame.  B, C, and D 
might be brightness and contrast; minimum and maximum values for these vary 
with the image size.

For 640x480, 320x240, and 160x120:
  dark scene (all black):
    B:  near 0
    C:  0x000
    D:  0xC60

  bright scene (all white):
    B:  usually 0xC15C
    C:  0xC60
    D:  0x000

For 352x288 and 176x144:
  dark scene (all black):
    B:  near 0
    C:  0x000
    D:  0xB5B

  bright scene (all white):
    B:  usually 0xB0FE
    C:  0xB53
    D:  0x007

B increases with increasing brightness.  C increases with more white pixels 
and D increases with more black pixels.  A gray image has C and D near zero, 
while a high-contrast image (half black, half white) has C and D around 0x600 
or so.  The sum of C and D is not a constant.

I don't know how brightness and contrast are handled in V4L.  Hopefully 
someone can put this to use.
-Kyle

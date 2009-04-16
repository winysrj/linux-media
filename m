Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:43598 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536AbZDPSJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 14:09:24 -0400
Date: Thu, 16 Apr 2009 13:22:11 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Kyle Guinn <elyk03@gmail.com>
cc: Thomas Kaiser <v4l@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <200904160014.32558.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0904161247530.10195@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu> <49AE3EA1.3090504@kaiser-linux.li> <200904160014.32558.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 16 Apr 2009, Kyle Guinn wrote:

> On Wednesday 04 March 2009 02:41:05 Thomas Kaiser wrote:
>> Hello Theodore
>>
>> kilgota@banach.math.auburn.edu wrote:
>>> Also, after the byte indicator for the compression algorithm there are
>>> some more bytes, and these almost definitely contain information which
>>> could be valuable while doing image processing on the output. If they
>>> are already kept and passed out of the module over to libv4lconvert,
>>> then it would be very easy to do something with those bytes if it is
>>> ever figured out precisely what they mean. But if it is not done now it
>>> would have to be done then and would cause even more trouble.
>>
>> I sent it already in private mail to you. Here is the observation I made
>> for the PAC207 SOF some years ago:
>>
>>  From usb snoop.
>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
>> 1. xx: looks like random value
>> 2. xx: changed from 0x03 to 0x0b
>> 3. xx: changed from 0x06 to 0x49
>> 4. xx: changed from 0x07 to 0x55
>> 5. xx: static 0x96
>> 6. xx: static 0x80
>> 7. xx: static 0xa0
>>
>> And I did play in Linux and could identify some fields :-) .
>> In Linux the header looks like this:
>>
>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
>> 1. xx: don't know but value is changing between 0x00 to 0x07
>> 2. xx: this is the actual pixel clock
>> 3. xx: this is changing according light conditions from 0x03 (dark) to
>> 0xfc (bright) (center)
>> 4. xx: this is changing according light conditions from 0x03 (dark) to
>> 0xfc (bright) (edge)
>> 5. xx: set value "Digital Gain of Red"
>> 6. xx: set value "Digital Gain of Green"
>> 7. xx: set value "Digital Gain of Blue"
>>
>> Thomas
>
> I've been looking through the frame headers sent by the MR97310A (the Aiptek
> PenCam VGA+, 08ca:0111).  Here are my observations.
>
> FF FF 00 FF 96 6x x0 xx xx xx xx xx
>
> In binary that looks something like this:
>
> 11111111 11111111 00000000 11111111
> 10010110 011001aa a1010000 bbbbbbbb
> bbbbbbbb cccccccc ccccdddd dddddddd
>
> All of the values look to be MSbit first.  A looks like a 3-bit frame sequence
> number that seems to start with 1 and increments for each frame.

Hmmm. This I never noticed. What you are saying is that the two bytes 6x 
and x0 are variable? You are sure about that? What I have previously 
experienced is that the first is always 64 with these cameras, and the 
second one indicates the absence of compression (in which case it is 0, 
which of course only arises for still cameras), or if there is data 
compression then it is not zero. I have never seen this byte to change 
during a session with a camera. Here is a little table of what I have 
previously witnessed, and perhaps you can suggest what to do in order to 
see this is not happening:

Camera		that byte	compression	solved, or not	streaming
Aiptek 		00		no		N/A		no
Aiptek		50		yes		yes		both
the Sakar cam	00		no		N/A		no
ditto		50		yes		yes		both
Argus QuikClix	20		yes		no	doesn't work
Argus DC1620	50		yes		yes	doesn't work 
CIF cameras	00		no		N/A		no
ditto		50		yes		yes		no
ditto		d0		yes		no		yes

Other strange facts are

-- that the Sakar camera, the Argus QuikClix, and the 
DC1620 all share the same USB ID of 0x93a:0x010f and yet only one of them 
will stream with the existing driver. The other two go through the 
motions, but the isoc packets do not actually get sent, so there is no 
image coming out. I do not understand the reason for this; I have been 
trying to figure it out and it is rather weird. I should add that, yes, 
those two cameras were said to be capable of streaming when I bought them. 
Could it be a problem of age? I don't expect that, but maybe.

-- the CIF cameras all share the USB id of 0x93a:0x010e (I bought several 
of them) and they all are using a different compression algorithm while 
streaming from what they use if running as still cameras in compressed 
mode. This leads to the question whether it is possible to set the 
compression algorithm during the initialization sequence, so that the 
camera also uses the "0x50" mode while streaming, because we already know 
how to use that mode.

But I have never seen the 0x64 0xX0 bytes used to count the frames. Could 
you tell me how to repeat that? It certainly would knock down the validity 
of the above table wouldn't it?

B, C, and D
> might be brightness and contrast; minimum and maximum values for these vary
> with the image size.
>
> For 640x480, 320x240, and 160x120:
>  dark scene (all black):
>    B:  near 0
>    C:  0x000
>    D:  0xC60
>
>  bright scene (all white):
>    B:  usually 0xC15C
>    C:  0xC60
>    D:  0x000
>
> For 352x288 and 176x144:
>  dark scene (all black):
>    B:  near 0
>    C:  0x000
>    D:  0xB5B
>
>  bright scene (all white):
>    B:  usually 0xB0FE
>    C:  0xB53
>    D:  0x007
>
> B increases with increasing brightness.  C increases with more white pixels
> and D increases with more black pixels.  A gray image has C and D near zero,
> while a high-contrast image (half black, half white) has C and D around 0x600
> or so.  The sum of C and D is not a constant.

Yes, in crude outlines of course I already understood that something of 
this sort is happening. That is, after all, the prime reason why I came 
along with a patch which preserves the header and passes it along 
instead of tossing it out with the trash. My question was whether anyone 
knows more about this, or whether some kind of standard (not 
vendor-specific or chipset-specific) format is involved there, and in 
particular what was meant by the description of these as Red, Green or 
Blue "Gain" settings.

>
> I don't know how brightness and contrast are handled in V4L.  Hopefully
> someone can put this to use.
> -Kyle
>

This is something which is up to V4L, of course. But I have been 
interested for a long time in these cameras as still cameras. And the 
headers there look just about the same and obviously pass along the same 
kind of information.

I might also mention that one of the things I did about a year ago was to 
introduce some brightness, color balance and contrast setting routines in 
several of my still camera drivers, including specifically the 
camlibs/mars driver which supports these particular cameras. Those 
routines work by analysing the data in the photo (frame) and then doing 
certain changes. The routines rely only slightly on input such as these 
mysterious bytes we are discussing here, because I do not know enough 
about these mysterious bytes. The routines do give significantly better 
imaging results. I do not know if they would be too time-consuming to use 
in V4L. Possibly, they would. I have run no analysis on the routines, 
regarding speed. If you want to look at those routines and try them out on 
raw test images, then you can find a standalone raw converter in the 
directory playground/raw_converters/mars, on the Gphoto SVN site. Since 
you are interested in the MR97310a cameras, you might be interested in 
that.

Theodore Kilgore

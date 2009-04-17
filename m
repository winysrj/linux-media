Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59529 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbZDQIdq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 04:33:46 -0400
Message-ID: <49E83F7D.2000508@redhat.com>
Date: Fri, 17 Apr 2009 10:36:13 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Thomas Kaiser <v4l@kaiser-linux.li>, Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: Some questions about mr97310 controls (continuing previous thread
 on mr97310a.c)
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu> <49AE3EA1.3090504@kaiser-linux.li> <49AE41DE.1000300@kaiser-linux.li> <alpine.LNX.2.00.0903041248020.22500@banach.math.auburn.edu> <49AFCD5B.4050100@kaiser-linux.li> <alpine.LNX.2.00.0904151850240.9310@banach.math.auburn.edu> <49E7587C.6010803@kaiser-linux.li> <alpine.LNX.2.00.0904161738120.10418@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0904161738120.10418@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On 04/17/2009 12:50 AM, Theodore Kilgore wrote:
>
>
> On Thu, 16 Apr 2009, Thomas Kaiser wrote:
>

<snip>

>>>
>>> Just how does it work to set the "Compression Balance size"? Is this
>>> some kind of special command sequence? Are we able to set this to
>>> whatever we want?
>>
>> It looks like. One can set a value from 0x0 to 0xff in the
>> "Compression Balance size" register (reg 0x4a).
>> In the pac207 Linux driver, this register is set to 0xff to turn off
>> the compression. While we use compression 0x88 is set (I think the
>> same value like in Windoz). Hans did play with this register and found
>> out that the compression changes with different values.
>
> I wonder how this relates to the mr97310a. There is no such register
> present, that I can see.
>
>>
>> Hans, may you explain a bit more what you found out?
>
> (Yes, please.)
>

Quoting from linux/drivers/media/video/gspca/pac207.c
(easiest for me as it has been a while I looked at this):

/* An exposure value of 4 also works (3 does not) but then we need to lower
    the compression balance setting when in 352x288 mode, otherwise the usb
    bandwidth is not enough and packets get dropped resulting in corrupt
    frames. The problem with this is that when the compression balance gets
    lowered below 0x80, the pac207 starts using a different compression
    algorithm for some lines, these lines get prefixed with a 0x2dd2 prefix
    and currently we do not know how to decompress these lines, so for now
    we use a minimum exposure value of 5 */
#define PAC207_EXPOSURE_MIN             5
#define PAC207_EXPOSURE_MAX             26

And from libv4l/libv4lconvert/pac207.c:


void v4lconvert_decode_pac207(const unsigned char *inp, unsigned char *outp,
   int width, int height)
{
/* we should received a whole frame with header and EOL marker
in myframe->data and return a GBRG pattern in frame->tmpbuffer
remove the header then copy line by line EOL is set with 0x0f 0xf0 marker
or 0x1e 0xe1 for compressed line*/
     unsigned short word;
     int row;

     /* iterate over all rows */
     for (row = 0; row < height; row++) {
         word = getShort(inp);
         switch (word) {
         case 0x0FF0:
             memcpy(outp, inp + 2, width);
             inp += (2 + width);
             break;
         case 0x1EE1:
             inp += pac_decompress_row(inp, outp, width);
             break;
         case 0x2DD2: /* prefix for "stronger" compressed lines, currently the
                         kernel driver programs the cam so that we should not
                         get any of these */

         default: /* corrupt frame */
             /* FIXME add error reporting */
             return;
         }
         outp += width;
     }



So iow, the pac207 prefixes each row of a frame it sends out with 2 bytes,
indication the type of compression used, 0FF0 == no compression,
1ee1 == compression currently known in libv4l

But if you lower the compression balance register below 0x80, it will also
send out rows prefixed with 2DD2, and we (I) have no clue how to decompress
these. If we could find out how to handle these, that would be great, as we
then could lower the exposure time more when in full daylight, curing the
over exposure problems we have in full daylight.

Regards,

Hans

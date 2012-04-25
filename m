Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab2DYORf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Apr 2012 10:17:35 -0400
Message-ID: <4F98080D.5040901@redhat.com>
Date: Wed, 25 Apr 2012 16:19:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] tinyjpeg: Dynamic luminance quantization table for
 Pixart JPEG
References: <20120412122017.0c808009@tele> <4F95CACD.5010403@redhat.com> <20120424123412.3b63810d@tele>
In-Reply-To: <20120424123412.3b63810d@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/24/2012 12:34 PM, Jean-Francois Moine wrote:
> On Mon, 23 Apr 2012 23:34:05 +0200
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
>> Thanks for your work on this! I've just spend almost 4 days wrestling
>> which the Pixart JPEG decompression code to try to better understand
>> these cams, and I have learned quite a bit and eventually came up
>> with a different approach.
>>
>> But your effort is appreciated! After spending so much time on this
>> myself, I can imagine that it took you quite some time to come up
>> with your solution.
>>
>> Attach is a 4 patch patchset which I plan to push to v4l-utils
>> tomorrow (after running some more tests in daylight). I'll also try
>> to do some kernel patches tomorrow to match...
>
> Hi Hans,
>
> I tried your patch, but I am not happy with the images I have (pac7302).
>
> You say that the marker cannot be in the range 0..31 (index 0..7), but
> I have never seen a value lower than 68 (index 17).

If you change register 0x80 in bank/page 1 to > 42 on pac7311 or larger then
circa 100 on pac7302, you will get markers with bit 8 set. When this happens
you will initially get markers 0xa0 - 0xa4 ... 0xbc and the stream tends to
stabilize on 0xbc. Likewise if you remove the artificial limiting of
the pac7302 to 15 fps from the driver you will get markers 0x44 - 0x48 ...
0x7c.

The images look a lot better with bit 8 set, so I plan to run some tests
wrt what framerates can safely handle that (it uses more bandwidth) and set
bit 8 on lower framerates.

>
> This last marker value (68) is the default when the images have no big
> contrasts. With such images / blocks, the standard JPEG quantization
> table does not work well. It seems that, for this value, the table
> should be full of either 7 or 8 (8 gives a higher contrast).

Using a table with all 7's or 8's looses a lot of sharpness in image which
high frequency components, for example the grain of a rough wall completely
disappears.

I've (once more) tried to use a more simplified / flat quant table, I
ended up with the table below, so as to not loose too much sharpness:

                0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x10, 0x10,
                0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x20,
                0x20, 0x20, 0x20, 0x20, 0x20,
                                              0x28, 0x28, 0x28,
                0x28, 0x28, 0x28, 0x28,
                                        0x30, 0x30, 0x30, 0x30,
                0x30, 0x30, 0x30, 0x30,
                                        0x38, 0x38, 0x38, 0x38,
                0x38, 0x38, 0x38,
                                  0x40, 0x40, 0x40, 0x40, 0x40,
                0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40,
                0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40,

Using the same qfactor as before, so the 0x0b translates to 7, with this
table the images only change slightly, mostly because of the lower
values at the end. This means we loose some sharpness of the picture
(loose of high frequency components), and when watching a moving picture
with that loose of sharpness we also loose some noise. But other then that
the results are almost the same.

When using 0x08 rather then 0x07 we seem to get accumlating DC errors,
leading to clear block divisions at the end of an mcu row.

Given the above I've decided to stick with my solution for now, I know
it is not the ideal solution, but I believe it is the best we have. Also
notice that my solution in essence gives us the same table for marker 68
as we used before your "tinyjpeg: Better luminance quantization table for
Pixart JPEG" patch.





>
> Here is the sequence which works better (around line 1420 of tinyjpeg.c):
>
> -------------8<--------------
> 		/* And another special Pixart feature, the DC quantization
> 		   factor is fixed! */
> 		qt[0] = 7;			// 8 gives a higher contrast
> // special case for 68
> 	if (marker == 68) {
> 		for (i = 1; i<  64; i++)
> 			qt[i] = 7;		// also works with 8
> 	} else {
> 		for (i = 1; i<  64; i++) {
> 			j = (standard_quantization[0][i] * comp + 50) / 100;
> 			qt[i] = (j<  255) ? j : 255;
> 		}
> 	}
> 		build_quantization_table(priv->Q_tables[0], qt);
> -------------8<--------------
>
> About the other marker values, it seems also that the quantization
> tables are not optimal: some blocks are either too much (small
> contrasted lines) or not enough (big pixels) decompressed. As you know,
> a finer adjustment would ask for a long test time, so, I think we can
> live with your code.

Yeah short of someone disassembling and reverse-engineering the windows driver
we will probably never figure out the exact correct tables.

Regards,

Hans

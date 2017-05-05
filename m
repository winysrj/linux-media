Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:46080 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752224AbdEED3S (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 23:29:18 -0400
Subject: Re: [PATCH 2/4] [media] pxa_camera: Fix incorrect test in the image
 size generation
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <cover.1493612057.git.petr.cvek@tul.cz>
 <1e599794-36e7-3b26-8bb0-57c5b31d3956@tul.cz> <871ss71fq3.fsf@belgarion.home>
Cc: linux-media@vger.kernel.org
From: Petr Cvek <petr.cvek@tul.cz>
Message-ID: <386987a8-64e3-a0ee-a571-acfd33145181@tul.cz>
Date: Fri, 5 May 2017 05:30:35 +0200
MIME-Version: 1.0
In-Reply-To: <871ss71fq3.fsf@belgarion.home>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 2.5.2017 v 16:43 Robert Jarzmik napsal(a):
> Petr Cvek <petr.cvek@tul.cz> writes:
> 
>> During the transfer from the soc_camera a test in pxa_mbus_image_size()
>> got removed. Without it any PXA_MBUS_LAYOUT_PACKED format causes either
>> the return of a wrong value (PXA_MBUS_PACKING_2X8_PADHI doubles
>> the correct value) or EINVAL (PXA_MBUS_PACKING_NONE and
>> PXA_MBUS_PACKING_EXTEND16). This was observed in an error from the ffmpeg
>> (for some of the YUYV subvariants).
>>
>> This patch re-adds the same test as in soc_camera version.
>>
>> Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
> Did you test that with YUV422P format ?
> If yes, then you can have my ack.
> 

I was trying to add RGB888 and then I've noticed that "YVYU 16bit" formats (and permutation) and "Bayer 12" formats have incorrect values in the bits_per_sample field. I didn't notice it in the patch creation, because it doesn't affect the computations of the image size. And later in the code it just defaults to 8.

A comment for a switch in the pxa_camera_setup_cicr() function:

	"Datawidth is now guaranteed to be equal to one of the three values..."

Values are 10, 9 and 8 and they describe a bit-vector length of the interface for a sensor.

So I will include a fix for the patchset v2 for this. I will test the YUYV formats, but my sensor does not support the Bayer 12 formats. 

In the addition I propose a patch for an enum type (or define) of the interface configuration field. Something like:
	#define PXA_MBUS_BUSWIDTH_8	8
	#define PXA_MBUS_BUSWIDTH_9	9
	#define PXA_MBUS_BUSWIDTH_10	10
and a patch for something like:
	s/bits_per_sample/buswidth/g
and a formatting patch for excessive tabulators in the mbus_fmt structure initialization ;-).

Petr

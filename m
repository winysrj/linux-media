Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:55488 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1GNHDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 03:03:46 -0400
Message-ID: <4E1E94D0.20702@matrix-vision.de>
Date: Thu, 14 Jul 2011 09:03:44 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] capture-example: allow V4L2_PIX_FMT_GREY with USERPTR
References: <1309270998-5070-1-git-send-email-michael.jones@matrix-vision.de> <4E1E1DC2.1070505@redhat.com>
In-Reply-To: <4E1E1DC2.1070505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 07/14/2011 12:35 AM, Mauro Carvalho Chehab wrote:
> Em 28-06-2011 11:23, Michael Jones escreveu:
>> There is an assumption that the format coming from the device
>> needs 2 bytes per pixel, which is not the case when the device
>> delivers e.g. V4L2_PIX_FMT_GREY. This doesn't manifest itself with
>> IO_METHOD_MMAP because init_mmap() (the default) doesn't take
>> sizeimage as an argument.
>>
>> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
>> ---
>>
>> This same issue would apply to other formats which have 1 byte per pixel,
>> this patch only fixes it for GREY.  Is this OK for now, or does somebody
>> have a better suggestion for supporting other formats as well?
> 
> Well, just rely on the bytesperline provided by the driver should be enough.
> Devices should be returning it on a consistent way.
> 
> Regards,
> Mauro

So you would rather remove the "Buggy driver paranoia" altogether and
just trust the bytesperline from the driver? That's fine with me, but I
presumed the paranoia was there for a reason. Would you accept a patch
then that just removes the 7 lines which fiddle with bytesperline?

-Michael

> 
>>
>>  contrib/test/capture-example.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/contrib/test/capture-example.c b/contrib/test/capture-example.c
>> index 3852c58..0eb5235 100644
>> --- a/contrib/test/capture-example.c
>> +++ b/contrib/test/capture-example.c
>> @@ -416,6 +416,7 @@ static void init_device(void)
>>  	struct v4l2_crop crop;
>>  	struct v4l2_format fmt;
>>  	unsigned int min;
>> +	unsigned int bytes_per_pixel;
>>  
>>  	if (-1 == xioctl(fd, VIDIOC_QUERYCAP, &cap)) {
>>  		if (EINVAL == errno) {
>> @@ -519,7 +520,8 @@ static void init_device(void)
>>  	}
>>  
>>  	/* Buggy driver paranoia. */
>> -	min = fmt.fmt.pix.width * 2;
>> +	bytes_per_pixel = fmt.fmt.pix.pixelformat == V4L2_PIX_FMT_GREY ? 1 : 2;
>> +	min = fmt.fmt.pix.width * bytes_per_pixel;
>>  	if (fmt.fmt.pix.bytesperline < min)
>>  		fmt.fmt.pix.bytesperline = min;
>>  	min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
> 


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier

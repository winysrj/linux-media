Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:57496 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbINFsN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 01:48:13 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NUN024PRK4BLW70@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Sep 2015 14:48:11 +0900 (KST)
Message-id: <55F65F9A.3060304@samsung.com>
Date: Mon, 14 Sep 2015 14:48:10 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v4 1/8] [media] videobuf2: Replace videobuf2-core with
 videobuf2-v4l2
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
 <1441797597-17389-2-git-send-email-jh1009.sung@samsung.com>
 <55F28AA9.3000408@xs4all.nl>
In-reply-to: <55F28AA9.3000408@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/11/2015 05:02 PM, Hans Verkuil wrote:
> On 09/09/2015 01:19 PM, Junghak Sung wrote:
>> Make videobuf2-v4l2 as a wrapper of videobuf2-core for v4l2-use.
>> And replace videobuf2-core.h with videobuf2-v4l2.h.
>> This renaming change should be accompanied by the modifications
>> of all device drivers that include videobuf2-core.h.
>> It can be done with just running this shell script.
>>
>> replace()
>> {
>> str1=$1
>> str2=$2
>> dir=$3
>> for file in $(find $dir -name *.h -o -name *.c -o -name Makefile)
>> do
>>      echo $file
>>      sed "s/$str1/$str2/g" $file > $file.out
>>      mv $file.out $file
>> done
>> }
>>
>> replace "videobuf2-core" "videobuf2-v4l2" "include/media/"
>> replace "videobuf2-core" "videobuf2-v4l2" "drivers/media/"
>> replace "videobuf2-core" "videobuf2-v4l2" "drivers/usb/gadget/"
>>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> However, see one small comment below:
>
> <snip>
>
>> diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
>> index 8f61456..bef9127 100644
>> --- a/include/media/videobuf2-dvb.h
>> +++ b/include/media/videobuf2-dvb.h
>> @@ -6,7 +6,7 @@
>>   #include <dvb_demux.h>
>>   #include <dvb_net.h>
>>   #include <dvb_frontend.h>
>> -#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-v4l2.h>
>
> I actually think this should remain core.h since videobuf2-dvb.c/h has
> nothing to do with v4l2.
>
> Regards,
>
> 	Hans
>

I agree with you.
In this patch series, vb2_thread_*() are still remained in
videobuf2-v4l2, because vb2_tread_*() and vb2_fileio_*() have
dependencies on v4l2 and it is not easy to remove them completely.
I'll try to remove the dependencies and make
videobuf2-dvb to include videobuf2-core instead of videobuf2-v4l2
at next round.

Regards,
Junghak

>>
>>   struct vb2_dvb {
>>   	/* filling that the job of the driver */
>
>

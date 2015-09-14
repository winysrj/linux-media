Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57215 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbbINGef (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2015 02:34:35 -0400
Message-ID: <55F66A2D.2010005@xs4all.nl>
Date: Mon, 14 Sep 2015 08:33:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v4 1/8] [media] videobuf2: Replace videobuf2-core
 with videobuf2-v4l2
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com> <1441797597-17389-2-git-send-email-jh1009.sung@samsung.com> <55F28AA9.3000408@xs4all.nl> <55F65F9A.3060304@samsung.com>
In-Reply-To: <55F65F9A.3060304@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2015 07:48 AM, Junghak Sung wrote:
> 
> 
> On 09/11/2015 05:02 PM, Hans Verkuil wrote:
>> On 09/09/2015 01:19 PM, Junghak Sung wrote:
>>> Make videobuf2-v4l2 as a wrapper of videobuf2-core for v4l2-use.
>>> And replace videobuf2-core.h with videobuf2-v4l2.h.
>>> This renaming change should be accompanied by the modifications
>>> of all device drivers that include videobuf2-core.h.
>>> It can be done with just running this shell script.
>>>
>>> replace()
>>> {
>>> str1=$1
>>> str2=$2
>>> dir=$3
>>> for file in $(find $dir -name *.h -o -name *.c -o -name Makefile)
>>> do
>>>      echo $file
>>>      sed "s/$str1/$str2/g" $file > $file.out
>>>      mv $file.out $file
>>> done
>>> }
>>>
>>> replace "videobuf2-core" "videobuf2-v4l2" "include/media/"
>>> replace "videobuf2-core" "videobuf2-v4l2" "drivers/media/"
>>> replace "videobuf2-core" "videobuf2-v4l2" "drivers/usb/gadget/"
>>>
>>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>>> Acked-by: Inki Dae <inki.dae@samsung.com>
>>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> However, see one small comment below:
>>
>> <snip>
>>
>>> diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
>>> index 8f61456..bef9127 100644
>>> --- a/include/media/videobuf2-dvb.h
>>> +++ b/include/media/videobuf2-dvb.h
>>> @@ -6,7 +6,7 @@
>>>   #include <dvb_demux.h>
>>>   #include <dvb_net.h>
>>>   #include <dvb_frontend.h>
>>> -#include <media/videobuf2-core.h>
>>> +#include <media/videobuf2-v4l2.h>
>>
>> I actually think this should remain core.h since videobuf2-dvb.c/h has
>> nothing to do with v4l2.
>>
>> Regards,
>>
>> 	Hans
>>
> 
> I agree with you.
> In this patch series, vb2_thread_*() are still remained in
> videobuf2-v4l2, because vb2_tread_*() and vb2_fileio_*() have
> dependencies on v4l2 and it is not easy to remove them completely.

Ah, OK. It's for the thread usage.

> I'll try to remove the dependencies and make
> videobuf2-dvb to include videobuf2-core instead of videobuf2-v4l2
> at next round.

I would postpone this. Instead, in the dvb.h header you should add a
comment that explains why you need v4l2.h.

Later we should look into moving the file/threadio code to core. It
really belongs there, but it might be a bit tricky to split off the
v4l2-specific bits. Of course, if you think you can keep the file/threadio
code in core.c, then feel free to do so. It would be nice.

That reminds me: you moved some of the 'if (vb2_fileio_is_active(q))'
to v4l2.c, but perhaps those should remain in core.c. We really want to
have file/threadio support in the core eventually, so keeping those
checks in core.c avoids unnecessary code movements.

Regards,

	Hans

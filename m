Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47055 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0BQScK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 13:32:10 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <p.osciak@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"'Kamil Debski'" <k.debski@samsung.com>
Date: Wed, 17 Feb 2010 12:32:06 -0600
Subject: RE: Fourcc for multiplanar formats
Message-ID: <A69FA2915331DC488A831521EAE36FE40169C5C583@dlee06.ent.ti.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C5635702@bssrvexch01.BS.local>
 <201002171921.36567.hverkuil@xs4all.nl>
In-Reply-To: <201002171921.36567.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I think all of the planar pix format defined in videodev2.h are contiguous in memory. So I would suggest adding some suffix to indicate this so that it is obvious to application users.

>What about V4L2_PIX_FMT_NV16_2P, V4L2_PIX_FMT_YUV422P_3P, etc.?

Not sure what Hans mean by the 2P or 3P extensions since NV16 has 2 planes. Why do we want to re-define NV12 and NV12_2P since it can cause backward compatibility issues. Why don't we keep existing naming convention for
contiguous formats and add a suffix for indicating the planes are not
contiguous. 

For example

V4L2_PIX_FMT_NV16 vs V4L2_PIX_FMT_NV16_NC where NC - Non Contiguous

Just my thoughts...

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Hans Verkuil
>Sent: Wednesday, February 17, 2010 1:22 PM
>To: Pawel Osciak
>Cc: linux-media@vger.kernel.org; Sylwester Nawrocki; 'Kamil Debski'
>Subject: Re: Fourcc for multiplanar formats
>
>On Monday 15 February 2010 17:27:46 Pawel Osciak wrote:
>> Hello,
>>
>> we would like to ask for suggestions for new fourcc formats for
>multiplanar buffers.
>>
>> There are planar formats in V4L2 API, but for all of them, each plane X
>"immediately
>> follows Y plane in memory". We are in the process of testing formats and
>V4L2 extensions
>> that relax those requirements and allow each plane to reside in a
>separate area of
>> memory.
>>
>> I am not sure how we should name those formats though. In our example, we
>are focusing
>> on the following formats at the moment:
>> - YCbCr 422 2-planar (multiplanar version of V4L2_PIX_FMT_NV16)
>> - YCbCr 422 3-planar (multiplanar version of V4L2_PIX_FMT_YUV422P)
>> - YCbCr 420 2-planar (multiplanar version of V4L2_PIX_FMT_NV12)
>> - YCbCr 420 3-planar (multiplanar version of V4L2_PIX_FMT_YUV420)
>>
>>
>> Could anyone give any suggestions how we should name such formats and
>what to pass to
>> the v4l2_fourcc() macro?
>
>What about V4L2_PIX_FMT_NV16_2P, V4L2_PIX_FMT_YUV422P_3P, etc.?
>
>What we pass to the fourcc macro is not very important IMHO. As long as it
>is unique.
>
>Regards,
>
>	Hans
>
>>
>>
>> Best regards
>> --
>> Pawel Osciak
>> Linux Platform Group
>> Samsung Poland R&D Center
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

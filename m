Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60680 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932757AbdCVJlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 05:41:09 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ON700LYKMVL7F80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Mar 2017 09:40:33 +0000 (GMT)
Subject: Re: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the reserved
 memory
To: Marian Mihailescu <mihailescu2m@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <124477f9-05ed-f38e-3b29-c0629b403fd3@samsung.com>
Date: Wed, 22 Mar 2017 10:40:30 +0100
In-reply-to: <E30E2706-5AAF-4235-A515-B73F80D401D4@gmail.com>
Content-transfer-encoding: 8bit
References: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
 <CGME20170317120635eucas1p1d13c446f1418de46a49516e95bf9075d@eucas1p1.samsung.com>
 <04742b05-76bc-a0ec-f5e8-fe3a50115c44@samsung.com>
 <E30E2706-5AAF-4235-A515-B73F80D401D4@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marian,

On 2017-03-22 10:33, Marian Mihailescu wrote:
> Hi,
>
> I was testing with the linux-next kernel + the v2 patches
> HW: odroid xu4
> decoding (working): tested with gstreamer
> encoding: tested with gstreamer && mfc-patched ffmpeg
> before patches: encoding worked
> after patches: encoding didn’t work.
>
> I moved on from linux-next in the meantime and I cannot give you logs, BUT I’ve seen Hardkernel applied these patches (and all the linux-next MFC patches) on top of their 4.9 tree, and the result is very similar to mine on linux-next: https://github.com/hardkernel/linux/issues/284
>
> Mar 21 13:04:54 odroid kernel: [   37.165153] s5p_mfc_alloc_priv_buf:78: Allocating private buffer of size 23243744 failed
> Mar 21 13:04:54 odroid kernel: [   37.171865] s5p_mfc_alloc_codec_buffers_v6:244: Failed to allocate Bank1 memory
> Mar 21 13:04:54 odroid kernel: [   37.179143] vidioc_reqbufs:1174: Failed to allocate encoding buffers
>
>
> A user reported even adding s5p_mfc.mem=64M did not make the encoder work.
> Any thoughts?

Thanks for the report. Could you provide a bit more information about 
the encoder configuration (selected format, frame size, etc). 23MiB for 
the temporary buffer seems to be a bit large value, but I would like to 
reproduce it here and check what can be done to avoid allocating it from 
the preallocated buffer.




> Thanks,
> M.
>
> (resent in plain text format)
>
>> On 17 Mar. 2017, at 10:36 pm, Andrzej Hajda <a.hajda@samsung.com> wrote:
>>
>> Hi Marian,
>>
>> On 15.03.2017 12:36, Marian Mihailescu wrote:
>>> Hi,
>>>
>>> After testing these patches, encoding using MFC fails when requesting
>>> buffers for capture (it works for output) with ENOMEM (it complains it
>>> cannot allocate memory on bank1).
>>> Did anyone else test encoding?
>> I have tested encoding and it works on my test target. Could you provide
>> more details of your setup:
>> - which kernel and patches,
>> - which hw,
>> - which test app.
>>
>> Regards
>> Andrzej
>>
>>
>>> Thanks,
>>> Marian
>>>
>>> Either I've been missing something or nothing has been going on. (K. E. Gordon)
>>>
>
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

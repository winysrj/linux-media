Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46017 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab0EFNaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 09:30:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L2000JMJ2U9NZ40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 May 2010 14:30:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L2000KY82U95T@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 May 2010 14:30:09 +0100 (BST)
Date: Thu, 06 May 2010 15:29:42 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [videobuf] Query: Condition bytesize limit in videobuf_reqbufs ->
 buf_setup() call?
In-reply-to: <4BE2BFC1.1000701@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: "'Aguirre, Sergio'" <saaguirre@ti.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com
Message-id: <002701caed20$2f9a05c0$8ece1140$%osciak@samsung.com>
Content-language: pl
References: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com>
 <000901caeceb$9ff6c5e0$dfe451a0$%osciak@samsung.com>
 <4BE2BFC1.1000701@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Mauro Carvalho Chehab [mailto:mchehab@redhat.com] wrote:
>
>Pawel Osciak wrote:
>> Hi,
>>
>>> Aguirre, Sergio wrote:
>>> Basically, when calling VIDIOC_REQBUFS with a certain buffer
>>> Count, we had a software limit for total size, calculated depending on:
>>>
>>>  Total bytesize = bytesperline x height x count
>>>
>>> So, we had an arbitrary limit to, say 32 MB, which was generic.
>>>
>>> Now, we want to condition it ONLY when MMAP buffers will be used.
>>> Meaning, we don't want to keep that policy when the kernel is not
>>> allocating the space
>>>
>>> But the thing is that, according to videobuf documentation, buf_setup is
>>> the one who should put a RAM usage limit. BUT the memory type passed to
>>> reqbufs is not propagated to buf_setup, therefore forcing me to go to a
>>> non-standard memory limitation in my reqbufs callback function, instead
>>> of doing it properly inside buf_setup.
>>
>> buf_setup is called during REQBUFS and is indeed the place to limit the
>> size and actually allocate the buffers as well, or at least try to do so,
>> as V4L2 API requires. This is not currently the case with videobuf, but
>> right now we are working to change it.
>
>I can't see the problem you're mentioning. Drivers apply (or should apply)
>the maximum size limit at buffer setup. For example bttv driver seems to do
>the right thing:

Not really a problem. You are right about setup. I meant that videobuf
behaves differently in regard to when it actually allocates the buffers.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center




Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35942 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab2DSOch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 10:32:37 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2Q005BHDQ62J@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Apr 2012 15:32:30 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M2Q00LZ2DQ73P@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Apr 2012 15:32:32 +0100 (BST)
Date: Thu, 19 Apr 2012 16:32:30 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 02/14] Documentation: media: description of DMABUF
 importing in V4L2
In-reply-to: <13761406.oTf8ZzmZpQ@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com
Message-id: <4F9021FE.2070903@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
 <1334332076-28489-3-git-send-email-t.stanislaws@samsung.com>
 <13761406.oTf8ZzmZpQ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2012 01:25 AM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> Thanks for the patch.
> 
> On Friday 13 April 2012 17:47:44 Tomasz Stanislawski wrote:
>> This patch adds description and usage examples for importing
>> DMABUF file descriptor in V4L2.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> [snip]
> 
>> diff --git a/Documentation/DocBook/media/v4l/io.xml
>> b/Documentation/DocBook/media/v4l/io.xml index b815929..dc5979d 100644
>> --- a/Documentation/DocBook/media/v4l/io.xml
>> +++ b/Documentation/DocBook/media/v4l/io.xml
>> @@ -472,6 +472,162 @@ rest should be evident.</para>
>>        </footnote></para>
>>    </section>
>>
>> +  <section id="dmabuf">
>> +    <title>Streaming I/O (DMA buffer importing)</title>
> 
> This section is very similar to the Streaming I/O (User Pointers) section. Do 
> you think we should merge the two ? I could handle that if you want.
> 

Hi Laurent,

One may find similar sentences in MMAP, USERPTR and DMABUF.
Maybe the common parts like description of STREAMON/OFF,
QBUF/DQBUF shuffling should be moved to separate section
like "Streaming" :).

Maybe it is worth to introduce a separate patch for this change.

Frankly, I would prefer to keep the Doc in the current form till
importer support gets merged. Later the Doc could be fixed.

BTW. What is the sense of merging userptr and dmabuf section
if userptr is going to dropped in long-term?

Regards,
Tomasz Stanislawski

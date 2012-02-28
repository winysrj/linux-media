Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42955 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965035Ab2B1LPq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 06:15:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0300J01OM8H280@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 Feb 2012 11:15:44 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M03001ZXOM7R4@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 Feb 2012 11:15:44 +0000 (GMT)
Date: Tue, 28 Feb 2012 12:15:43 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PATCHES FOR 3.4] gspca for_v3.4
In-reply-to: <20120228120548.186ee4bc@tele>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Message-id: <4F4CB75F.4050907@samsung.com>
References: <20120227130606.1f432e7b@tele> <4F4BE111.6090805@gmail.com>
 <20120228120548.186ee4bc@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Francois,

On 02/28/2012 12:05 PM, Jean-Francois Moine wrote:
> On Mon, 27 Feb 2012 21:01:21 +0100
> Sylwester Nawrocki <snjw23@gmail.com> wrote:
> 
>> This patch will conflict with patch:
>>
>>  gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
>>
>> from my recent pull request http://patchwork.linuxtv.org/patch/10022/
>>
>> How should we proceed with that ? Do you want me to remove the above patch 
>> from my pull request, or would you rebase your change set on top of mine ?
> 
> Hi Sylwester,
> 
> Sorry for the problem, I thought your patch was already in the media
> tree.

Sorry about the delay, I was holding on for quite some time with pushing
the patch upstream.

> I checked the changes in zc3xx.c, and I have made many commits. So, it
> would be simpler if you would remove your patch. I could give you a
> merged one once the media tree would be updated.

OK, if it's easier please carry the patch in your tree. Otherwise, let me
handle it after our pull request are included in the media tree.

Best regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center

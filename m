Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49563 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2JCJfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 05:35:08 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBB005DT9B3QB20@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Oct 2012 10:35:27 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MBB004T09AHM980@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Oct 2012 10:35:06 +0100 (BST)
Message-id: <506C06C8.7060703@samsung.com>
Date: Wed, 03 Oct 2012 11:35:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sunil Joshi <joshi@samsung.com>
Subject: Re: [GIT PULL FOR 3.7] Samsung Exynos MFC driver update
References: <506B1D47.8040602@samsung.com> <20121002150603.31b6b72d@redhat.com>
 <506B4733.3070505@gmail.com>
 <CALt3h7-YQ6PAv+5Yy+x-9jFpKf0XEA6GY_U9v59PiC5FkcdC1w@mail.gmail.com>
In-reply-to: <CALt3h7-YQ6PAv+5Yy+x-9jFpKf0XEA6GY_U9v59PiC5FkcdC1w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 10/03/2012 07:38 AM, Arun Kumar K wrote:
>> Indeed it looks like big blob patch. I think this reflects how these patches
>> were created, were one person creates practically new driver for new device
>> revision, with not much care about the old one, and then somebody else is
>> trying to make it a step by step process and ensuring support for all H/W
>> revisions is properly maintained.
>>
>> Anyway, Arun, can you please rebase your patch series onto latest linuxtv
>> for_v3.7 branch and try to split this above patch. AFAICS there are following
>> things done there that could be separated:
>>
>> 1. Move contents of file s5p_mfc_opr.c to new file s5p_mfc_opr_v5.c
>> 2. Rename functions in s5p_mfc_opr_v5.c
>> 3. Use s5p_mfc_hw_call for H/W specific function calls
>> 4. Do S5P_FIMV/S5P_MFC whatever magic.
> 
> I couldnt go with more finer splits, as I wanted to keep a working driver
> between all successive patches. Now I will try to make the splits as
> suggested and see if it can still be done.
> 
>> Also I've noticed some patches do break compilation. There are some definitions
>> used there which are added only in subsequent patches. Arun, can you please make
>> sure there is no build break after each single patch is applied ?
> 
> I have checked this while applying and I didnt see any break in
> compilation after each patch is applied. I ensured not only compilation
> but also a working driver after applying each patch. I will ensure
> this again on the next rebase.

Sorry, I wrongly concluded from looking at the diffs only. Preserving
working driver is a good thing, but it is not really required AFAICT. Still 
it would be nice split the patch as above keeping the v5 driver working.
Probably splitting it in 3 is enough. It is worthwhile as long as it makes 
the total diffs smaller (e.g. file renames don't need to be a huge diff with 
git rename detection enabled). I understand you've got now an additional
work due to conflict with Andrzej's patches. All pending s5p-mfc patches 
seems to be in Mauro's tree for_v3.7 and nothing should get in before your 
patches now.

> I will make these suggested changes and post an updated patchset today.

Thanks.

--
Regards,
Sylwester

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:54152 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751306AbdB0DOT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Feb 2017 22:14:19 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OM002PYSJNSFH80@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Feb 2017 12:14:16 +0900 (KST)
Subject: Re: [PATCH 2/2] media: s5p-mfc: fix MMAP of mfc buffer during reqbufs
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
        mchehab@kernel.org, mchehab@osg.samsung.com,
        hans.verkuil@cisco.com, krzk@kernel.org, kgene@kernel.org,
        Smitha T Murthy <smitha.t@samsung.com>
From: "pankaj.dubey" <pankaj.dubey@samsung.com>
Message-id: <384899ef-4e7e-d7f5-8f4f-ef2f023cb681@samsung.com>
Date: Mon, 27 Feb 2017 08:47:18 +0530
MIME-version: 1.0
In-reply-to: <81c11e69-b7eb-ccb5-a377-2848ec551274@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1481888915-19624-1-git-send-email-pankaj.dubey@samsung.com>
 <1481888915-19624-3-git-send-email-pankaj.dubey@samsung.com>
 <CGME20170224194302epcas2p2edea64bf7b2fc89ee97b6f5391b2dad0@epcas2p2.samsung.com>
 <81c11e69-b7eb-ccb5-a377-2848ec551274@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javier,

On Saturday 25 February 2017 01:12 AM, Javier Martinez Canillas wrote:
> Hello Pankaj,
> 
> On 12/16/2016 08:48 AM, Pankaj Dubey wrote:
>> From: Smitha T Murthy <smitha.t@samsung.com>
>>
>> It has been observed on ARM64 based Exynos SoC, if IOMMU is not enabled
>> and we try to use reserved memory for MFC, reqbufs fails with below
>> mentioned error
>> ---------------------------------------------------------------------------
>> V4L2 Codec decoding example application
>> Kamil Debski <k.debski@samsung.com>
>> Copyright 2012 Samsung Electronics Co., Ltd.
>>
>> Opening MFC.
>> (mfc.c:mfc_open:58): MFC Info (/dev/video0): driver="s5p-mfc" \
>> bus_info="platform:12c30000.mfc0" card="s5p-mfc-dec" fd=0x4[
>> 42.339165] Remapping memory failed, error: -6
>>
>> MFC Open Success.
>> (main.c:main:711): Successfully opened all necessary files and devices
>> (mfc.c:mfc_dec_setup_output:103): Setup MFC decoding OUTPUT buffer \
>> size=4194304 (requested=4194304)
>> (mfc.c:mfc_dec_setup_output:120): Number of MFC OUTPUT buffers is 2 \
>> (requested 2)
>>
>> [App] Out buf phy : 0x00000000, virt : 0xffffffff
>> Output Length is = 0x300000
>> Error (mfc.c:mfc_dec_setup_output:145): Failed to MMAP MFC OUTPUT buffer
>> -------------------------------------------------------------------------
>> This is because the device requesting for memory is mfc0.left not the parent mfc0.
>> Hence setting of alloc_devs need to be done only if IOMMU is enabled
>> and in that case both the left and right device is treated as mfc0 only.
>>
> 
> I see, so likely you were facing the issue described in patch 1/2 after this
> patch since the driver doesn't set alloc_devs when IOMMU is disabled, right?
> 

Yes.

> In any case, I guess these patches have been superseded by Marek's series[0]
> so they are no longer needed?
> 

Yes, these patches have been superseded but now by Marek's series.
I missed to check Marek's series [0] due to some official assignment,
but we followed up our patch series with Marek, and fix was provided in
of_reserved_mem.c via patch [1] which has been accepted and merged as
well. I will try to find out some time and test Marek's patch series [0].

[1]: https://patchwork.kernel.org/patch/9482499/

Thanks,
Pankaj Dubey

> [0]: https://www.spinics.net/lists/linux-media/msg111156.html
> 
> Best regards,
> 

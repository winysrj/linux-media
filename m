Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17460 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752417AbcKPLsD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 06:48:03 -0500
Subject: Re: [GIT PULL] Samsung fixes for 4.8
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <70cc3f35-e661-c76f-8620-dfeb74030183@samsung.com>
Date: Wed, 16 Nov 2016 12:47:57 +0100
MIME-version: 1.0
In-reply-to: <20161021102607.2df96630@vento.lan>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <CGME20160916133335eucas1p2417ec5672f250c3eaca8e424293ce783@eucas1p2.samsung.com>
 <8001c83d-0e3a-61cb-bf53-8c2b497bd0ed@samsung.com>
 <20161021102607.2df96630@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/21/2016 02:26 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 16 Sep 2016 15:33:33 +0200
> Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:
> 
>> Hi Mauro,
>>
>> The following changes since commit 7892a1f64a447b6f65fe2888688883b7c26d81d3:
>>
>>   [media] rcar-fcp: Make sure rcar_fcp_enable() returns 0 on success (2016-09-15 09:02:16 -0300)
>>
>> are available in the git repository at:
>>
>>   git://linuxtv.org/snawrocki/samsung.git for-v4.9/media/fixes
>>
>> for you to fetch changes up to 8beaa9d0595aa2ae1f63be364c80189e53cbfe15:
>>
>>   exynos4-is: Clear I2C_ISP adapter's power.ignore_children flag (2016-09-16 15:25:55 +0200)
>>
>> ----------------------------------------------------------------
>> Marek Szyprowski (1):
>>       s5p-mfc: fix failure path of s5p_mfc_alloc_memdev()

Mauro, this patch seems to had slipped through the cracks, I can't see it
in neither media fixes nor the master branch. Could you please check it?

>> Sylwester Nawrocki (1):
>>       exynos4-is: Clear I2C_ISP adapter's power.ignore_children flag
> 
> This patch didn't apply fine. Could you please rebase it?
> 
> Applying patch patches/0002-exynos4-is-Clear-I2C_ISP-adapter-s-power.ignore_chil.patch
> patching file drivers/media/platform/exynos4-is/fimc-is-i2c.c
> Hunk #1 NOT MERGED at 74-99, already applied at 101-104, already applied at 111.
> Applied patch patches/0002-exynos4-is-Clear-I2C_ISP-adapter-s-power.ignore_chil.patch (forced; needs refresh)

--
Thanks,
Sylwester

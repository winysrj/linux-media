Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55646
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932726AbcJUM0N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 08:26:13 -0400
Date: Fri, 21 Oct 2016 10:26:07 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [GIT PULL] Samsung fixes for 4.8
Message-ID: <20161021102607.2df96630@vento.lan>
In-Reply-To: <8001c83d-0e3a-61cb-bf53-8c2b497bd0ed@samsung.com>
References: <CGME20160916133335eucas1p2417ec5672f250c3eaca8e424293ce783@eucas1p2.samsung.com>
        <8001c83d-0e3a-61cb-bf53-8c2b497bd0ed@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Sep 2016 15:33:33 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> Hi Mauro,
> 
> The following changes since commit 7892a1f64a447b6f65fe2888688883b7c26d81d3:
> 
>   [media] rcar-fcp: Make sure rcar_fcp_enable() returns 0 on success (2016-09-15 09:02:16 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/snawrocki/samsung.git for-v4.9/media/fixes
> 
> for you to fetch changes up to 8beaa9d0595aa2ae1f63be364c80189e53cbfe15:
> 
>   exynos4-is: Clear I2C_ISP adapter's power.ignore_children flag (2016-09-16 15:25:55 +0200)
> 
> ----------------------------------------------------------------
> Marek Szyprowski (1):
>       s5p-mfc: fix failure path of s5p_mfc_alloc_memdev()
> 
> Sylwester Nawrocki (1):
>       exynos4-is: Clear I2C_ISP adapter's power.ignore_children flag

This patch didn't apply fine. Could you please rebase it?

Applying patch patches/0002-exynos4-is-Clear-I2C_ISP-adapter-s-power.ignore_chil.patch
patching file drivers/media/platform/exynos4-is/fimc-is-i2c.c
Hunk #1 NOT MERGED at 74-99, already applied at 101-104, already applied at 111.
Applied patch patches/0002-exynos4-is-Clear-I2C_ISP-adapter-s-power.ignore_chil.patch (forced; needs refresh)

Thanks,
Mauro

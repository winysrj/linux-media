Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31279 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932807AbcJUNBH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 09:01:07 -0400
Subject: Re: [GIT PULL] Samsung fixes for 4.8
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <07acb5a4-50c3-ad2b-77ee-4929801d082c@samsung.com>
Date: Fri, 21 Oct 2016 15:01:00 +0200
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
>> Sylwester Nawrocki (1):
>> >       exynos4-is: Clear I2C_ISP adapter's power.ignore_children flag
>
> This patch didn't apply fine. Could you please rebase it?
> 
> Applying patch patches/0002-exynos4-is-Clear-I2C_ISP-adapter-s-power.ignore_chil.patch
> patching file drivers/media/platform/exynos4-is/fimc-is-i2c.c
> Hunk #1 NOT MERGED at 74-99, already applied at 101-104, already applied at 111.

It seems no further actions are needed since the patch is somehow already 
applied in Linus' tree:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/media/platform/exynos4-is/fimc-is-i2c.c?id=056c61eb0da4d7181fc7072567dc1931cb0e1cbb

--
Regards, 
Sylwester

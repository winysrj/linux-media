Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35570 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3ABLHC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 06:07:02 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MFZ005AWW7MI180@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jan 2013 11:06:59 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MFZ00GOGW7I4040@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jan 2013 11:06:59 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	sylvester.nawrocki@gmail.com, patches@linaro.org
References: <1357118013-20967-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1357118013-20967-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH-Trivial] [media] s5p-mfc: Fix a typo in error message in
 s5p_mfc_pm.c
Date: Wed, 02 Jan 2013 12:06:53 +0100
Message-id: <005201cde8d9$463c0be0$d2b423a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for this patch. 

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Wednesday, January 02, 2013 10:14 AM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; s.nawrocki@samsung.com;
> sylvester.nawrocki@gmail.com; sachin.kamat@linaro.org;
> patches@linaro.org
> Subject: [PATCH-Trivial] [media] s5p-mfc: Fix a typo in error message
> in s5p_mfc_pm.c
> 
> Fixed a trivial typo.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> index 2895333..6aa38a5 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> @@ -46,7 +46,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
> 
>  	ret = clk_prepare(pm->clock_gate);
>  	if (ret) {
> -		mfc_err("Failed to preapre clock-gating control\n");
> +		mfc_err("Failed to prepare clock-gating control\n");
>  		goto err_p_ip_clk;
>  	}
> 
> --
> 1.7.4.1



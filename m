Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C425C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 16:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BEC0204FD
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 16:36:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BEC0204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbeLJQgt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 11:36:49 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:55656 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726649AbeLJQgt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 11:36:49 -0500
Received: from [IPv6:2001:983:e9a7:1:153f:c992:21d9:6742] ([IPv6:2001:983:e9a7:1:153f:c992:21d9:6742])
        by smtp-cloud8.xs4all.net with ESMTPA
        id WOXzg6MuqCZKKWOY0gEwnT; Mon, 10 Dec 2018 17:36:46 +0100
Subject: Re: [PATCH] drm/tegra: Refactor CEC support
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <20181210163455.13627-1-thierry.reding@gmail.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <1611ab47-9ba6-83dc-6f6d-8add7b0a9751@xs4all.nl>
Date:   Mon, 10 Dec 2018 17:36:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181210163455.13627-1-thierry.reding@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGq0DTXto0WQZUgE2CTFY0mqQ1wIo8lV1f6VQXLUXI7g53TWm+GLWBE/fYN2U/CdZEclbdb4CxF8srHl05lagbW8SvBx5zmpPpXq50F1uoXUxkVteXon
 fKxLy55lvrNtJdE9iP26I+/AIUECo5FrB9GumPBZjnh32Uo5VDuljOTlz3COjKVTH75rCLa4UB17swgjXXggZxIzR7ffzqSTZktbgtlv7mnUPt14HZUDX8tm
 DGMVMFV5cIk+zCYVJFQML4VEdr3m/MYFwOzdFQnkCpPDzd1MsWHClQMTmxu5ec7ZBV07I5VfqNiHtkcwL/KDyIddcAjekoqIZw7h/b1XaqqOGc0pHcS5NDC0
 ObBLD4VTXmubdj2soMYYQbhE4zhT0obpaiyn6jxVhglwIDDfKiCKcxulUZEfTUc5hg2K4b0cjvU47IDW35u/Q6F/XMkHlg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/10/18 5:34 PM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Most of the CEC support code already lives in the "output" library code.
> Move registration and unregistration to the library code as well to make
> use of the same code with HDMI on Tegra210 and later via the SOR.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans

> ---
>  drivers/gpu/drm/tegra/drm.h    |  2 +-
>  drivers/gpu/drm/tegra/hdmi.c   |  9 ---------
>  drivers/gpu/drm/tegra/output.c | 11 +++++++++--
>  3 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
> index 019862a41cb4..dbc9e11b0aec 100644
> --- a/drivers/gpu/drm/tegra/drm.h
> +++ b/drivers/gpu/drm/tegra/drm.h
> @@ -132,7 +132,7 @@ struct tegra_output {
>  	struct drm_panel *panel;
>  	struct i2c_adapter *ddc;
>  	const struct edid *edid;
> -	struct cec_notifier *notifier;
> +	struct cec_notifier *cec;
>  	unsigned int hpd_irq;
>  	int hpd_gpio;
>  	enum of_gpio_flags hpd_gpio_flags;
> diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
> index 0082468f703c..d19973945614 100644
> --- a/drivers/gpu/drm/tegra/hdmi.c
> +++ b/drivers/gpu/drm/tegra/hdmi.c
> @@ -22,8 +22,6 @@
>  
>  #include <sound/hda_verbs.h>
>  
> -#include <media/cec-notifier.h>
> -
>  #include "hdmi.h"
>  #include "drm.h"
>  #include "dc.h"
> @@ -1709,10 +1707,6 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
>  		return PTR_ERR(hdmi->vdd);
>  	}
>  
> -	hdmi->output.notifier = cec_notifier_get(&pdev->dev);
> -	if (hdmi->output.notifier == NULL)
> -		return -ENOMEM;
> -
>  	hdmi->output.dev = &pdev->dev;
>  
>  	err = tegra_output_probe(&hdmi->output);
> @@ -1771,9 +1765,6 @@ static int tegra_hdmi_remove(struct platform_device *pdev)
>  
>  	tegra_output_remove(&hdmi->output);
>  
> -	if (hdmi->output.notifier)
> -		cec_notifier_put(hdmi->output.notifier);
> -
>  	return 0;
>  }
>  
> diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
> index c662efc7e413..9c2b9dad55c3 100644
> --- a/drivers/gpu/drm/tegra/output.c
> +++ b/drivers/gpu/drm/tegra/output.c
> @@ -36,7 +36,7 @@ int tegra_output_connector_get_modes(struct drm_connector *connector)
>  	else if (output->ddc)
>  		edid = drm_get_edid(connector, output->ddc);
>  
> -	cec_notifier_set_phys_addr_from_edid(output->notifier, edid);
> +	cec_notifier_set_phys_addr_from_edid(output->cec, edid);
>  	drm_connector_update_edid_property(connector, edid);
>  
>  	if (edid) {
> @@ -73,7 +73,7 @@ tegra_output_connector_detect(struct drm_connector *connector, bool force)
>  	}
>  
>  	if (status != connector_status_connected)
> -		cec_notifier_phys_addr_invalidate(output->notifier);
> +		cec_notifier_phys_addr_invalidate(output->cec);
>  
>  	return status;
>  }
> @@ -174,11 +174,18 @@ int tegra_output_probe(struct tegra_output *output)
>  		disable_irq(output->hpd_irq);
>  	}
>  
> +	output->cec = cec_notifier_get(output->dev);
> +	if (!output->cec)
> +		return -ENOMEM;
> +
>  	return 0;
>  }
>  
>  void tegra_output_remove(struct tegra_output *output)
>  {
> +	if (output->cec)
> +		cec_notifier_put(output->cec);
> +
>  	if (gpio_is_valid(output->hpd_gpio)) {
>  		free_irq(output->hpd_irq, output);
>  		gpio_free(output->hpd_gpio);
> 


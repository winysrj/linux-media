Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:57610 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2DAUvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 16:51:17 -0400
Received: from homiemail-a49.g.dreamhost.com (caibbdcaaaaf.dreamhost.com [208.113.200.5])
	by hapkido.dreamhost.com (Postfix) with ESMTP id D715217CA45
	for <linux-media@vger.kernel.org>; Sun,  1 Apr 2012 13:51:11 -0700 (PDT)
Message-ID: <4F78BF92.70304@shealevy.com>
Date: Sun, 01 Apr 2012 16:50:26 -0400
From: Shea Levy <shea@shealevy.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tracey Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, mchehab@infradead.org,
	hans.verkuil@cisco.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers/media/radio: Fix build error
References: <1333307374-25848-1-git-send-email-tdent48227@gmail.com> <201204012124.48701.hverkuil@xs4all.nl>
In-Reply-To: <201204012124.48701.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/01/2012 03:24 PM, Hans Verkuil wrote:
> No, this is the correct patch:
>
> diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
> index 8816804..5ca0939 100644
> --- a/sound/pci/Kconfig
> +++ b/sound/pci/Kconfig
> @@ -2,8 +2,8 @@
>
>   config SND_TEA575X
>   	tristate
> -	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2
> -	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2
> +	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO
> +	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO
>
>   menuconfig SND_PCI
>   	bool "PCI sound devices"

Builds now, thanks.

Tested-by: Shea Levy <shea@shealevy.com>

Cheers,
Shea

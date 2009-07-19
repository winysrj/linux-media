Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58198 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZGSKnJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 06:43:09 -0400
Date: Sun, 19 Jul 2009 11:42:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com,
	Manjunath Hadli <mrh@ti.com>, Brijesh Jadav <brijesh.j@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v2] ARM: DaVinci: DM646x Video: Platform and board
	specific setup
Message-ID: <20090719104258.GR12062@n2100.arm.linux.org.uk>
References: <1246967577-8573-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246967577-8573-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 07, 2009 at 07:52:57AM -0400, Chaithrika U S wrote:
> diff --git a/arch/arm/mach-davinci/include/mach/dm646x.h b/arch/arm/mach-davinci/include/mach/dm646x.h
> index 0585484..1f247fb 100644
> --- a/arch/arm/mach-davinci/include/mach/dm646x.h
> +++ b/arch/arm/mach-davinci/include/mach/dm646x.h
> @@ -26,4 +26,28 @@ void __init dm646x_init(void);
>  void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
>  void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
>  
> +void dm646x_video_init(void);
> +
> +struct vpif_output {
> +	u16 id;
> +	const char *name;
> +};
> +
> +struct subdev_info {
> +	unsigned short addr;
> +	const char *name;
> +};

'subdev_info' is far too generic to have in platform header files.
Please rename this to at least vpif_subdev_info.

Other than that, patch looks fine.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:43606 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbeDIXfk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 19:35:40 -0400
Subject: Re: [PATCH v3] usbtv: Enforce standard for color decoding
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, bonstra@bonstra.fr.eu.org
References: <201804091218.GkcgM7OY%fengguang.wu@intel.com>
 <20180409231301.14759-1-bonstra@bonstra.fr.eu.org>
From: "Hugo \"Bonstra\" Grostabussiat" <bonstra@bonstra.fr.eu.org>
Message-ID: <6a6335ee-f289-d1dc-81df-e3f70e7b11e9@bonstra.fr.eu.org>
Date: Tue, 10 Apr 2018 01:35:34 +0200
MIME-Version: 1.0
In-Reply-To: <20180409231301.14759-1-bonstra@bonstra.fr.eu.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 10/04/2018 à 01:13, Hugo Grostabussiat a écrit :
>  	if (!ret) {
>  		/* Configure the decoder for the color standard */
> -		u16 cfg[][2] = {
> +		const u16 cfg[][2] = {
>  			{ USBTV_BASE + 0x016f, usbtv_norm_to_16f_reg(norm) }
>  		};
>  		ret = usbtv_set_regs(usbtv, cfg, ARRAY_SIZE(cfg));

This sums up the differences between the v2 and the v3 of this patch

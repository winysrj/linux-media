Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.24]:64573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaCRKGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 06:06:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 05/10] V4L: s5c73m3: Add device tree support
Date: Tue, 18 Mar 2014 11:05:47 +0100
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	mark.rutland@arm.com, linux-samsung-soc@vger.kernel.org,
	a.hajda@samsung.com, kyungmin.park@samsung.com, robh+dt@kernel.org,
	galak@codeaurora.org, kgene.kim@samsung.com
References: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com> <1394122819-9582-6-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1394122819-9582-6-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403181105.47922.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 06 March 2014, Sylwester Nawrocki wrote:
> This patch adds the V4L2 asynchronous subdev registration and
> device tree support. Common clock API is used to control the
> sensor master clock from within the subdev.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

This driver is in linux-next now, but

> +	node_ep = v4l2_of_get_next_endpoint(node, NULL);
> +	if (!node_ep) {
> +		dev_warn(dev, "no endpoint defined for node: %s\n",
> +						node->full_name);
> +		return 0;
>  	}

This function is not defined here, leading to build errors.

	Arnd

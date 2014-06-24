Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34188 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbaFXOFR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:05:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1WzRLX-0003ZU-NI
	for linux-media@vger.kernel.org; Tue, 24 Jun 2014 16:05:15 +0200
Received: from 80-218-111-224.dclient.hispeed.ch ([80.218.111.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 16:05:15 +0200
Received: from dave.mueller by 80-218-111-224.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 16:05:15 +0200
To: linux-media@vger.kernel.org
From: Dave =?utf-8?b?TcO8bGxlcg==?= <dave.mueller@gmx.ch>
Subject: Re: [RFC PATCH 14/26] [media] Add i.MX SoC wide media device driver
Date: Tue, 24 Jun 2014 14:05:03 +0000 (UTC)
Message-ID: <loom.20140624T155859-446@post.gmane.org>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de> <1402592800-2925-15-git-send-email-p.zabel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again

Philipp Zabel <p.zabel@pengutronix.de> writes:

> +struct media_device *ipu_find_media_device(void)
> +{
> +	return &ipu_media->mdev;
> +}
> +EXPORT_SYMBOL_GPL(ipu_find_media_device);

Where is ipu_find_media_device() being called?

> +int ipu_media_device_register(struct device *dev)
> +{

[snip]

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_media_device_register);

Where is ipu_media_device_register() being called?



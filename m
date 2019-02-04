Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CE9C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 09:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF99214DA
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 09:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfBDJGg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 04:06:36 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55048 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbfBDJGg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 04:06:36 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 8EB7C634C7E;
        Mon,  4 Feb 2019 11:05:20 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gqaBt-0002pQ-JB; Mon, 04 Feb 2019 11:05:21 +0200
Date:   Mon, 4 Feb 2019 11:05:21 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2 00/13] media: mt9m001: switch soc_mt9m001 to a
 standard subdev sensor driver
Message-ID: <20190204090521.5ngcycuvccvfrpqb@valkosipuli.retiisi.org.uk>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mita-san,

On Tue, Jan 08, 2019 at 11:51:37PM +0900, Akinobu Mita wrote:
> This patchset converts soc_camera mt9m001 driver to a standard subdev
> sensor driver.
> 
> * v2
> - Update binding doc suggested by Rob Herring.
> - Fix MODULE_LICENSE() masmatch.
> - Sort headers alphabetically.
> - Add new label for error handling in s_stream() callback.
> - Replace pm_runtime_get_noresume() + pm_runtime_put_sync() with a
>   single pm_runtime_idle() call in probe() function.
> - Change the argument of mt9m001_power_o{n,ff} to struct device, and
>   use them for runtime PM callbacks directly.
> - Remove redundant Kconfig dependency
> - Preserve subdev flags set by v4l2_i2c_subdev_init().
> - Set initial try format with default configuration instead of
>   current one.

While this set improved the original mt9m001 driver a lot, it did not add a
MAINTAINERS entry for it. The same applies to the mt9m111 driver.

Could you provide the MAINTAINERS entries for the two drivers, please?

Thanks.

-- 
Kind regards,

Sakari Ailus

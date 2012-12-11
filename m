Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42244 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKIjr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 03:39:47 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so2109834wib.1
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 00:39:46 -0800 (PST)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 01/13] i2c: add dummy inline functions for when CONFIG_OF_I2C(_MODULE) isn't defined
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org
Cc: rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <1355168499-5847-2-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com> <1355168499-5847-2-git-send-email-s.nawrocki@samsung.com>
Date: Tue, 11 Dec 2012 08:39:33 +0000
Message-Id: <20121211083933.7B9743E076D@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 Dec 2012 20:41:27 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> If CONFIG_OF_I2C and CONFIG_OF_I2C_MODULE are undefined no declaration of
> of_find_i2c_device_by_node and of_find_i2c_adapter_by_node will be
> available. Add dummy inline functions to avoid compilation breakage.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Applied, thanks.

g.


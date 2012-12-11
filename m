Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59269 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKInM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 03:43:12 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so2311839wgb.1
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 00:43:11 -0800 (PST)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 02/13] of: add a dummy inline function for when CONFIG_OF is not defined
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org
Cc: rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <1355168499-5847-3-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com> <1355168499-5847-3-git-send-email-s.nawrocki@samsung.com>
Date: Tue, 11 Dec 2012 08:42:56 +0000
Message-Id: <20121211084256.E2CDF3E076D@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 Dec 2012 20:41:28 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> If CONFIG_OF isn't defined, no declaration of of_get_parent will be found
> and compilation can fail. This patch adds a dummy inline function
> definition to fix the problem.

Where is this function getting called when CONFIG_OF is not defined? I
suspect that any code calling of_get_parent() should be CONFIG_OF
specific code and configured out when CONFIG_OF=n, but let me know if
I'm missing something.

g.


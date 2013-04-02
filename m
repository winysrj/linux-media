Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62986 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761779Ab3DBQaV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:30:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] DT: export of_get_next_parent() for use by modules: fix modular V4L2
Date: Tue, 2 Apr 2013 16:30:13 +0000
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <Pine.LNX.4.64.1304021825130.31999@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1304021825130.31999@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304021630.13371.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 02 April 2013, Guennadi Liakhovetski wrote:
> Currently modular V4L2 build with enabled OF is broken dur to the
> of_get_next_parent() function being unavailable to modules. Export it to
> fix the build.
> 
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Looks good to me, but shouldn't this be EXPORT_SYMBOL_GPL?

	Arnd

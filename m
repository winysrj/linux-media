Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50348 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaCFQbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 11:31:50 -0500
Message-ID: <1394123500.3622.56.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v9][ 3/8] staging: imx-drm: Correct BGR666 and the
 board's dts that use them.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Denis Carikli <denis@eukrea.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 06 Mar 2014 17:31:40 +0100
In-Reply-To: <1394121702-13257-3-git-send-email-denis@eukrea.com>
References: <1394121702-13257-1-git-send-email-denis@eukrea.com>
	 <1394121702-13257-3-git-send-email-denis@eukrea.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Denis,

Am Donnerstag, den 06.03.2014, 17:01 +0100 schrieb Denis Carikli:
> The current BGR666 is not consistent with the other color mapings like BGR24.
> BGR666 should be in the same byte order than BGR24.
>
> Signed-off-by: Denis Carikli <denis@eukrea.com>

patches 1 to 3
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

You should add Russell King to Cc:, who has volunteered to collect
imx-drm patches before sending them on to Greg for now.

regards
Philipp


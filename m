Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63969 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1ALLOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 06:14:02 -0500
Subject: [PATCH 0/2] Fix the way mx3_camera manage non 8-bpp pixel formats
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: HansVerkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1294092449.2493.135.camel@realization>
References: <1290964687.3016.5.camel@realization>
	 <1290965045.3016.11.camel@realization>
	 <Pine.LNX.4.64.1012011832430.28110@axis700.grange>
	 <Pine.LNX.4.64.1012181722200.18515@axis700.grange>
	 <Pine.LNX.4.64.1012302028100.13281@axis700.grange>
	 <1294076008.2493.85.camel@realization>
	 <Pine.LNX.4.64.1101031931160.23134@axis700.grange>
	 <1294092449.2493.135.camel@realization>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 12:13:56 +0100
Message-ID: <1294830836.2576.46.camel@realization>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series enable the mx3_camera driver to manage correctly
pixel formats like RGB565 UYVY and SBGGR10

This patch series applies to the staging/for_2.6.38-rc1
and I hope it will reach the mainline in one of the .38-rcN

Best regards,
Alberto!


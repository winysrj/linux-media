Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:49616 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab1HAKwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 06:52:22 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 00/59] Convert soc-camera to .[gs]_mbus_config() subdev operations
Date: Mon, 1 Aug 2011 12:51:35 +0200
Cc: linux-media@vger.kernel.org
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108011251.36396.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dnia pi±tek, 29 lipca 2011 o 12:56:00 Guennadi Liakhovetski napisa³(a):
> This patch-series converts all soc-camera client and host drivers and
> the core from soc-camera specific .{query,set}_bus_param()
> operations to the new .[gs]_mbus_config() subdev operations. In
> order to prevent bisect breakage we first have to only add new
> methods to client drivers, then convert all host drivers, taking
> care to preserve platform compatibility, and only then soc-camera
> methods can be removed. These patches are also available as a git
> branch:
> 
> git://linuxtv.org/gliakhovetski/v4l-dvb.git mbus-config
> 
> Tested on i.MX31, PXA270, SuperH, mach-shmobile. Compile-tested on
> many others. Reviews and tests welcome!:-)

Tested on Amstrad Delta - omap1_camera + ov6650.

Thanks,
Janusz

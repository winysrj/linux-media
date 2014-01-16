Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59145 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaAPBsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 20:48:25 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 15 Jan 2014 17:48:01 -0800
Message-ID: <CAK5ve-LbvQACmaZC4gFBf=Ca_nwp7KvvT+dLBhbipxRdLFYonw@mail.gmail.com>
Subject: A question about DT support for soc_camera
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-tegra <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I'm working on upstream our Tegra soc_camera host driver. But found
the soc_camera framework is not fully supporting Device Tree probing,
am I wrong about that? While in upstream Tegra kernel, we only support
DT probing and there is no board files.

Current soc_camera framework needs to put soc_camera_link information
in a board file and build up soc-camera-pdrv platform_device, then
finally register this soc-camera-pdrv platform_device.

For the host driver, we can do DT probing but for i2c soc_camera
sensor driver I failed to find any DT probing in upstream kernel. So
how to do that without an board file but use DT for this whole thing?

Can we use DT like this?
DTB file will pass those I2C, clock, regulator, GPIO information to
host driver. During host driver DT probing, we dynamically create
soc-camera-pdrv platform_device and soc_camera_link then register
them. Then the rest of the thing should be the same as None-DT
probing.

Any comments, thanks.
-Bryan

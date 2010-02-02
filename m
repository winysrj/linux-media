Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.renesas.com ([202.234.163.13]:43113 "EHLO
	mail02.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905Ab0BBFZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 00:25:35 -0500
Date: Tue, 02 Feb 2010 14:25:26 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH 0/3] soc-camera: mt9t112: bug fix patches
To: Guennadi <g.liakhovetski@gmx.de>
Cc: Linux-V4L2 <linux-media@vger.kernel.org>,
	Phil.Edworthy@renesas.com, Takashi.Namiki@renesas.com
Message-id: <ur5p4ky49.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Dear Guennadi
[Cc] Phil, Namiki-san

These patches are bug fix for mt9t112 camera

Kuninori Morimoto (3):
      soc-camera: mt9t112: modify exiting conditions from standby mode
      soc-camera: mt9t112: modify delay time after initialize
      soc-camera: mt9t112: The flag which control camera-init is removed

Best regards
--
Kuninori Morimoto
 

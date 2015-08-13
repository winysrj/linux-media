Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:53656 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752858AbbHMLg6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 07:36:58 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: linux-sh@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Renesas Lager: Device Tree entries for VIN HDMI input, version 2
Date: Thu, 13 Aug 2015 12:36:48 +0100
Message-Id: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Version 2 ... removes some redundant configuration from device nodes,
and provides some supplementary logic for automatic initialisation of
state->pdata.default_input based on the hardware present.

  (Obsoletes corresponding parts of "HDMI and Composite capture on
Lager...", published previously)

Cheers,
  Wills.

To follow:
	[PATCH 1/3] ARM: shmobile: lager dts: Add entries for VIN HDMI input
	[PATCH 2/3] media: adv7604: automatic "default-input" selection
	[PATCH 3/3] ARM: shmobile: lager dts: specify default-input for

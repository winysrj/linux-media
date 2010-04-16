Return-path: <linux-media-owner@vger.kernel.org>
Received: from av9-2-sn2.hy.skanova.net ([81.228.8.180]:45862 "EHLO
	av9-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584Ab0DPQtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 12:49:49 -0400
Subject: [PATCH 0/2] media, mfd: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 18:27:54 +0200
Message-ID: <1271435274.11641.44.camel@debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To follow are two patches.

The first one adds the timberdale video-in driver to the media tree.

The second one adds it to the timberdale MFD driver.

The Kconfig of the media patch selects TIMB_DMA which is introduced
in the DMA tree, that's why I cc:d in Dan.

Samuel and Mauro hope you can support and solve the potential merge
issue between your two trees.

Thanks
--Richard


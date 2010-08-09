Return-path: <mchehab@pedra>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:46477 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab0HIOfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 10:35:18 -0400
Subject: [PATCH 0/2 v3] media, mfd: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	p.osciak@samsung.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 16:35:14 +0200
Message-ID: <1281364514.5762.28.camel@debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

To follow are three patches.

Since last patch I removed the uncached buffers patch, it
needs to be investigated further.

The first adds the timberdale video-in driver to the media tree.

The second adds it to the timberdale MFD driver.

Samuel and Mauro hope you can support and solve the potential merge
issue between your two trees.

Thanks
--Richard


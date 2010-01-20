Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:1763 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab0ATOGK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 09:06:10 -0500
Message-ID: <4B570A4B.2050800@pelagicore.com>
Date: Wed, 20 Jan 2010 14:51:07 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] radio: Add support for SAA7706H Car Radio DSP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These sets of patches added support for the SAA7706H Car Radio DSP.

Patch 1:
Add The saa7706h to the v4l2-chip-ident.h
Patch 2:
Add the actual source code
Patch 3:
Add the saa7706h to the Kconfig and Makefile

--Richard


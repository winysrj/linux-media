Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:2053 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0AVJI4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 04:08:56 -0500
Message-ID: <4B596B1B.1060407@pelagicore.com>
Date: Fri, 22 Jan 2010 10:08:43 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/3] radio: Add support for SAA7706H Car Radio DSP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These sets of patches added support for the SAA7706H Car Radio DSP.

Patch 2 is updated after feedback from Hans Verkuil. Thanks Hans!

Patch 1:
Add The saa7706h to the v4l2-chip-ident.h
Patch 2:
Add the actual source code
Patch 3:
Add the saa7706h to the Kconfig and Makefile

--Richard


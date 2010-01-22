Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:3189 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab0AVMie (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 07:38:34 -0500
Message-ID: <4B599C3D.1060909@pelagicore.com>
Date: Fri, 22 Jan 2010 13:38:21 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] radio: Add radio-timb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the intel russellville board there is a radio DSP, radio tuner and a RDS block.

This umbrella driver uses two subdevs (DSP and tuner), and reads RDS data.

Patch1:
The actual code
Patch2:
Add the radio-timb to Kconfig and Makefile

--Richard


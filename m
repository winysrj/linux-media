Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:2785 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab0A0QWH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 11:22:07 -0500
Message-ID: <4B606825.2080606@pelagicore.com>
Date: Wed, 27 Jan 2010 17:21:57 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/2] radio: Add radio-timb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the intel russellville board there is a radio DSP, radio tuner and a RDS block.

This umbrella driver uses two subdevs (DSP and tuner), and reads RDS data.

Updated after feedback from Hans Verkuil. Thanks Hans!

Patch1:
The actual code
Patch2:
Add the radio-timb to Kconfig and Makefile

--Richard


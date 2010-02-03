Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:1261 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289Ab0BCOKZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 09:10:25 -0500
Message-ID: <4B6983C5.30904@pelagicore.com>
Date: Wed, 03 Feb 2010 15:10:13 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v3 0/1] radio: Add radio-timb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the intel russellville board there is a radio DSP, radio tuner and a RDS block.

This umbrella driver uses two subdevs (DSP and tuner).

Since v2, the RDS support has been removed from the patch. The current API in V4L2
and the simplicity of the Radio DSP makes it a bit complicated to implement the
RDS support properly. It will be added at a later stage.

--Richard


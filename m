Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1I1ILt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 04:11:49 -0400
Date: Wed, 28 Sep 2011 10:11:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Paul Mundt <lethal@linux-sh.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: acks needed
Message-ID: <Pine.LNX.4.64.1109281008310.30317@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul, Magnus

The following patches need your acks to allow the whole stack to go on 
time into 3.2 without breaking platforms even intermittently.

[20/59] ARM: ap4evb: switch imx074 configuration to default number of lanes
http://patchwork.linuxtv.org/patch/7514/
[27/59] ARM: mach-shmobile: convert mackerel to mediabus flags
http://patchwork.linuxtv.org/patch/7506/
[28/59] sh: convert ap325rxa to mediabus flags
http://patchwork.linuxtv.org/patch/7513/
[49/59] sh: ap3rxa: remove redundant soc-camera platform data fields
http://patchwork.linuxtv.org/patch/7517/
[50/59] sh: migor: remove unused ov772x buswidth flag
http://patchwork.linuxtv.org/patch/7516/
[56/59] ARM: mach-shmobile: mackerel doesn't need legacy SOCAM_* flags anymore
http://patchwork.linuxtv.org/patch/7523/

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

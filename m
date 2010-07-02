Return-path: <linux-media-owner@vger.kernel.org>
Received: from web23205.mail.ird.yahoo.com ([217.146.189.60]:31359 "HELO
	web23205.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757061Ab0GBMVX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jul 2010 08:21:23 -0400
Message-ID: <860779.65625.qm@web23205.mail.ird.yahoo.com>
Date: Fri, 2 Jul 2010 05:14:41 -0700 (PDT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Subject: Is there any limit in stb6100 driver that prevents tuning SR < 1 Msps
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i tried tuning to a channel that has a SR < 1 Msps in DVB-S with szap and I get

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_SET_FRONTEND failed: Invalid argument

is there any limit in driver that doesn't allow my TT S2-3200 to try to tune into that tranponder?

I know according to specification card only supports tuning from 1 Mbps - 30 Mbps, but that's specification for most cards. Most of the cards can also lock at signals with lower SRs.

There are some low SR channels on Astra 3a http://flysat.com/astra23.php
12660 V and 12661 V

with Technisat Skystar 2 it's working without a problem.

kind regards

Newspaperman



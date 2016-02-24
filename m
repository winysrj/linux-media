Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36965 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbcBXPxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 10:53:23 -0500
Received: by mail-wm0-f50.google.com with SMTP id g62so36159770wme.0
        for <linux-media@vger.kernel.org>; Wed, 24 Feb 2016 07:53:22 -0800 (PST)
Received: from [192.168.0.2] (host150-8-dynamic.249-95-r.retail.telecomitalia.it. [95.249.8.150])
        by smtp.googlemail.com with ESMTPSA id b203sm4077242wmh.8.2016.02.24.07.53.19
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 24 Feb 2016 07:53:21 -0800 (PST)
Message-ID: <56CDD1ED.1020207@gmail.com>
Date: Wed, 24 Feb 2016 16:53:17 +0100
From: angelo <angelo70@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: some help on si4745
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

wondering if someone here can help me. I arranged up a driver
for this chip starting from si476x driver.

Chip is actually connected in i2c.

Chip works mainly well, in some strange combination of tune / seek
operations, it become unresponsive. No answer to any i2c command is
given anymore. Only hardware reset helps.

If you have some idea / hint on the issue, really appreciated.

(I attach some debug messages)

Many thanks
Angelo Dureghello

si4745-core 1-0063: si4745_core_cmd_fm_tune_status
si4745-core 1-0063: cmd 22, usecs 1000
args : 00
reply : 81 02 22 38 1d 05 50 01
si4745-core 1-0063: reply good
si4745: si4745_radio_s_frequency: entering
si4745: si4745_radio_s_frequency: tuning : v4l2 8760 si4745 1401600

si4745-core 1-0063: si4745_core_cmd_fm_tune_status
si4745-core 1-0063: cmd 22, usecs 1000
args : 01
reply : 80 02 22 38 1d 05 50 01
si4745-core 1-0063: reply good
si4745-core 1-0063: cmd 20, usecs 200000
args : 00 22 38 00
reply : 80
si4745-core 1-0063: reply good
si4745-core 1-0063: cmd 14, usecs 100
args :
reply : 81
si4745-core 1-0063: reply good
si4745-core 1-0063: cmd 12, usecs 80000
args : 00 01 04 bb 80
si4745: si4745_radio_g_tuner: entering
si4745-core 1-0063: cmd 23, usecs 1000
args : 00
reply : 00 00 00 00 00 00 00 00
si4745-core 1-0063: reply wrong
si4745: si4745_radio_g_tuner: entering
si4745-core 1-0063: cmd 23, usecs 1000
args : 00
reply : 00 00 00 00 00 00 00 00
si4745-core 1-0063: reply wrong
si4745: si4745_radio_g_tuner: entering
si4745-core 1-0063: cmd 23, usecs 1000
args : 00
reply : 00 00 00 00 00 00 00 00
si4745-core 1-0063: reply wrong
si4745: si4745_radio_g_tuner: entering
si4745-core 1-0063: cmd 23, usecs 1000

si4745-core 1-0063: Core device is dead.



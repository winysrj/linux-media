Return-path: <mchehab@pedra>
Received: from web29505.mail.ird.yahoo.com ([77.238.189.132]:28878 "HELO
	web29505.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755281Ab0IHOic convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 10:38:32 -0400
Message-ID: <53883.46670.qm@web29505.mail.ird.yahoo.com>
Date: Wed, 8 Sep 2010 14:38:29 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Subject: budget-ci.c : Wrong IR map for bundled Technotrend S2-3200 remote
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi!

in budget-ci.c RC_MAP_TT_3200 is set for a Technotrend S2-3200. But this RC map doesn't seems to be 100% correct. 

       case 0x1019:
                /* For the TT 3200 bundled remote */
                ir_codes = RC_MAP_TT_3200;
                break;

if I set ir_codes = RC_MAP_TT_1500 
all keys will be recognized with evtest. So RC_MAP_TT_1500 is the correct map

So are there different revisions of remotes bundled with Technotrend S2-3200?
Or is this just a driver bug?

kind regards

Newsy



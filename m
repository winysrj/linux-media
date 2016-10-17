Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:44320 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932911AbcJQMZW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 08:25:22 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Mayo <aklhfex@gmail.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] v4l-utils: fixed dvbv5 vdr format
Date: Mon, 17 Oct 2016 14:24:30 +0200
Message-Id: <1476707072-21985-1-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de>
References: <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, hi Chris

sorry (again) for my late reply [1]. I merged & tested the patches of Chris [2]
and mine [3] fixing the vdr channel format. Since the patches had a conflict,
I had to slightly modify the patch [2] from Chris. --> Chris, I hope this is OK
for you.

I tested DVB-S2 and DVB-T with vdr (2.2.0/2.2.0) / DVB-T(2) has also been tested
by Chris [2].

[1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg102138.html
[2] https://patchwork.linuxtv.org/patch/35803/
[3] https://patchwork.linuxtv.org/patch/36293/

-- Markus --

Chris Mayo (1):
  libdvbv5: Improve vdr format output for DVB-T(2)

Markus Heiser (1):
  v4l-utils: fixed dvbv5 vdr format

 lib/libdvbv5/dvb-vdr-format.c | 56 +++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 18 deletions(-)

-- 
2.7.4


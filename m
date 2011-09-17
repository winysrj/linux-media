Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55920 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1IQVf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 17:35:29 -0400
Received: by wwn22 with SMTP id 22so2115683wwn.1
        for <linux-media@vger.kernel.org>; Sat, 17 Sep 2011 14:35:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 17 Sep 2011 17:35:27 -0400
Message-ID: <CALzAhNUObL0WB2wfsVEKdNP_qddHtQyygz730AfNfPFNbJfbJg@mail.gmail.com>
Subject: [GIT PULL for v3.2] [media] saa7164: Adding support for HVR2200 card
 id 0x8953
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull 92aa36f8f9d19b7c47ad3daca15aa0932254246b from
git://git.kernellabs.com/stoth/saa7164-dev.git

Another SAA7164 HVR220 card profile.

http://git.kernellabs.com/?p=stoth/saa7164-dev.git;a=commit;h=92aa36f8f9d19b7c47ad3daca15aa0932254246b

drivers/media/video/saa7164/saa7164-cards.c |   62 +++++++++++++++++++++++++++
drivers/media/video/saa7164/saa7164-dvb.c   |    1 +
drivers/media/video/saa7164/saa7164.h       |    1 +

Thanks,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

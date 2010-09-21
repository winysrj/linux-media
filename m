Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65526 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0IUIt2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 04:49:28 -0400
Received: by eyb6 with SMTP id 6so1842068eyb.19
        for <linux-media@vger.kernel.org>; Tue, 21 Sep 2010 01:49:26 -0700 (PDT)
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv2 0/2] Si4713 fix and regulator fw support
Date: Tue, 21 Sep 2010 11:49:41 +0300
Message-Id: <1285058983-28657-1-git-send-email-jhnikula@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

Repost of these two patches. I added Eduardo's ack to 1st and moved regulator
management in 2nd to single place only as suggested by Eduardo.

My first version was separating them to radio-si4713.c and si4713-i2c.c and
indeed then there is a risk that vio is missed if si4713-i2c.c is reused in
another driver. Anyway vio issue (if not enabled before si4713_probe) must be
solved in system level or in i2c core, not in radio-si4713.c.

Earlier version and thread can be found from here:
http://www.spinics.net/lists/linux-media/msg20199.html


-- 
Jarkko

Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:35595 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3FCPQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 11:16:18 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=endymion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1UjWUX-0003SZ-4X
	(TLSv1:AES128-SHA:128)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Mon, 03 Jun 2013 17:16:13 +0200
Date: Mon, 3 Jun 2013 17:16:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] dvb-apps: Improve femon
Message-ID: <20130603171607.73d0b856@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improvements to dvb-apps/femon:
* femon: Share common code
* femon: Display SNR in dB
* femon: Handle -EOPNOTSUPP

-- 
Jean Delvare

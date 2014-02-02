Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsafe.webbplatsen.se ([94.247.172.109]:61306 "EHLO
	mailsafe.webbplatsen.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaBBOII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Feb 2014 09:08:08 -0500
Received: from skinbark.wpsintrax.se (unknown [83.145.49.220])
	by mailsafe.webbplatsen.se (Halon Mail Gateway) with ESMTP
	for <linux-media@vger.kernel.org>; Sun,  2 Feb 2014 15:07:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by skinbark.wpsintrax.se (Postfix) with ESMTP id A3729BC80F9
	for <linux-media@vger.kernel.org>; Sun,  2 Feb 2014 15:08:03 +0100 (CET)
Received: from skinbark.wpsintrax.se ([127.0.0.1])
	by localhost (skinbark.wpsintrax.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XxentSZBXx3l for <linux-media@vger.kernel.org>;
	Sun,  2 Feb 2014 15:08:03 +0100 (CET)
Received: from tor.valhalla.alchemy.lu (vodsl-9074.vo.lu [85.93.202.114])
	by skinbark.wpsintrax.se (Postfix) with ESMTPA id 4FE31BC8027
	for <linux-media@vger.kernel.org>; Sun,  2 Feb 2014 15:08:03 +0100 (CET)
Date: Sun, 2 Feb 2014 15:08:02 +0100
From: Joakim Hernberg <jbh@alchemy.lu>
To: linux-media@vger.kernel.org
Subject: TeVii S-471 / ds3000 frontend firmware loading
Message-ID: <20140202150802.37e08a69@tor.valhalla.alchemy.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Does anyone know why my system keeps loading the ds3000 firmware
continuously?  I still have to debug this more deeply, but according to
my kernel buffer, it loads the firmware everytime the device has been
idle for a few secs and is asked to do something again.

>From my initial browsing of the code, I think that
dvb_frontend_ops.init() keeps getting called.

-- 

   Joakim

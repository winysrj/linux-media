Return-path: <mchehab@pedra>
Received: from smtp182.iad.emailsrvr.com ([207.97.245.182]:50814 "EHLO
	smtp182.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab1DHA4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 20:56:37 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp38.relay.iad1a.emailsrvr.com (SMTP Server) with ESMTP id D85793483CB
	for <linux-media@vger.kernel.org>; Thu,  7 Apr 2011 20:50:22 -0400 (EDT)
Received: from dynamic9.wm-web.iad.mlsrvr.com (dynamic9.wm-web.iad1a.rsapps.net [192.168.2.216])
	by smtp38.relay.iad1a.emailsrvr.com (SMTP Server) with ESMTP id C08583482F9
	for <linux-media@vger.kernel.org>; Thu,  7 Apr 2011 20:50:22 -0400 (EDT)
Received: from mailtrust.com (localhost [127.0.0.1])
	by dynamic9.wm-web.iad.mlsrvr.com (Postfix) with ESMTP id B04DB3200A4
	for <linux-media@vger.kernel.org>; Thu,  7 Apr 2011 20:50:22 -0400 (EDT)
Date: Thu, 7 Apr 2011 20:50:22 -0400 (EDT)
Subject: Prof 7500 demod crashing after many tunes
From: "Aaron" <aaron@chinesebob.net>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Message-ID: <1302223822.720720176@192.168.4.58>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  I wrote a scan program that steps through all the frequencies in a given range and tries to tune them in a for loop. This is my first C program so be nice, 

http://chinesebob.net/dvb/blindscan-s2/blindscan-s2-201104070153.tgz 

I'm using it with my Prof 7500, which uses the dvb-usb-dw2102 and stv0900 modules, this way I can use the blindscan algo and do a blind scan for all transponders in a satellite to find the symbol rates. A problem I'm having now is that after something like 60 tuning attempts the demod crashes and I cannot tune anything else unless I reset power on the tuning device, this is a usb device. Resetting the usb bus and removing/readding the drivers doesn't help. This happens on any version of s2-liplianin I've tried from 3 months ago to current. The current version of s2-liplianin tunes much faster but, that just means it will crash faster when I try my tuning loop. Please let me know what kind of debugging I should do and what I should post to the list that would be helpful to figure this out. When it's in this state I get a constant DEMOD LOCK OK, and it thinks it has 100% signal, is there some way to force the demod to think it is not locking, or force reset the demod somehow without resetting power to the device?   


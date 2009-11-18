Return-path: <linux-media-owner@vger.kernel.org>
Received: from anny.lostinspace.de ([80.190.182.2]:57737 "EHLO
	anny.lostinspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbZKRUkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 15:40:00 -0500
Received: from server.idefix.lan (ppp-93-104-109-205.dynamic.mnet-online.de [93.104.109.205])
	(authenticated bits=0)
	by anny.lostinspace.de (8.14.3/8.14.3) with ESMTP id nAIKUY26046196
	for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 21:30:38 +0100 (CET)
	(envelope-from idefix@fechner.net)
Received: from localhost (unknown [127.0.0.1])
	by server.idefix.lan (Postfix) with ESMTP id 3721695C54
	for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 21:31:53 +0100 (CET)
Received: from server.idefix.lan ([127.0.0.1])
	by localhost (server.idefix.lan [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KdGapAnqr0Hv for <linux-media@vger.kernel.org>;
	Wed, 18 Nov 2009 21:31:48 +0100 (CET)
Received: from [192.168.0.151] (idefix.idefix.lan [192.168.0.151])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by server.idefix.lan (Postfix) with ESMTPSA id D1D6695C52
	for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 21:31:48 +0100 (CET)
Message-ID: <4B0459B1.50600@fechner.net>
Date: Wed, 18 Nov 2009 21:31:45 +0100
From: Matthias Fechner <idefix@fechner.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: IR Receiver on an Tevii S470
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I bought some days ago a Tevii S470 DVB-S2 (PCI-E) card and got it 
running with the driver from:
http://mercurial.intuxication.org/hg/s2-liplianin

But I was not successfull in got the IR receiver working.
It seems that it is not supported yet by the driver.

Is there maybe some code available to get the IR receiver with evdev 
running?

Thanks a lot,
Matthias

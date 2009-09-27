Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:63655 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZI0PTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2009 11:19:47 -0400
Received: from mbp.kernelscience.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KQM00H50YL30V40@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Sun, 27 Sep 2009 11:19:51 -0400 (EDT)
Date: Sun, 27 Sep 2009 11:19:51 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: HVR1800 ATSC regression - Fails to attach DVB
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4ABF8297.6000507@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm seeing a regression in tip. A Hauppauge HVR1800 model 78521 fails to have 
its demod for DTV attached correctly, resulting in a total loss of ATSC/QAM support.

I'm looking into this.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

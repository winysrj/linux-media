Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:36390 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab1GWKdc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 06:33:32 -0400
Received: from mail-in-08-z2.arcor-online.net (mail-in-08-z2.arcor-online.net [151.189.8.20])
	by mx.arcor.de (Postfix) with ESMTP id A028535A553
	for <linux-media@vger.kernel.org>; Sat, 23 Jul 2011 12:33:30 +0200 (CEST)
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net [151.189.21.53])
	by mail-in-08-z2.arcor-online.net (Postfix) with ESMTP id 87DB577CD0
	for <linux-media@vger.kernel.org>; Sat, 23 Jul 2011 12:33:30 +0200 (CEST)
Received: from [127.0.0.1] (dyndsl-095-033-076-011.ewe-ip-backbone.de [95.33.76.11])
	(Authenticated sender: treito@arcor.de)
	by mail-in-13.arcor-online.net (Postfix) with ESMTPSA id 5B39B212792
	for <linux-media@vger.kernel.org>; Sat, 23 Jul 2011 12:33:30 +0200 (CEST)
Message-ID: <4E2AA378.3050902@arcor.de>
Date: Sat, 23 Jul 2011 12:33:28 +0200
From: Treito <treito@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: s2-liplianin - dib0700 causes kernel oops!
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I tried to install s2-liplianin on changing kernel-versions. All in 
common is, that my Hauppauge Nova-T USB-Stick causes a kernel oops when 
plugged in. The devices are generated, but it does not tune. lsusb freezes.
Here is my kernel.log: http://pastebin.com/03hxKvme
The drivers from 2011-02-05 does not run, but the drivers from 
2010-10-16 runs perfectly.

Regards,

Sven

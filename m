Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:38322 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab1GVRTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 13:19:48 -0400
Received: from mail-in-06-z2.arcor-online.net (mail-in-06-z2.arcor-online.net [151.189.8.18])
	by mx.arcor.de (Postfix) with ESMTP id CAA1B2125BF
	for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 19:19:45 +0200 (CEST)
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net [151.189.21.44])
	by mail-in-06-z2.arcor-online.net (Postfix) with ESMTP id AC720157564
	for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 19:19:45 +0200 (CEST)
Received: from [127.0.0.1] (dyndsl-095-033-083-042.ewe-ip-backbone.de [95.33.83.42])
	(Authenticated sender: treito@arcor.de)
	by mail-in-04.arcor-online.net (Postfix) with ESMTPSA id 78D41A9F83
	for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 19:19:45 +0200 (CEST)
Message-ID: <4E29B130.1040206@arcor.de>
Date: Fri, 22 Jul 2011 19:19:44 +0200
From: Treito <treito@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: s2-liplianin - dib0700 causes kernel oops
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I tried to install s2-liplianin on changing kernel-versions. All in 
common is, that my Hauppauge Nova-T USB-Stick causes a kernel oops when 
plugged in. The devices are generated, but it does not tune. lsusb freezes.
Here is my kernel.log: http://pastebin.com/03hxKvme
The drivers from 2011-02-05 does not run, but the driver from 2010-10-16 
runs perfectly.

Regards,

Sven

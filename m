Return-path: <linux-media-owner@vger.kernel.org>
Received: from node02.cambriumhosting.nl ([217.19.16.163]:49084 "EHLO
	node02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZEaUA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 16:00:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by node02.cambriumhosting.nl (Postfix) with ESMTP id 1BF71B0001B4
	for <linux-media@vger.kernel.org>; Sun, 31 May 2009 21:37:14 +0200 (CEST)
Received: from node02.cambriumhosting.nl ([127.0.0.1])
	by localhost (node02.cambriumhosting.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nqveFL+1VmPN for <linux-media@vger.kernel.org>;
	Sun, 31 May 2009 21:37:12 +0200 (CEST)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl [84.245.3.195])
	by node02.cambriumhosting.nl (Postfix) with ESMTP id 5857AB0001A3
	for <linux-media@vger.kernel.org>; Sun, 31 May 2009 21:37:12 +0200 (CEST)
Received: from [192.168.1.239] (unknown [192.168.1.239])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id D1A8823BC4DE
	for <linux-media@vger.kernel.org>; Sun, 31 May 2009 21:37:11 +0200 (CEST)
Message-ID: <4A22DC66.8070304@powercraft.nl>
Date: Sun, 31 May 2009 21:37:10 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: w_scan 20090502, why is the new country code necessary, its breaking
 my systems
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,

My w_scan version 20081106 stopped working on my Debian system. I had
the following errors:
ERROR: Sorry - i couldn't get any working frequency/transponder

So I first checked if there was a wscan update.

I downloaded the new version:
http://wirbel.htpc-forum.de/w_scan/w_scan-20090504.tar.bz2

Why is w_scan not available in the Debian repository?

However my old command arguments did not work anymore:
old: ~/.wscan/wscan -t 3 -E 0 -O 0 -X tzap > ~/.wscan/channels.conf

main:2715: FATAL: Missing argument "-c" (country setting)

I had to make a new argument line:
~/.wscan/wscan -t 3 -A 1 -E 0 -O 0 -c NL -X tzap > ~/.wscan/channels.conf

This is very troubling for me because I must have a scan command that
works in complete Europa and not in one country. This is because I have
traveling systems that need to scan for channels on every stop.

Why :-( please explain and  try to fix this regression that a country
code is needed?

I was hoping for auto signal strength detection and automatic filtering
depending on the signal strength to remove duplicated channels from
different broadcast towers.. what work is being done to realize this,
and can I help by donating resources?

Thanks in advance,

Best regards,

Jelle de Jong







Return-path: <linux-media-owner@vger.kernel.org>
Received: from static.106.220.46.78.clients.your-server.de ([78.46.220.106]:46895
	"EHLO mail.vanguard.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZGWNYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 09:24:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.vanguard.fi (Postfix) with ESMTP id C2096C08BD
	for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 16:13:48 +0300 (EEST)
Received: from mail.vanguard.fi ([127.0.0.1])
	by localhost (mail.vanguard.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p2P6E6VUdxyq for <linux-media@vger.kernel.org>;
	Thu, 23 Jul 2009 16:13:41 +0300 (EEST)
Received: from mail.vanguard.fi (mail.vanguard.fi [78.46.220.106])
	by mail.vanguard.fi (Postfix) with ESMTP id 74486C089E
	for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 16:13:41 +0300 (EEST)
Date: Thu, 23 Jul 2009 16:13:41 +0300 (EEST)
From: Beepo / Vanguard <beepo@vanguard.fi>
Reply-To: Beepo / Vanguard <beepo@vanguard.fi>
To: linux-media@vger.kernel.org
Message-ID: <527169.2191248354821233.JavaMail.root@mail.vanguard.fi>
In-Reply-To: <5218617.2171248354673889.JavaMail.root@mail.vanguard.fi>
Subject: Problem scanning channels with s2-liplianin drivers on Terratec
 Cynergy C PCI HD
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry if this is cross posting. I already sent this message to linux-dvb list, but got a bounce from there saying that I should come here instead. So anyway here it goes:

I've been struggling for a while to get the channel scanning to work with my Terratec Cynergy C PCI HD DVB card. I'm using drivers from http://mercurial.intuxication.org/hg/s2-liplianin on Gentoo x86_64 system. Any help is greatly appreciated.

The problem might have something to do with dmesg entry: mantis_ack_wait (0): Slave RACK Fail !

By googling I found some patch for other card with same error message but the patch was quite old and didn't apply to the recent driver source.

I've tried with Gentoo genkernel (2.6.29-gentoo-r5) and with my own configuration (optimized for athlon64)
I've tried dvbscan that comes with gentoo pakage linuxtv-dvb-apps and with http://mercurial.intuxication.org/hg/scan-s2

The s2-liplianin driver for this card has worked with my previous Ubuntu installation few months ago.

I tried to gather as much information about the problem as I could:

http://www.vanguard.fi/terratec/dvbscan_output.txt
http://www.vanguard.fi/terratec/dmesg.txt
http://www.vanguard.fi/terratec/lspci.txt
http://www.vanguard.fi/terratec/emergeinfo.txt
http://www.vanguard.fi/terratec/kernel-config

Thank you in advance!

- Beepo

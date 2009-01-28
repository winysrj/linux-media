Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.server.beonex.com ([78.46.195.11]:48150 "EHLO
	mail.server.beonex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZA1XSY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 18:18:24 -0500
Message-ID: <4980E692.3030205@bucksch.org>
Date: Thu, 29 Jan 2009 00:13:22 +0100
From: Ben Bucksch <linux.news@bucksch.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Technisat SkyStar HD + CI + CA says "PC card did not respond"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware:
- DVB-S2: TechniSat SkyStar HD = Technotrend S2-3200
- CI: With corresponding CI
- CA: AlphaCrypt Light
- Pay-TV smartcard
Software:
- Ubuntu 8.04
- (A) Linux 2.6.28 with S2API drivers
   (B) Linux 2.6.27-rc5 with multiproto drivers (hg 855d0c878944)
   (C) Linux 2.6.23.1 with multiproto driver (20071118)
- gnutv

I keep getting "dvb_ca adaptor 0: PC card did not respond :(" on 
/var/log/syslog

I purchased a new AlphaCrypt and new CI (!), but still same problem :(

It used to work, I could record even encrypted HD movies with this card 
and older multiproto drivers (C) and another distro (Gentoo) about one 
year ago.

I'm puzzled and don't know what to do anymore. I have excluded almost 
all possibilities. Only remaining factors could be DVB card, smartcard, 
and distro.

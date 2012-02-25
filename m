Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:50721 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab2BYXBK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 18:01:10 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id q1PMeTUY018423
	for <linux-media@vger.kernel.org>; Sat, 25 Feb 2012 14:40:29 -0800
Received: from smtp1.sscnet.ucla.edu ([127.0.0.1])
	by localhost (smtp1.sscnet.ucla.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QB37v2SO3YD0 for <linux-media@vger.kernel.org>;
	Sat, 25 Feb 2012 14:40:22 -0800 (PST)
Received: from [192.168.1.12] (ABTS-KK-dynamic-029.215.172.122.airtelbroadband.in [122.172.215.29] (may be forged))
	(authenticated bits=0)
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id q1PMeIqS018411
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 25 Feb 2012 14:40:21 -0800
Message-ID: <4F49634E.3070709@cogweb.net>
Date: Sun, 26 Feb 2012 04:10:14 +0530
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Status of DVB-C cards with CI
References: <S1753518Ab2BYVN0/20120225211326Z+189@vger.kernel.org>
In-Reply-To: <S1753518Ab2BYVN0/20120225211326Z+189@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I'm trying to put together a box with DVB-C PCIe (or PCI) cards and CI 
support for recording in Denmark.

Is there support for any such cards in Linuxtv or mainline?

In Denmark, as I understand it, even the main national public station is 
encrypted, and as of January 2012 the transport stream is MPEG4.

NetUp's Dual DVB TC CI 
(http://www.netup.tv/en-EN/dual_dvb-t-c-ci_card.php) appears to have the 
features I'm looking for, but the driver is not in mainline. Are there 
other options?

Appreciate any suggestions!

David

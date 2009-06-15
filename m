Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:41231 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZFOUvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 16:51:40 -0400
Received: from IO.local (4-167.105-92.cust.bluewin.ch [92.105.167.4])
	(authenticated bits=0)
	by smtp1.infomaniak.ch (8.14.2/8.14.2) with ESMTP id n5FKjcBS025812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 15 Jun 2009 22:46:05 +0200
Message-ID: <4A36B2F1.5060006@deckpoint.ch>
Date: Mon, 15 Jun 2009 22:45:37 +0200
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TT-S1500 budget-ci registeration
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello to all,

I'm currently testing a TT-S1500 budget card with the TT budget CI 
adapter with vl4 tree and kernel 2.6.28.

When I modprobe budget_ci, the CI adapter seems to be detected but not 
registered in /dev/dvb/adapter3/ca0 as I would have expected it to be.

Instead I see the following output:

[  148.664846] input: Budget-CI dvb ir receiver saa7146 (0) as 
/devices/pci0000:00/0000:00:1e.0/0000:11:09.0/input/input5

Any suggestions/ideas what the cause may be and how I can attempt to 
solve this?

Thanks
Thomas

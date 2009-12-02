Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.infomaniak.ch ([84.16.68.90]:38998 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZLBObK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 09:31:10 -0500
Received: from dhcp-144-254-20-79.cisco.com (dhcp-144-254-20-79.cisco.com [144.254.20.79])
	(authenticated bits=0)
	by smtp2.infomaniak.ch (8.14.2/8.14.2) with ESMTP id nB2EVF1v032026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 2 Dec 2009 15:31:16 +0100
Message-ID: <4B167A32.7000509@deckpoint.ch>
Date: Wed, 02 Dec 2009 15:31:14 +0100
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TBS 6980 Dual DVB-S2 PCIe card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

Is someone already working on supporting the TBS 6980 Dual DVB-S2 PCIe 
card? http://www.tbsdtv.com/english/product/6980.html

Chips in use appear to be:
- Conexant CX23885 (PCI Express bridge)
- NXP/Conexant CX24132 (DVB-S/S2 tuner)
- NXP/Conexant CX24117 (DVB-S/S2 demodulator)

I know there is code in v4l-dvb for the CX23885 but I don't think I've 
seen any for the CX24132 and CX24117.

Any insight into supporting this card would be great

Thanks
Thomas

Return-path: <linux-media-owner@vger.kernel.org>
Received: from jaguar.purple-paw.com ([79.99.64.40]:39842 "EHLO
	jaguar.purple-paw.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2BVNFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 08:05:41 -0500
Received: from host81-134-21-140.in-addr.btopenworld.com ([81.134.21.140]:7238 helo=[172.16.1.12])
	by jaguar.purple-paw.com with esmtpa (Exim 4.69)
	(envelope-from <eddb@rker.me.uk>)
	id 1S0Bt6-0000U5-0W
	for linux-media@vger.kernel.org; Wed, 22 Feb 2012 13:05:40 +0000
Message-ID: <4F44E821.2010804@rker.me.uk>
Date: Wed, 22 Feb 2012 13:05:37 +0000
From: Edd Barker <eddb@rker.me.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cine CT v6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Members

I've just got a Cine CT v6 card and have having a bit of trouble. I want 
to use dvb-t only,  I've followed the instructions here...

http://linuxtv.org/wiki/index.php/Digital_Devices_DuoFlex_C%26T

The card is now appearing in /dev/dvb/adapter0 & /dev/dvb/adapter1. 
However only one frontend is showing up and if I try to scan dvb-t I get 
an error that I'm sure means I'm trying to use dvb-c tuner.

WARNING: frontend type (QAM) is not compatible with requested tuning 
type (OFDM)

I'm running on Ubuntu 11.10, 3.0.0-16 kernal.  Is this something anyone 
else has come across or knows what I can do to use the dvb-t frontend?

Thanks
Edd

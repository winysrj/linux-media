Return-path: <linux-media-owner@vger.kernel.org>
Received: from csldevices.co.uk ([77.75.105.137]:47621 "EHLO
	mhall.vps.goscomb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755307Ab0AULcX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 06:32:23 -0500
Received: from [212.49.228.51] (helo=[192.168.17.1])
	by mhall.vps.goscomb.net with esmtp (Exim 4.63)
	(envelope-from <phil@csldevices.co.uk>)
	id 1NXuoQ-000206-Sp
	for linux-media@vger.kernel.org; Thu, 21 Jan 2010 11:02:54 +0000
Message-ID: <4B583459.3030909@csldevices.co.uk>
Date: Thu, 21 Jan 2010 11:02:49 +0000
From: Philip Downer <phil@csldevices.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Conexant Systems, Inc. Hauppauge Inc. HDPVR-1250 model 1196 (rev
 04) [How to make it work?]
References: <1264012191.4038.60.camel@urkkimylly>
In-Reply-To: <1264012191.4038.60.camel@urkkimylly>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ukko Happonen wrote:
> How do I make the TV tuner work?
>
> lspci -d 14f1:8880 -v says
>         Kernel driver in use: cx23885
>         Kernel modules: cx23885
>   

Looks to me like it's already working.

Do you have a /dev/dvb/adapter0 dir with anything in it? if so see 
http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device

Phil

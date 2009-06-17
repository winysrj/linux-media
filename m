Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:56164 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbZFQNqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 09:46:48 -0400
Received: from mail-in-09-z2.arcor-online.net (mail-in-09-z2.arcor-online.net [151.189.8.21])
	by mx.arcor.de (Postfix) with ESMTP id E1DF11B3857
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 15:46:49 +0200 (CEST)
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net [151.189.21.57])
	by mail-in-09-z2.arcor-online.net (Postfix) with ESMTP id BD89828F255
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 15:46:49 +0200 (CEST)
Received: from [192.168.0.140] (dslb-084-062-087-173.pools.arcor-ip.net [84.62.87.173])
	(Authenticated sender: andreas.huesgen@arcor.de)
	by mail-in-17.arcor-online.net (Postfix) with ESMTPSA id 9916E3B257D
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 15:46:49 +0200 (CEST)
Message-ID: <4A38F3C8.5000608@arcor.de>
Date: Wed, 17 Jun 2009 15:46:48 +0200
From: Andreas Huesgen <andreas.huesgen@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Elgato EyeTV Diversity Support in dib0700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I few days ago I bought an Elgato EyeTV Diversity. After some googling, 
I found patches for it at 
http://www.linuxtv.org/pipermail/linux-dvb/2008-September/028813.html. 
Applying the patches succeeded (I only hat to adjust the index into 
dib0700_usb_id_table) and after rebooting the card worked without 
problems. Even the remote control worked properly with the Xorg evdev 
driver after setting dvb_usb_dib0700_ir_proto to NEC.

So I wondered if there is a reason why the patches have not been merged, 
yet. I searched the hg drivers as well as the developer repositories at 
http://linuxtv.org/hg/ and the mailing list archives but found little to 
no references referring to the EyeTV Diversity.

I just wanted to mention it in case that the patches have been forgotten 
or something similar.

Best Regards,

Andreas Huesgen

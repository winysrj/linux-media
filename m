Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator4.ecc.gatech.edu ([130.207.185.174]:59457 "EHLO
	deliverator4.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbZE1EF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 00:05:59 -0400
Received: from deliverator4.ecc.gatech.edu (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id DF34A5E41C1
	for <linux-media@vger.kernel.org>; Thu, 28 May 2009 00:06:00 -0400 (EDT)
Received: from mail7.gatech.edu (bigip.ecc.gatech.edu [130.207.185.140])
	by deliverator4.ecc.gatech.edu (Postfix) with ESMTP id 968275E41A0
	for <linux-media@vger.kernel.org>; Thu, 28 May 2009 00:06:00 -0400 (EDT)
Received: from [192.168.0.131] (bigip.ecc.gatech.edu [130.207.185.140])
	(Authenticated sender: gtg131s)
	by mail7.gatech.edu (Postfix) with ESMTP id 6EAEE2C8935
	for <linux-media@vger.kernel.org>; Thu, 28 May 2009 00:06:00 -0400 (EDT)
Message-ID: <4A1E0DA7.6040702@gatech.edu>
Date: Thu, 28 May 2009 00:05:59 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: "Unknown symbol __udivdi3" with rev >= 11873
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Revision 11873 (committed earlier today) has broken the cx18 driver for 
me, with the line "cx18: Unknown symbol __udivdi3" appearing in dmesg 
when the module tries to load.  I'm using Ubuntu 8.04.2 which uses 
kernel 2.6.24 and gcc 4.2.4.

I also wanted to express my appreciation to Mauro for fixing the build 
for older kernels today, as it is very desirable for me to use a 
distribution/kernel which has long-term support and updates, but I 
simply need to add a DVB driver that wasn't part of the older kernel.

Thanks so much.

David Ward

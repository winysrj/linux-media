Return-path: <linux-media-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:34122 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbZKENPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 08:15:20 -0500
Received: from justin.dk (x1-6-00-1e-2a-2a-4e-62.k46.webspeed.dk [62.243.85.168])
	by pfepa.post.tele.dk (Postfix) with ESMTP id 537D3A50011
	for <linux-media@vger.kernel.org>; Thu,  5 Nov 2009 14:15:24 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by justin.dk (Postfix) with ESMTP id A5215480581D8
	for <linux-media@vger.kernel.org>; Thu,  5 Nov 2009 14:15:24 +0100 (CET)
Received: from justin.dk ([127.0.0.1])
	by localhost (justin.dk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D3U71-Ad0t-N for <linux-media@vger.kernel.org>;
	Thu,  5 Nov 2009 14:15:19 +0100 (CET)
Received: from [192.168.0.3] (x1-6-00-1e-2a-2a-4e-62.k46.webspeed.dk [62.243.85.168])
	by justin.dk (Postfix) with ESMTPSA id 4CDE64805688E
	for <linux-media@vger.kernel.org>; Thu,  5 Nov 2009 14:15:19 +0100 (CET)
Message-ID: <4AF2CFE7.8080700@justin.dk>
Date: Thu, 05 Nov 2009 14:15:19 +0100
From: Justin Raug Veggerby <veggerby@justin.dk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problems with Terratec Cinergy C PCI (DVB-C)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I am at the point where I almost give up.

I have tried to get my mediacenter to recognize and use the Terratech
Cinergy C card, the lspci output looks like the lspci output on the wiki
page about this card:
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C

I am not a C programmer, but I have looked at the sources from:

http://mercurial.intuxication.org/hg/s2-liplianin

And from what I can tell (from inserting some debug printk) the 
tda10023_attach is called, but it fails as the id is returned as being 255.
I know it reaches this line:
if ((id & 0xf0) != 0x70) goto error;

But it doesn't reach the printk below that:
printk("TDA10023: i2c-addr = 0x%02x, id = 0x%02x\n", 
state->config->demod_address, id);


Can anybody help me?

Best regards
Justin





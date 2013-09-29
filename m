Return-path: <linux-media-owner@vger.kernel.org>
Received: from ogmios.wolfblood.net ([151.236.13.79]:50649 "EHLO
	ogmios.wolfblood.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3I2LRc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Sep 2013 07:17:32 -0400
Received: from localhost (localhost [127.0.0.1])
	by ogmios.wolfblood.net (Postfix) with ESMTP id D0FF01FCCC
	for <linux-media@vger.kernel.org>; Sun, 29 Sep 2013 11:11:03 +0000 (UTC)
Received: from ogmios.wolfblood.net ([127.0.0.1])
	by localhost (ogmios.wolfblood.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k64-6JnqfjKu for <linux-media@vger.kernel.org>;
	Sun, 29 Sep 2013 11:11:03 +0000 (UTC)
Received: from neto.wolf.local (neto.wolf.local [90.146.28.98])
	by ogmios.wolfblood.net (Postfix) with ESMTP id A87591FCB2
	for <linux-media@vger.kernel.org>; Sun, 29 Sep 2013 11:11:03 +0000 (UTC)
Received: from nb1.wolf.local (unknown [192.168.0.1])
	(Authenticated sender: benjamin@benvei.at)
	by neto.wolf.local (Postfix) with ESMTPSA id 486F71101054
	for <linux-media@vger.kernel.org>; Sun, 29 Sep 2013 11:11:04 +0000 (UTC)
Message-ID: <52480AC7.6030507@benvei.at>
Date: Sun, 29 Sep 2013 11:11:03 +0000
From: Benjamin Veitschegger <benjamin@benvei.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Technisat CableStar Combi CI HD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

i'm currently trying to get a "Technisat CableStar Combo CI HD" to work 
under debian wheezy, kernel 3.11.

I've followed [1], and at first everything looked fine, the card seems 
to be recognized, and the drivers are loaded. (dmesg)

So, i've tried to scan for some dvb-c channels, and drxk started 
spamming my dmesg.

[ 1407.088033] drxk: SCU not ready
[ 1407.088046] drxk: Error -5 on get_qam_lock_status
[ 1407.088052] drxk: Error -5 on get_lock_status
[.....]

Does anyone have an idea, how to fix it? According to the wiki, there 
are already people, who got the device working.

Thanks.
Benjamin

[1] http://www.linuxtv.org/wiki/index.php/TechniSat_CableStar_Combo_HD_CI


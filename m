Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv2.obs-besancon.fr ([193.52.185.12]:52841 "EHLO
	serv2.obs-besancon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbZIAWSX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 18:18:23 -0400
Received: from localhost (localhost [127.0.0.1])
	by serv2.obs-besancon.fr (Postfix) with ESMTP id C725A8B35E
	for <linux-media@vger.kernel.org>; Tue,  1 Sep 2009 23:55:43 +0200 (CEST)
Received: from serv2.obs-besancon.fr ([127.0.0.1])
	by localhost (serv2.obs-besancon.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hIxJAKBK2jnA for <linux-media@vger.kernel.org>;
	Tue,  1 Sep 2009 23:55:43 +0200 (CEST)
Received: from services3.obs-besancon.fr (services3.obs-besancon.fr [193.52.184.204])
	by serv2.obs-besancon.fr (Postfix) with ESMTP id 91CE58B352
	for <linux-media@vger.kernel.org>; Tue,  1 Sep 2009 23:55:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by services3.obs-besancon.fr (Postfix) with ESMTP id B240B6F5E6
	for <linux-media@vger.kernel.org>; Tue,  1 Sep 2009 23:56:03 +0200 (CEST)
Received: from services3.obs-besancon.fr ([127.0.0.1])
	by localhost (services3.obs-besancon.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cyxmws74kWoZ for <linux-media@vger.kernel.org>;
	Tue,  1 Sep 2009 23:56:03 +0200 (CEST)
Received: from localhost (serv2.obs-besancon.fr [193.52.185.12])
	by services3.obs-besancon.fr (Postfix) with ESMTP id 86E526F5E5
	for <linux-media@vger.kernel.org>; Tue,  1 Sep 2009 23:56:03 +0200 (CEST)
Message-ID: <20090901235543.7hoqudid6sg80o88@webmail.obs-besancon.fr>
Date: Tue, 01 Sep 2009 23:55:43 +0200
From: lorin@obs-besancon.fr
To: linux-media@vger.kernel.org
Subject: Driver for webcams based on GL860 chip.
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody!

I would like to add the support for GL860 based webcams within the  
GSPCA framework.

A patch (116KB) for that can be found at :
http://launchpadlibrarian.net/31182405/patchu_gl860g.diff

This is not a final version, some improvement in the auto detection of  
sensor will be done. Before that I'm waiting for comments about what  
should changed in this patch in order to be accepted.

Basically there is four managed sensors so that this patch add a new  
directory in the gspca one, it contains the main part of the driver  
and the four sub-drivers.

Olivier Lorin

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.



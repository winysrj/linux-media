Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.oregonstate.edu ([128.193.15.36]:40407 "EHLO
	smtp2.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZJNVwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 17:52:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.oregonstate.edu (Postfix) with ESMTP id C05653C146
	for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 14:42:30 -0700 (PDT)
Received: from smtp2.oregonstate.edu ([127.0.0.1])
	by localhost (smtp.oregonstate.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OidGqA-mBFn3 for <linux-media@vger.kernel.org>;
	Wed, 14 Oct 2009 14:42:30 -0700 (PDT)
Received: from [10.192.126.45] (spike.nws.oregonstate.edu [10.192.126.45])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp2.oregonstate.edu (Postfix) with ESMTPSA id 9C6053C12B
	for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 14:42:30 -0700 (PDT)
Message-ID: <4AD645DC.9090800@onid.orst.edu>
Date: Wed, 14 Oct 2009 14:42:52 -0700
From: Michael Akey <akeym@onid.orst.edu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DVB Hardware blind scan - frontend?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm looking to take advantage of "blind-scan" support in the STV0903 
DVB-S/S2 frontend.  What does this entail?  I'm not seeing anything in 
linux/dvb/frontend.h in regards to frontend capabilities and the ability 
to do frequency and symbol rate scans.  
drivers/media/dvb/dvb-core/dvb_frontend.h has talk of defining different 
search types and algorithms..  Where can I get more information about 
this?  Any example code I can look over out there?  Is blind-scan 
support still hardware-specific or does DVB API v5 support it?  Thanks 
for any help on the matter!

--Mike

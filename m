Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy3.bredband.net ([195.54.101.73]:60288 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZDEQQd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 12:16:33 -0400
Received: from ironport2.bredband.com (195.54.101.122) by proxy3.bredband.net (7.3.139)
        id 49D32712001DE961 for linux-media@vger.kernel.org; Sun, 5 Apr 2009 18:16:31 +0200
Message-ID: <49D8D953.9090802@catharsis.se>
Date: Sun, 05 Apr 2009 18:16:19 +0200
From: Carl Cedergren <carl@catharsis.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem with the Hauppauge Nexus CA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i am trying to get the Hauppauge Nexus CA's analogue tuner to work with 
2.6.26. No matter what i do all i get is the DVB as tuner. I got some 
help on #linuxtv that indicated that the saa7146 driver lacks support 
for the analogue tuner, and has lacked it for some time. Is this by 
design? Should i get a new card, or is this fixable in any way?

/Carl

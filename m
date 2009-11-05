Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp13.wxs.nl ([195.121.247.25]:61331 "EHLO psmtp13.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834AbZKEUEX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2009 15:04:23 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp13.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KSN007ENJRF87@psmtp13.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 05 Nov 2009 21:04:28 +0100 (MET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by localhost (8.14.3/8.14.3/Debian-6) with ESMTP id nA5K3T6T000790	for
 <linux-media@vger.kernel.org>; Thu, 05 Nov 2009 21:03:30 +0100
Date: Thu, 05 Nov 2009 21:03:25 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Make file request: default adddepmod instead of allyesmod
To: Linux-Media <linux-media@vger.kernel.org>
Message-id: <4AF32F8D.4090900@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tried to guide a newbie through compiling v4l.
v4l did not compile right away, because of a problem in one of the drivers

http://ubuntuforums.org/showthread.php?p=8241469#post8241469

a workaroudn was proposed:

http://ubuntuforums.org/showthread.php?t=1305228

I myself have not experienced this problem as I have used make alldepmod, where the offending driver was not selected.

Can the default config be reprogrammed from all yes (which might easily fail on certain kernel versions) to the all dep config ?

That way, new users have more chance to have a succesful make right away.


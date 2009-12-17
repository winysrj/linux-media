Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:41417 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZLQQCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 11:02:33 -0500
Received: from metzlerbros.de
	(ip-62-143-72-79.unitymediagroup.de [62.143.72.79])
	by post.strato.de (klopstock mo62) (RZmta 22.5)
	with ESMTP id v02aaclBHFc9zt for <linux-media@vger.kernel.org>;
	Thu, 17 Dec 2009 17:02:27 +0100 (MET)
Received: from rjkm by valen.metzler with local (Exim 4.69 #1 (Debian))
	id 1NLIo7-000237-3U
	for <linux-media@vger.kernel.org>; Thu, 17 Dec 2009 17:02:27 +0100
From: rjkm <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19242.22034.312020.662761@valen.metzler>
Date: Thu, 17 Dec 2009 17:02:26 +0100
To: <linux-media@vger.kernel.org>
Subject: Re: Cinergy 2400i - Micronas APB 7202A Open Sourced!
In-Reply-To: <8735422.255531261062196817.JavaMail.defaultUser@defaultHost>
References: <8735422.255531261062196817.JavaMail.defaultUser@defaultHost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sijones2006@o2.co.uk writes:
 >  
 > > The PCI-e bridge (MICRONAS APB 7202A) has now an open source 
 > driver. 
 > > It is available here git://projects.vdr-developer.org/mediapointer-
 > dvb-
 > > s2.git 
 > > could this now be pulled into the main V4L source? as it has been 
 > > brought upto date with the current DVB tree.
 > 
 > >The driver cannot be pulled in 'as is' for various reasons, but we 
 > are
 > >currently preparing the driver to make it ready for inclusion into 
 > the
 > >master HG repository/kernel.
 > 
 > Is there a repository that I can use to build / test this? and is the 
 > tuner supported as well??

I am not sure about the git repo but the original release included
drivers for the cards on the market (dual DVBS2 by DigitalDevices, 
Terratec Cinergy and an ATSC card) and all prototype cards.
Since most of the driver was written in 2005 it is a little 
"behind" regarding kernel API changes and available in-kernel drivers for 
tuners and demods. But you should be able to get hints from it
to adapt it to the current kernel/DVB repo. 


-Ralph Metzler

Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.london.02.net ([82.132.130.150]:54898 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754341AbZLQMn5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 07:43:57 -0500
Received: from surtees (82.132.130.219) by mail.o2.co.uk (8.0.013.3) (authenticated as sijones2006)
        id 4AF809CF09E7F1EC for linux-media@vger.kernel.org; Thu, 17 Dec 2009 12:37:34 +0000
Message-ID: <18222544.70531261053454346.JavaMail.defaultUser@defaultHost>
Date: Thu, 17 Dec 2009 12:37:34 +0000 (GMT)
From: <sijones2006@o2.co.uk>
Reply-To: <sijones2006@o2.co.uk>
To: linux-media@vger.kernel.org
Subject: Cinergy 2400i - Micronas APB 7202A Open Sourced!
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I know this has been brought up a number of times on Myth and other 
lists but there is now a change of circumstances.

The PCI-e bridge (MICRONAS APB 7202A) has now an open source driver. 
It is available here git://projects.vdr-developer.org/mediapointer-dvb-
s2.git 
could this now be pulled into the main V4L source? as it has been 
brought upto date with the current DVB tree.

The demodulators MICRONAS DRX 3975D seem to have a driver in the 
current tree.

My only issue is now the 

    * Tuner #1: THOMSON DTT 75202A (with RF connector)
    * Tuner #2: THOMSON DTT 75207 (with pin RF input)

I can't seem to be able to find a tuner that will work out of the git 
source I have pulled.

both the ngene and modulator modules I have to modprobe in, if i 
reboot they dont get reloaded, am currently running Unbuntu 9.10, any 
help would be appreciated! 

If the source for the PCI-e bridge can be brought into current then it 
would seem a number of cards would be able to work.

I think someone has already tried some work on another card which uses 
this bridge as wel

http://article.gmane.org/gmane.linux.drivers.video-input-
infrastructure/9180/match=ngene


Cheers


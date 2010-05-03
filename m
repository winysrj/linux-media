Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41020 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750854Ab0ECPq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 11:46:59 -0400
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-usb@vger.kernel.org
Subject: Terratec Cinergy T USB XXS (HD)/ T3 : doesn't resume
Date: Mon, 3 May 2010 17:46:46 +0200
Cc: linux-video@atrey.karlin.mff.cuni.cz, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005031746.46814.toralf.foerster@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

with that stick my ThinkPad T400 refuses to resume after s2ram.

During suspend the led of that stick doesn't went off. I can sucessful suspend 
my system with that stick plugged in if I remove it before I resume the 
system.

tfoerste@n22 ~/devel/linux-2.6 $ uname -a
Linux n22 2.6.34-rc6 #35 SMP Fri Apr 30 10:12:25 CEST 2010 i686 Intel(R) 
Core(TM)2 Duo CPU P8600 @ 2.40GHz GenuineIntel GNU/Linux

This issue happens with an older stable kernel too.

-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


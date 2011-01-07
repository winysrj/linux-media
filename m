Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:39305 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755399Ab1AGT4h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 14:56:37 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: Debug code in HG repositories
Date: Fri, 7 Jan 2011 20:53:36 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101072053.37211@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi guys,

are you aware that there is a lot of '#if 0' code in the HG repositories
which is not in GIT?

When drivers were submitted to the kernel from HG, the '#if 0' stuff was
stripped, unless it was marked as 'keep'...

This was fine, when development was done with HG.

As GIT is being used now, that code will be lost, as soon as the HG
repositories have been removed...

Any opinions how this should be handled?

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------

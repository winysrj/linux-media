Return-path: <mchehab@pedra>
Received: from fmmailgate01.web.de ([217.72.192.221]:53722 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1FITxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 15:53:41 -0400
Received: from smtp02.web.de  ( [172.20.0.184])
	by fmmailgate01.web.de (Postfix) with ESMTP id F32EA1916626A
	for <linux-media@vger.kernel.org>; Thu,  9 Jun 2011 21:53:39 +0200 (CEST)
Received: from [77.0.147.98] (helo=[192.168.1.99])
	by smtp02.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #2)
	id 1QUlIR-0004qr-00
	for linux-media@vger.kernel.org; Thu, 09 Jun 2011 21:53:39 +0200
Message-ID: <4DF124C3.6020309@web.de>
Date: Thu, 09 Jun 2011 21:53:39 +0200
From: Jannis Achstetter <jannis_achstetter@web.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TechniSat SkyStar S2 / CX24120-13Z again
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello list,

I'd like to bring up the discussion about the "TechniSat SkyStar S2" PCI
DVB-S2 card again. It has been asked once here:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/20733
but was never answered.
Information can be found here:
http://linuxtv.org/wiki/index.php/TechniSat_SkyStar_S2
There is the mentioned binary driver. And s.o. made a patch against DVB
s2-liplianin (http://mercurial.intuxication.org/hg/s2-liplianin/) that
adds support for the CX24120. It's not exactly a patch but a "run"-file
with script-header and a tar-archive that extracts the patch and applies
it directly.
Until linux 2.6.39 I patched the s2-liplianin with the patch (extracted
manually) and compiled the driver as module. This worked fine until
2.6.39 where the Big kernel lock (BKL) was dropped. Since then, the
s2-liplianin doesn't compile anymore (not related to the CX24120-patch).

Is the any chance to get it into mainline? Is there anything I can do
but testing? Prepare a patch against mainline with everything needed to
get the SkyStar S2 running?

Best regards,
	Jannis

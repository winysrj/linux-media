Return-path: <mchehab@pedra>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:40019 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab1B1L1C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:27:02 -0500
Received: from mfilter9-d.gandi.net (mfilter9-d.gandi.net [217.70.178.129])
	by relay1-d.mail.gandi.net (Postfix) with ESMTP id 003D12552EB
	for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 12:27:01 +0100 (CET)
Received: from relay1-d.mail.gandi.net ([217.70.183.193])
	by mfilter9-d.gandi.net (mfilter9-d.gandi.net [217.70.178.129]) (amavisd-new, port 10024)
	with ESMTP id moQVSVLF3RNj for <linux-media@vger.kernel.org>;
	Mon, 28 Feb 2011 12:26:59 +0100 (CET)
Received: from WIN7PC (ALyon-157-1-160-78.w109-213.abo.wanadoo.fr [109.213.151.78])
	(Authenticated sender: sr@coexsi.fr)
	by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 4B8842552F5
	for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 12:26:59 +0100 (CET)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
Subject: [DVB] Maintainers of dvb_core and budget_ci modules - Patches proposal
Date: Mon, 28 Feb 2011 12:26:59 +0100
Message-ID: <004d01cbd73a$6a6c0450$3f440cf0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear all,

Are-there some maintainers for the dvb_core module and the budget_ci module
on the linux-media mailing list?

I would like to discuss and submit some patches I have developed for these
modules:
- dvb_core: add an option for logging the PDU exchanged with the CAM for
debugging purposes
- dvb_core: clean all ring buffers associated with CAM when a device is
opened
- budget_ci: print information about CI firmware used
- budget_ci: add module option for disabling the IR receiver and the IRQ
mode

Best regards,
Sebastien.





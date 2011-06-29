Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54009 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1F2NQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 09:16:11 -0400
Received: from mfilter12-d.gandi.net (mfilter12-d.gandi.net [217.70.178.129])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id B30C4172088
	for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 15:16:09 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter12-d.gandi.net (mfilter12-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id jqB3TQDhommo for <linux-media@vger.kernel.org>;
	Wed, 29 Jun 2011 15:16:08 +0200 (CEST)
Received: from WIN7PC (ALyon-157-1-15-84.w81-251.abo.wanadoo.fr [81.251.54.84])
	(Authenticated sender: sr@coexsi.fr)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 1CB15172071
	for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 15:16:08 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [DVB] TT S-1500b tuning issue
Date: Wed, 29 Jun 2011 15:16:10 +0200
Message-ID: <00a301cc365e$b6d415c0$247c4140$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear all,

We have found what seems to be a tuning issue in the driver for the ALPS
BSBE1-D01A used in the new TT-S-1500b card from Technotrend.
On some transponders, like ASTRA 19.2E 11817-V-27500, the card can work very
well (no lock issues) for hours.

On some other transponders, like ASTRA 19.2E 11567-V-22000, the card nearly
never manage to get the lock: it's looking like the signal isn't good
enough.
I turned on the debugging of the stb6000 and stv0288 modules, but I can't
see anything wrong.

Also, we have noticed that the lock maybe lost by intermittence on others
transponders where it may work fine for few hours and then stop working for
few hours.

After doing some researches about the ALPS BSBE1-D01A frontend, I've found
it's the one used in the DREAMBOX DVB-S tuner module (that is running
Linux), but I didn't manage to find the source code repository to check
their drivers, maybe someone know where is it?

Best regards,
Sebastien.





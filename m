Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58949 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1FWVbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 17:31:08 -0400
Received: from mfilter4-d.gandi.net (mfilter4-d.gandi.net [217.70.178.134])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 24E3D17207C
	for <linux-media@vger.kernel.org>; Thu, 23 Jun 2011 23:31:06 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter4-d.gandi.net (mfilter4-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id fa5+ud2LbtcS for <linux-media@vger.kernel.org>;
	Thu, 23 Jun 2011 23:31:04 +0200 (CEST)
Received: from WIN7PC (ALyon-157-1-176-152.w109-213.abo.wanadoo.fr [109.213.63.152])
	(Authenticated sender: sr@coexsi.fr)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 8518817208C
	for <linux-media@vger.kernel.org>; Thu, 23 Jun 2011 23:31:04 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [DVB] Octopus driver status
Date: Thu, 23 Jun 2011 23:31:08 +0200
Message-ID: <017201cc31ec$de287ce0$9a7976a0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear all,

I'm looking at the Octopus DVB cards system from Digital Devices for a while
as their system seems to be very interesting 

Here is link with their products:
http://shop.digital-devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/6
2357162/Categories

The good points I have found:

* They support most of the common DVB standards: DVB-C, DVB-T, DVB-S and
DVB-S2
* They are moderately priced
* There is a CAM support with a CI adapter for unscrambling channels
* They are using the now de-facto standard PCI-Express bus
* The new Octopus system is using a LATTICE PCI-Express bridge that seems to
be more future proof than the previous bridge Micronas APB7202A
* They seem to be well engineered ("Designed and manufactured in Germany" as
they say!)

And now the doubts :

* The DVB-C/T frontend driver is specific to this system and is very new, so
as Devin said one week ago, it's maybe not yet production ready
* The way the CAM is supported break all the existing userland DVB
applications (gnutv, mumudvb, vlc, etc.)
* There isn't so much information about the Digital Devices company and
their products roadmap (at least in English)

So, my two very simple questions to the developers who worked on the drivers
(I think Oliver and Ralph did) and know the product:
* How you feel the future about the Octopus driver?
* Do you think a compatibility mode (like module parameter) can be added to
simulate the way the CAM is handled in the other drivers?

I'm ready to buy the different cards and do some testing if it can help.

Best regards,
Sebastien.



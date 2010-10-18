Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48442 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0JRGkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 02:40:19 -0400
Received: by bwz15 with SMTP id 15so374607bwz.19
        for <linux-media@vger.kernel.org>; Sun, 17 Oct 2010 23:40:18 -0700 (PDT)
From: =?US-ASCII?Q?Ali_Guller?= <aliguller@gmail.com>
To: "'Patrick Boettcher'" <pboettcher@kernellabs.com>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <201010171450.18459.pboettcher@kernellabs.com>
In-Reply-To: <201010171450.18459.pboettcher@kernellabs.com>
Subject: RE: [GIT PULL request for 2.6.37] Add Technisat SkyStar HD USB driver
Date: Mon, 18 Oct 2010 09:40:14 +0300
Message-ID: <000701cb6e8f$53583720$fa08a560$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Content-Language: tr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
Does this driver cover Technisat Skystar USB 2 device?. I mean non HD
version. Thank you.

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Patrick Boettcher
Sent: Sunday, October 17, 2010 3:50 PM
To: Mauro Carvalho Chehab
Cc: Linux Media Mailing List
Subject: [GIT PULL request for 2.6.37] Add Technisat SkyStar HD USB driver

Hi Mauro,

please 

git pull git://github.com/pboettch/linux-2.6.git for_mauro

for the following changes:

technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver
stv090x: add tei-field to config-structure
stv090x: added function to control GPIOs from the outside

Those are intended for 2.6.37 and have been rebased today on linuxtv's 
staging/2.6.37-branch.

The development of the new technisat-usb2-driver has been sponsored by 
Technisat UK.


Thanks in advance for pulling and commenting,
--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


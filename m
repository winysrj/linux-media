Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62049 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0JQMuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 08:50:24 -0400
Received: by wyb28 with SMTP id 28so2224556wyb.19
        for <linux-media@vger.kernel.org>; Sun, 17 Oct 2010 05:50:23 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL request for 2.6.37] Add Technisat SkyStar HD USB driver
Date: Sun, 17 Oct 2010 14:50:18 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010171450.18459.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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

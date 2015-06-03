Return-path: <linux-media-owner@vger.kernel.org>
Received: from 59-100-193-174.mel.static-ipl.aapt.com.au ([59.100.193.174]:33129
	"EHLO mail6.intellectit.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbbFCECy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 00:02:54 -0400
Received: from mail6.intellectit.com.au (localhost.localdomain [127.0.0.1])
	by localhost (Email Security Appliance) with SMTP id 338EE43E98_56E7AC9B
	for <linux-media@vger.kernel.org>; Wed,  3 Jun 2015 03:55:53 +0000 (GMT)
Received: from mail.intellectit.com.au (iitmail.intellectit.local [192.168.254.230])
	by mail6.intellectit.com.au (Sophos Email Appliance) with ESMTP id 1A87443E5F_56E7AC9F
	for <linux-media@vger.kernel.org>; Wed,  3 Jun 2015 03:55:53 +0000 (GMT)
From: Stephen Allan <stephena@intellectit.com.au>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Hauppauge WinTV-HVR2205 driver feedback
Date: Wed, 3 Jun 2015 03:55:51 +0000
Message-ID: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am aware that there is some development going on for the saa7164 driver to support the Hauppauge WinTV-HVR2205.  I thought I would post some feedback.  I have recently compiled the driver as at 2015-05-31 using "media build tree".  I am unable to tune a channel.  When running the following w_scan command:

w_scan -a4 -ft -cAU -t 3 -X > /tmp/tzap/channels.conf

I get the following error after scanning the frequency range for Australia.

ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!

At the same time I get the following messages being logged to the Linux console.

dmesg
[165512.436662] si2168 22-0066: unknown chip version Si2168-
[165512.450315] si2157 21-0060: found a 'Silicon Labs Si2157-A30'
[165512.480559] si2157 21-0060: firmware version: 3.0.5
[165517.981155] si2168 22-0064: unknown chip version Si2168-
[165517.994620] si2157 20-0060: found a 'Silicon Labs Si2157-A30'
[165518.024867] si2157 20-0060: firmware version: 3.0.5
[165682.334171] si2168 22-0064: unknown chip version Si2168-
[165730.579085] si2168 22-0064: unknown chip version Si2168-
[165838.420693] si2168 22-0064: unknown chip version Si2168-
[166337.342437] si2168 22-0064: unknown chip version Si2168-
[167305.393572] si2168 22-0064: unknown chip version Si2168-


Many thanks to the developers for all of your hard work.

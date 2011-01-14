Return-path: <mchehab@pedra>
Received: from poutre.nerim.net ([62.4.16.124]:57984 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab1ANNfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 08:35:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id B5D6C39DE43
	for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 14:35:09 +0100 (CET)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id snAy+UpExKHs for <linux-media@vger.kernel.org>;
	Fri, 14 Jan 2011 14:35:08 +0100 (CET)
Received: from mail.logiways-france.fr (mail.logiways.com [194.79.150.130])
	by poutre.nerim.net (Postfix) with ESMTPS id 654B939DE60
	for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 14:35:08 +0100 (CET)
From: Thierry LELEGARD <tlelegard@logiways.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [linux-media] API V3 vs SAPI behavior difference in reading tuning
 parameters
Date: Fri, 14 Jan 2011 13:35:07 +0000
Message-ID: <BA2A2355403563449C28518F517A3C4805AA9B9B@titan.logiways-france.fr>
Content-Language: fr-FR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear all,

I would like to report an annoying behavior difference between S2API and the
legacy DVB API (V3) when _reading_ the current tuning configuration.

In short, API V3 is able to report the _actual_ tuning parameters as used by
the driver and corresponding to the actual broadcast steam. On the other hand,
S2API reports cached values which were specified in the tuning operation and
these values may be generic (*_AUTO symbols) or even wrong.

Logically, it seems that the difference is located in the API and not in the driver.

Here is the configuration I test:

Kernel 2.6.35.10-74.fc14.i686 (Fedora 14)
Hauppauge WinTV-Nova-T-500 (dual DVB-T, DiBcom 3000MC/P)

I tune to a frequency and let many parameters to their *_AUTO value:
  DTV_TRANSMISSION_MODE
  DTV_GUARD_INTERVAL
  DTV_CODE_RATE_HP
  DTV_CODE_RATE_LP

The tuning is performed correctly and reception is effective. The tuner finds
the right parameters.

With API V3, after reading the frontend state (FE_GET_FRONTEND), the returned
values are correct. I can see that actual code rate HP is 3/4, LP 1/2,
transmission mode 8K and guard interval 1/8.

However, on the same machine, after reading the frontend state using S2API
(FE_GET_PROPERTY), all returned values are the *_AUTO values I specified
while tuning.

But there is worse. If I set a wrong parameter in the tuning operation,
for instance guard interval 1/32, the API V3 returns the correct value
which is actually used by the tuner (GUARD_INTERVAL_1_8), while S2API
returns the "cached" value which was set while tuning (GUARD_INTERVAL_1_32).

So, the driver is able 1) to find the correct actual parameter and 2) to
report this actual value since API V3 returns it.

But it seems that API V3 returns the actual tuning parameter as used by the
driver while S2API returns a cached value which was used while tuning.

This seems an annoying regression. An application is no longer able to
determine the modulation parameter of an actual stream.

As a final note, there is no difference if the tuning operation is performed
using API V3 or S2API, the difference is only in the reading operation
(FE_GET_FRONTEND vs. FE_GET_PROPERTY).

Best regards,
-Thierry


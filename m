Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KurId-0003Dh-HS
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 17:20:08 +0100
Received: from joan ([10.44.0.1] helo=kewl.org)
	by joan.kewl.org with esmtp (Exim 4.61)
	(envelope-from <darron@kewl.org>) id 1KurIa-0007AR-6b
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 16:20:04 +0000
To: linux-dvb@linuxtv.org
From: Darron Broad <darron@kewl.org>
Date: Tue, 28 Oct 2008 16:20:04 +0000
Message-ID: <27554.1225210804@kewl.org>
Subject: [linux-dvb] hauppauge DVB-S + ISL6421 + diseqc
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi.

Whilst debugging issues with HVR-4000 users it was found
that during attachment of the ISL6421 part the config
ISL6421_DCL was required for users with diseqc switches.

Since the HVR-4000 has been added at linuxtv attachment
there has also inherited this configuration for 
hauppauge devices.

This was until recently how the hauppauge windows drivers
configured the part. They have since made it a registry option.
This may be due to mishandling of cabling by users.

The ISL6421 datasheet recommends this setting, but only
during the tuning phase whereafter it should be turned off.

During development this was left on, but there would appear
to be a need now to either allow experts to select what
they require else a more dynamic method to alter it.

At present, there is no way to configure this on the fly
as per the spec, so it's either always on (now) or
reverted to always off (before).

I have no proposal for how to go forward with this but
prefer to open the question for debate.

Your comments are appreciated.

Thanks.

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

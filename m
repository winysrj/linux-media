Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kq7Ow-0001LV-EI
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 16:31:04 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8S00KR9AYOQF30@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 15 Oct 2008 10:30:26 -0400 (EDT)
Date: Wed, 15 Oct 2008 10:30:24 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Message-id: <48F5FE80.5010106@linuxtv.org>
MIME-version: 1.0
References: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Revisiting the SNR/Strength issue
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Devin Heitmueller wrote:
> I know that this has been brought up before, but would it be possible
> to revisit the issue with SNR and strength units of measure being
> inconsistent across frontends?
> 
> I know that we don't always know what the units of measure are for
> some frontends, but perhaps we could at least find a way to tell
> applications what the units are for those frontends where it is known?

The SNR units should be standardized into a single metric, something 
actually useful like ESNO or db. If that isn't available then we should 
aim to eyeball / manually calibrate impossible boards against known 
reliable demods on the same feed, it should be close enough.

This requires patience and time from the right people with the right 
hardware.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

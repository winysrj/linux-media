Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jeffd@i2k.com>) id 1Ktvpo-0001Vq-Hr
	for linux-dvb@linuxtv.org; Sun, 26 Oct 2008 03:58:34 +0100
Received: from localhost (localhost [127.0.0.1])
	by blorp.plorb.com (Postfix) with ESMTP id 88C3D2DBB5C
	for <linux-dvb@linuxtv.org>; Sat, 25 Oct 2008 22:58:17 -0400 (EDT)
Received: from blorp.plorb.com ([127.0.0.1])
	by localhost (blorp.plorb.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 5d-fQnRoUHc6 for <linux-dvb@linuxtv.org>;
	Sat, 25 Oct 2008 22:58:17 -0400 (EDT)
Date: Sat, 25 Oct 2008 22:58:17 -0400
From: Jeff DeFouw <jeffd@i2k.com>
To: linux-dvb@linuxtv.org
Message-ID: <20081026025817.GA20130@blorp.plorb.com>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] HVR-1800 S-Video and Audio In
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

I have a Hauppauge WinTV-HVR-1800.  I recently set up a computer with 
Linux kernel 2.6.27 and I'm trying out the analog inputs.  I've also 
used 2.6.24 with drivers from mercurial.  The colors on my S-Video input 
are pulsating and flickering.  Solid reds are most noticeable.  Some of 
the color problems appear to line up in evenly spaced vertical bands.  I 
see similar constant vertical bands if I try to use video sizes other 
than 720x480.  The colors on the Composite input seem to be OK.  I've 
used satellite receiver outputs and laptop video outputs to test.  The 
same S-Video outputs over the same cable to other devices work OK.  I 
used tvtime to view the inputs directly and saw the same thing in the 
MPEG output.

Are the RCA Audio In jacks supposed to work with the MPEG encoder?  I 
get MPEG audio from the analog TV tuner but the composite/S-Video modes 
record only silence.

-- 
Jeff DeFouw <jeffd@i2k.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

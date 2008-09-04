Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kb6s9-0005OK-EP
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 06:55:10 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6N005QEMYX7ZM0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 04 Sep 2008 00:54:34 -0400 (EDT)
Date: Thu, 04 Sep 2008 00:54:33 -0400
From: Steven Toth <stoth@linuxtv.org>
To: linux-dvb <linux-dvb@linuxtv.org>
Message-id: <48BF6A09.3020205@linuxtv.org>
MIME-version: 1.0
Subject: [linux-dvb] S2API - First release
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

Hello,

It's been a crazy few days, please forgive my short absence.

What have I been doing? Well, rather than spending time discussing a new 
S2API on the mailing list, I wanted to actually produce a working series 
of patches that kernel and application developers could begin to test.

Here's where all of the new S2API patches will now appear:

http://linuxtv.org/hg/~stoth/s2

In addition, here's is a userland application that demonstrates tuning 
the current DVB-S/T/C and US ATSC modulations types using the new API. 
(www.steventoth.net/linux/s2/tune-v0.0.1.tgz)

A tuning demo app? What? Obviously, tuning older modulation types via 
the new API isn't a requirements, but it's a useful validation exercise 
for the new S2API. What _IS_ important is..... that it also demonstrates 
using the same tuning mechanism to tune DVB-S2 8PSK / NBC-QPSK 
modulation types, and also has rudimentary ISDB-T support for any 
developers specifically interested.

This S2API tree also contains support for the cx24116 demodulator 
driver, and the Hauppauge HVR4000 family of S2 products. So those 
interested testers/developers can modify the tune.c app demo and make 
changes specific to their area, and try experimenting with the new API 
if they desire. [1]

Obviously, tune.c isn't intelligent, it's not a replacement for szap, 
tzap or whatever - it's simply a standalone S2API test tool, that 
demonstrates the important API interface.

QAM/ATSC are working well, the HVR4000 changes look fine according to 
the debug log (although I have no local satellite feed for testing 
tonight). DVB-T should just work as-is, but I can't test this for a day 
or so. I.E. I've tested what I can in the US but we might have a few 
bugs or gotchas!

If anyone is willing to pull the tree and begin testing with the tune.c 
app then please post all feedback on this thread. [2]

I've received a lot of good feedback of the original 2007 patches. I 
expect to start merging those changes of the coming days. Don't be too 
concerned that your changes are not yet merged, keep watching the S2API 
tree and they will soon appear ... along with a lot of general code 
cleanup (checkpatch violations)

I expect to catchup on my older email tomorrow.

Regards to all,

- Steve
[1] I'll need to review and diff any of the newer HVR4000 driver 
derivatives that people have been using, before merging those changes 
into the S2API tree.
[2] Remember you're going to need the cx24116 firmware if you're 
specifically testing the HVR4000.... but you probably already know that! :)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

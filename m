Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <shaun@saintsi.co.uk>) id 1JsSRd-0002R8-BP
	for linux-dvb@linuxtv.org; Sun, 04 May 2008 02:51:14 +0200
From: Shaun <shaun@saintsi.co.uk>
To: linux-dvb@linuxtv.org
Date: Sun, 4 May 2008 01:50:24 +0100
References: <20080427212607.csw7xwh9wcsw04cw@blacksheep.qnet>
	<20080428001809.3vbl9fotckwwswss@blacksheep.qnet>
	<20080503230321.himip9ragookkcs4@192.168.1.1>
In-Reply-To: <20080503230321.himip9ragookkcs4@192.168.1.1>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805040150.24545.shaun@saintsi.co.uk>
Subject: [linux-dvb]  Using remote causes sound breakup and picture freeze
Reply-To: shaun@saintsi.co.uk
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

Hi,

I am setting up a system for a friend.
It is a mirror of my system but I do not have his problem.

When the remote is used while watching a program, sound breaks up
and picture pauses for a short while.

e.g. Watching live TV, press the remote Up or Down arrow and the picture
will freeze and the sound will break up.

The system:
Distro: Ubuntu 8.04 upgraded from 7.10
DVB: Latest V4L-DVB 2008-05-03
CPU: P4 ~1.7 Ghz
RAM: 512MB RAM
Capture: Nova-T 500
   
He said that the problem was solved on Ubuntu 7.10
with the following:

"I set the dev.rtc.max-user-freq = 64 which has made my remote control operate 
like lightning"

This 'fix' no longer seems to work.

Any help would be appreciated.

Thanks,
Shaun

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

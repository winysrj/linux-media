Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out.google.com ([216.239.33.17])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dcharvey@dsl.pipex.com>) id 1JgiRB-0007RT-Bg
	for linux-dvb@linuxtv.org; Tue, 01 Apr 2008 17:30:18 +0200
Received: from spaceape11.eur.corp.google.com (spaceape11.eur.corp.google.com
	[172.28.16.145]) by smtp-out.google.com with ESMTP id m31FU3fu020490
	for <linux-dvb@linuxtv.org>; Tue, 1 Apr 2008 16:30:03 +0100
Received: from [172.16.22.142] (dhcp-172-16-22-142.lon.corp.google.com
	[172.16.22.142]) (authenticated bits=0)
	by spaceape11.eur.corp.google.com with ESMTP id m31FU3XH017487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Tue, 1 Apr 2008 16:30:03 +0100
Message-ID: <47F254FB.8060204@dsl.pipex.com>
Date: Tue, 01 Apr 2008 16:30:03 +0100
From: David Harvey <dcharvey@dsl.pipex.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] nova-t disconnects
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

Progress is being made.... a ubuntu dev has committed the fix for the 
stock ubuntu 2.6.24 kernel so things should get better again...

Does this usb problem which is being patched indicate to anyone why the 
disconnects still happen at all given how it handles traffic?

------------------------------------------------------------------------

Subject:
[Bug 204857] Re: USB port disabled by hup (EMI? re enabling)
From:
Tim Gardner <tim.gardner@canonical.com>
Date:
Tue, 01 Apr 2008 14:14:28 -0000

To:
dcharvey@dsl.pipex.com


Cherry-picked b5f7a0ec11694e60c99d682549dfaf8a03d7ad97 from Linus' tree.

** Changed in: linux (Ubuntu)
     Assignee: (unassigned) => Tim Gardner (timg-tpi)
       Status: Confirmed => Fix Committed
       Target: later => ubuntu-8.04

-- USB port disabled by hup (EMI? re enabling) 
https://bugs.launchpad.net/bugs/204857 You received this bug 
notification because you are a direct subscriber of the bug.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

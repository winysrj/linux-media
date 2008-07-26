Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.decf.berkeley.edu ([169.229.204.213])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yusikk@gmail.com>) id 1KMhNI-0005dK-C3
	for linux-dvb@linuxtv.org; Sat, 26 Jul 2008 12:51:47 +0200
Received: from [192.168.1.11] (adsl-75-18-193-101.dsl.pltn13.sbcglobal.net
	[75.18.193.101]) (authenticated bits=0)
	by relay.decf.berkeley.edu (8.13.1/8.12.11) with ESMTP id
	m6QAorhT015904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Sat, 26 Jul 2008 03:50:58 -0700
From: Yusik Kim <yusikk@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 26 Jul 2008 03:53:23 -0700
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807260353.23359.yusikk@gmail.com>
Subject: [linux-dvb] Hauppauge HVR-1950 digital part
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

Has anyone got the digital part of this device to work properly? 

Modules are compiled from the latest (7/26) v4l-dvb snapshot with a 2.6.25.4 
kernel. The modules seem to load properly and the analog part works in 
mythtv. The digital part kind of works.
The problems I can observe are:
1. Can only scan 3 digital channels using both the command line scan and 
mythtv. My other PCI TV card scans 36 of them. 
2. Only occasionally locks in to a channel.
3. Takes 5 minutes to lock in to a channel when it actually does succeed.

I saw from another mailing list that people were trying to get the remote 
control to work so I'm guessing the core of the device functions properly. If 
this is the current state of support, I'd be glad to help testing.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

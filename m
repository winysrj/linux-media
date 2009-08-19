Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw.Deuromedia.ro ([194.176.161.33]:45013 "HELO deuromedia.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752252AbZHSOPi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 10:15:38 -0400
Message-ID: <4A8C076C.8040109@deuromedia.com>
Date: Wed, 19 Aug 2009 17:08:44 +0300
From: Helmut Ungar <h.ungar@deuromedia.com>
Reply-To: h.ungar@deuromedia.com
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Manfred Petz <m.petz@deuromedia.com>,
	Gerhard Achs <g.achs@deuromedia.com>
Subject: V4L-DVB issue in systems with >4Gb RAM?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

we are experiencing a problem with the V4L-DVB drivers.
It seems that when the system has over 4Gb the drivers
do no longer work properly. Either nothing or rubbish 
comes out of them, although tuning using szap seems to
work. If we force the system to use only 4Gb by appending
mem=4GB as a kernel parameter things are working like a
charm.

Our setup:
Dell 2850 server with a Magma PCI extender. There are 6 
DVB boards in the machine: 5 KNC TV STAR DVB-S and 
1 Hauppauge Nova-S-Plus DVB-S.
The system has 8GB of RAM and runs an up-to-date Centos5.3, 
kernel 2.6.18-128.4.1.el5 x86_64. 
The V4L-DVB driver we are using is v4l-dvb-2009.08.18.tar.bz2
On this setup some of the KNC boards are working, the Hauppauge
does not. In a similar setup where we have only KNCs none
of them is working unless you force the system to use 4Gb of 
the available memory.

I would like to know if this is a known issue and if so
what can be done to fix/work around the problem.

Any help/suggestion/hint is highly welcome.
Thanks in advance! 

Kind regards,
Helmut


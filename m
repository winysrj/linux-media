Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.pyx.ch ([212.55.210.221] helo=dmz.pyx.ch)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joe@pyx.ch>) id 1JpAOW-0006GS-Ck
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 00:58:25 +0200
Received: from [192.168.5.194] (77-57-215-40.dclient.hispeed.ch [77.57.215.40])
	(authenticated bits=0)
	by dmz.pyx.ch (PYX) with ESMTP id m3OMvoih016903
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Fri, 25 Apr 2008 00:57:50 +0200
From: Joe Ammann <joe@pyx.ch>
To: linux-dvb@linuxtv.org
Date: Fri, 25 Apr 2008 00:56:54 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804250056.55050.joe@pyx.ch>
Subject: [linux-dvb] Problems with Hauppauge HVR 900 (B3C0) hybrid USB
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

Hi everybody

I'm trying to get this device (USB 2040:6502) going. I understand that this 
version will probably not give me DVB (only an older release would be 
supported). But at the moment, I can't get anything to work, not even 
analogue or the remote control.

Currently, I'm trying on Fedora 8 with a vanilla 2.6.24.5 kernel and the 
drivers from http://linuxtv.org/hg/v4l-dvb. I also tried with the FC8 stock 
kernel, 2.6.25, the drivers from mcentral.de, and even the userspace drivers 
from Markus Rechberger, following various howto's and instructions.

For most combinations, I can achieve the following:
- analogue device is recognized and configured (according to
  dmesg, firmware is loaded, /dev/video0 appears)
- can't tune anything (with kdetv, device and cable are probably ok, because
  it works in Windows)
- IR remote is not recognized (nothing shows up in /proc/bus/input/devices)

With the userspace drivers from mcentral.de on 2.6.25, I got analogue and DVB 
recognized and devices installed, but again couldn't tune anything (with 
kdetv and klear).

Before I try to investigate deeper, I thought I'd ask again if my expectations 
are right ?!? I *should* be able to get analogue and IR remote working, 
shouldn't I?

I'd be thankful for any hints, pointing me to the most promising 
combination :-) , and willing to post logs and stuff.

CU, Joe

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

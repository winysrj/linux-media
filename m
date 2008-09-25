Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 108.203.233.220.exetel.com.au ([220.233.203.108]
	helo=hack.id.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christian@hack.id.au>) id 1KigXV-00089F-2B
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 04:25:10 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by hack.id.au (Postfix) with ESMTP id 7F56921036D
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 12:24:28 +1000 (EST)
Received: from hack.id.au ([127.0.0.1])
	by localhost (shonky.hack.id.au [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6SCbadDlC69h for <linux-dvb@linuxtv.org>;
	Thu, 25 Sep 2008 12:24:24 +1000 (EST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by hack.id.au (Postfix) with ESMTP id D7FA8210DBE
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 12:24:23 +1000 (EST)
Received: from CHLAPTOP (unknown [192.168.99.157])
	by hack.id.au (Postfix) with ESMTP id 3D9FE21036D
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 12:24:23 +1000 (EST)
From: "Christian Hack" <christian@hack.id.au>
To: <linux-dvb@linuxtv.org>
Date: Thu, 25 Sep 2008 12:24:16 +1000
Message-ID: <86B90129E3F44E76B299168B04C98B36@CHLAPTOP>
MIME-Version: 1.0
In-Reply-To: <019c01c8bbb7$731d79e0$1c01010a@edmi.local>
Subject: Re: [linux-dvb] LifeView TV Walker Twin DVB-T (LR540) Problem
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

> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org 
> [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Christian Hack
> Sent: Thursday, 22 May 2008 12:57 PM
> To: 'Nick Andrew'
> Cc: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] LifeView TV Walker Twin DVB-T (LR540) Problem
> 
> > -----Original Message-----
> > From: Nick Andrew [mailto:nick-linuxtv@nick-andrew.net] 
> > Sent: Wednesday, 21 May 2008 11:26 PM
> > 
> > On Mon, May 19, 2008 at 07:00:27PM +1000, Christian Hack wrote:
> > > Hi guys,
> > > > I can't get any extra info with debug=1. I have tried in both
> /etc/modprobe.conf and by specifying it on the command line 
> i.e. "modprobe
> dvb_usb_m920x debug=1" etc. I am removing dvb_usb tda827x and 
> dvb_usb_m920x
> modules before trying each time.
> 
> Tzap output (first go is the LR540, second is the Hauppage 
> Nova-T) using the
> same aerial:
> 
> [root@mythtv tmp]# tzap -c channels.conf -a 2 -f 0 -d 0 "Ten HD"
> using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
> tuning to 219500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal b8b8 | snr c8c8 | ber 0001fffe | unc 00000000 | 
> status 00 | signal b8b8 | snr d5d5 | ber 0001fffe | unc 00000000 | 
> status 00 | signal b7b7 | snr d3d3 | ber 0001fffe | unc 00000000 | 
> status 00 | signal b7b7 | snr d4d4 | ber 0001fffe | unc 00000000 | 
> 
After some playing when this original occurred, it started to work just fine
and continued working fine (even over reboots etc). So I left it for a while

The other day it started to play up again. Since I have some time I invested
more time in debugging the problem. This is what I'm seeing in the debug
log. I had to modify rsyslog's config to get this. This is interspersed with
the output from tzap:

[root@mythtv ~]# tzap -c channels.conf -a 2 -f 0 -d 0 "Ten HD"
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
Sep 25 12:20:58 mythtv kernel: power control: 1
Sep 25 12:20:58 mythtv kernel: tda1004x: setting up plls for 48MHz sampling
clock
tuning to 585625000 Hz
video pid 0x00a1, audio pid 0x0051
Sep 25 12:21:00 mythtv kernel: tda1004x: found firmware revision 29 -- ok
Sep 25 12:21:00 mythtv kernel: tda827x: tda827x_init:
Sep 25 12:21:00 mythtv kernel: tda827x: tda827xa_set_params:
Sep 25 12:21:00 mythtv kernel: tda827x: tda827x_config not defined, cannot
set LNA gain!
Sep 25 12:21:00 mythtv kernel: tda827x: tda8275a AGC2 gain is: 0
Sep 25 12:21:00 mythtv kernel: tda827x: tda827x_config not defined, cannot
set LNA gain!
status 00 | signal a2a2 | snr c2c2 | ber 0001fffe | unc 00000000 | 
Sep 25 12:21:02 mythtv kernel: tda827x: tda827xa_set_params:
Sep 25 12:21:02 mythtv kernel: tda827x: tda827x_config not defined, cannot
set LNA gain!
Sep 25 12:21:02 mythtv kernel: tda827x: tda8275a AGC2 gain is: 0
Sep 25 12:21:02 mythtv kernel: tda827x: tda827x_config not defined, cannot
set LNA gain!
status 00 | signal a1a1 | snr d4d4 | ber 0001fffe | unc 00000000 | 
Sep 25 12:21:03 mythtv kernel: tda827x: tda827xa_set_params:
Sep 25 12:21:03 mythtv kernel: tda827x: tda827x_config not defined, cannot
set LNA gain!
Sep 25 12:21:03 mythtv kernel: tda827x: tda8275a AGC2 gain is: 0
Sep 25 12:21:03 mythtv kernel: tda827x: tda827x_config not defined, cannot
set LNA gain!
Sep 25 12:21:05 mythtv kernel: tda827x: tda827xa_set_params:
Sep 25 12:21:05 mythtv kernel: tda827x: tda827x_config not defined, cannot
set LNA gain!
status 00 | signal a1a1 | snr d6d6 | ber 0001fffe | unc 00000000 | 

This lines up with what I'm seeing i.e. it can't seem to tune correctly.
Tda827x doesn't seem to have any configuration options. Suggestions?
Remember this system did work previously.

CH


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

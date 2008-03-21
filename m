Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.ks.pochta.ru ([82.204.219.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aie@mail333.com>) id 1Jca9f-00054Y-8e
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 06:51:05 +0100
Received: from [82.162.56.29] (helo=[192.168.1.2])
	by mail1.ks.pochta.ru ( sendmail 8.13.3/8.13.1) with esmtpa id
	1Jca7f-0006Qd-Gp
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 08:48:59 +0300
From: Igor Alexeiuk <aie@mail333.com>
To: linux-dvb@linuxtv.org
Date: Fri, 21 Mar 2008 15:49:51 +1000
Message-Id: <1206078591.12241.28.camel@localhost>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental
	/	Avermedia A16D please?
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
> On Fri, 21 Mar 2008, timf wrote:
> 
> > [   51.446308] xc2028 2-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> 
> Ok, xc3028 loaded the firmware. This means that reset GPIO's are correct.
> 
> > Info:	- have /dev/video0
> > 	- tvtime - no signal
> > 	- have soundcard
> 
> There are some possibilities:
> 
> 1) This board doesn't work with firmware version 2.7;
> 
> 2) GPIO's are wrong;
> 
> 3) vmux value is wrong.
> 
> I guess the issue is with the firmware version. Probably, it will need an 
> earlier version.

In addition to Tim's info/report:

While my dmesg looks similar to what Tim posted here
, there is more ( perhaps useful ) messages:
     
1) On try to tune analog radio it looks like this:

xc2028 0-0061: load_firmware called
xc2028 0-0061: seek_firmware called, want type=BASE FM (401), id 0000000000000000.
xc2028 0-0061: Found firmware for type=BASE FM (401), id 0000000000000000.
xc2028 0-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
xc2028 0-0061: i2c output error: rc = -5 (should be 64)
xc2028 0-0061: -5 returned from send
xc2028 0-0061: Error -22 while loading base firmware


2) on try to tune analog tv :

xc2028 0-0061: check_firmware called
xc2028 0-0061: checking firmware, user requested type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
xc2028 0-0061: load_firmware called
xc2028 0-0061: seek_firmware called, want type=BASE F8MHZ MTS (7), id 0000000000000000.
xc2028 0-0061: Found firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
xc2028 0-0061: i2c output error: rc = -5 (should be 64)
xc2028 0-0061: -5 returned from send
xc2028 0-0061: Error -22 while loading base firmware


BTW: I tried firmware v25 - unfortunately it failed with this:
 
xc2028 0-0061: Reading firmware xc3028-v25.fw
xc2028 0-0061: Loading 60 firmware images from xc3028-v25.fw, type: xc2028 firmware, ver 2.5
xc2028 0-0061: Reading firmware type BASE F8MHZ (3), id 0, size=6621.
xc2028 0-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=6617.
xc2028 0-0061: Reading firmware type BASE FM (401), id 0, size=6517.
xc2028 0-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=6531.
xc2028 0-0061: Reading firmware type BASE (1), id 0, size=6611.
xc2028 0-0061: Reading firmware type BASE MTS (5), id 0, size=6595.
xc2028 0-0061: Reading firmware type (0), id 100000007, size=161.
xc2028 0-0061: Firmware type INIT1 F8MHZ D2620 DTV7 (408a), id 2012d00022000 is corrupted (size=10946, expected 786712)
xc2028 0-0061: Error: firmware file is corrupted!
xc2028 0-0061: Releasing partially loaded firmware file.


Any suggestions ?

Igor.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

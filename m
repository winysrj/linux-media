Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f124.mail.ru ([194.67.57.246])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JSpgn-0000Ps-Ig
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 09:24:57 +0100
From: Igor <goga777@bk.ru>
To: ga ver <gavermer@gmail.com>
Mime-Version: 1.0
Date: Sat, 23 Feb 2008 11:24:23 +0300
References: <468e5d620802220813q4b39c4ecpb9297db74884547d@mail.gmail.com>
In-Reply-To: <468e5d620802220813q4b39c4ecpb9297db74884547d@mail.gmail.com>
Message-Id: <E1JSpgF-0003HY-00.goga777-bk-ru@f124.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SFZSIDQwMDAgZmlybXdhcmUgbm90IGxvYWRlZD8=?=
Reply-To: Igor <goga777@bk.ru>
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

I'm supposing that dvbsnoop doesn'r support multiproto's API (api version 3.3).
If you really want to use the dvbsnoop with hvr4000 please look at the 
http://dev.kewl.org/hauppauge/

btw 20 February Darron Broad was updated the hvr4000 patches for current HG

Igor

-----Original Message-----
From: "ga ver" <gavermer@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 22 Feb 2008 17:13:52 +0100
Subject: [linux-dvb] HVR 4000 firmware not loaded?

> 
> Hello
> 
> In Ubuntu 7.10 with kernel 2.6.22-14.47 I installed a Hauppauge HVR 4000.
> From http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
> I made a driver update and a firmware update.
> In dmesg the card is recognized.
> In dvbsnoop are the current parameters not found
> 
>  dvbsnoop -s feinfo -pd 9
> dvbsnoop V1.4.00 -- http://dvbsnoop.sourceforge.net/
>    DEMUX : /dev/dvb/adapter0/demux0
>    DVR   : /dev/dvb/adapter0/dvr0
>    FRONTEND: /dev/dvb/adapter0/frontend0
> 
> ---------------------------------------------------------
> FrontEnd Info...
> ---------------------------------------------------------
> 
> Device: /dev/dvb/adapter0/frontend0
> 
> Basic capabilities:
>     Name: "Conexant CX24116/CX24118"
>     Frontend-type:       QPSK (DVB-S)
>     Frequency (min):     950.000 MHz
>     Frequency (max):     2150.000 MHz
>     Frequency stepsiz:   1.011 MHz
>     Frequency tolerance: 5000
>     Symbol rate (min):     1.000000 MSym/s
>     Symbol rate (max):     45.000000 MSym/s
>     Symbol rate tolerance: 0 ppm
>     Notifier delay: 0 ms
>     Frontend capabilities:
>         auto inversion
>         FEC 1/2
>         FEC 2/3
>         FEC 3/4
>         FEC 4/5
>         FEC 5/6
>         FEC 6/7
>         FEC 7/8
>         FEC AUTO
>         QPSK
> 
> Current parameters:
> Error(95): frontend ioctl: Operation not supported
> 
> following dmesg is the firmware not loaded
> 
> Is the update procedure from
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
> correct?
> 
> Thanks in advance
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

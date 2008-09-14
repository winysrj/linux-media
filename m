Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1KepZR-0003Qq-So
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 13:15:16 +0200
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.13.3/8.13.3) with ESMTP id m8EBF9og001248
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 13:15:09 +0200
Message-ID: <48CCF23D.5050209@cadsoft.de>
Date: Sun, 14 Sep 2008 13:15:09 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <630160.40997.qm@web46116.mail.sp1.yahoo.com>
	<48CAE273.4030809@gmail.com>
In-Reply-To: <48CAE273.4030809@gmail.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On 09/12/08 23:43, Manu Abraham wrote:
> barry bouwsma wrote:
> ...
>> Now a completely different question -- I was pleased to see
>> that my not-too-old kernel compiled well with your mp_plus
>> source, and I read on the Wiki that certain basic tools
>> still needed to be ported to multiproto.
> 
> 
> Please use the multiproto tree rather than the multiproto_plus tree.

I tried the multiproto version 855d0c878944, but it didn't work on
my system. My VDR doesn't recognize my DVB-T card and hangs upon startup.
When I try to unload the driver modules, the 'rmmod budget_core' appears
to hang. If I kill that, a subsequent 'lsmod' also hangs, so I need to do
a reboot - which also hangs, so a hard reset is the last resort.

Then I tried the latest multiproto_plus version adf34f76ab7c, with which
VDR's startup sequence results in

Sep 14 13:06:59 video vdr: [3309] probing /dev/dvb/adapter0/frontend0
Sep 14 13:06:59 video vdr: [3313] CI adapter on device 0 thread started (pid=3309, tid=3313)
Sep 14 13:06:59 video vdr: [3309] ERROR (dvbdevice.c,471): Operation not supported
Sep 14 13:06:59 video vdr: [3314] section handler thread started (pid=3309, tid=3314)
Sep 14 13:06:59 video vdr: [3309] probing /dev/dvb/adapter1/frontend0
Sep 14 13:06:59 video vdr: [3316] CI adapter on device 1 thread started (pid=3309, tid=3316)
Sep 14 13:06:59 video vdr: [3309] ERROR (dvbdevice.c,471): Operation not supported
Sep 14 13:06:59 video vdr: [3317] section handler thread started (pid=3309, tid=3317)
Sep 14 13:06:59 video vdr: [3309] probing /dev/dvb/adapter2/frontend0
Sep 14 13:06:59 video vdr: [3309] ERROR (dvbdevice.c,471): Operation not supported
Sep 14 13:06:59 video vdr: [3319] section handler thread started (pid=3309, tid=3319)
Sep 14 13:06:59 video vdr: [3309] probing /dev/dvb/adapter3/frontend0
Sep 14 13:06:59 video vdr: [3309] ERROR (dvbdevice.c,471): Operation not supported
Sep 14 13:06:59 video vdr: [3321] section handler thread started (pid=3309, tid=3321)

This is the DVBFE_GET_DELSYS call that apparently fails.

Using the multiproto_plus version 88821ce4ed8d (2008-04-13) works fine.
So I'm still using that one for now.

Have there been any API changes since multiproto_plus version 88821ce4ed8d
that I would need to take into account in VDR?

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Kex4N-0006Sh-CV
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 21:15:40 +0200
Message-ID: <48CD62D2.9050200@gmail.com>
Date: Sun, 14 Sep 2008 23:15:30 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
References: <630160.40997.qm@web46116.mail.sp1.yahoo.com>	<48CAE273.4030809@gmail.com>
	<48CCF23D.5050209@cadsoft.de>
In-Reply-To: <48CCF23D.5050209@cadsoft.de>
Cc: linux-dvb@linuxtv.org
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

Klaus Schmidinger wrote:
> On 09/12/08 23:43, Manu Abraham wrote:
>> barry bouwsma wrote:
>> ...
>>> Now a completely different question -- I was pleased to see
>>> that my not-too-old kernel compiled well with your mp_plus
>>> source, and I read on the Wiki that certain basic tools
>>> still needed to be ported to multiproto.
>>
>> Please use the multiproto tree rather than the multiproto_plus tree.
> 
> I tried the multiproto version 855d0c878944, but it didn't work on
> my system. My VDR doesn't recognize my DVB-T card and hangs upon startup.
> When I try to unload the driver modules, the 'rmmod budget_core' appears
> to hang. If I kill that, a subsequent 'lsmod' also hangs, so I need to do
> a reboot - which also hangs, so a hard reset is the last resort.
> 
> Then I tried the latest multiproto_plus version adf34f76ab7c, with which
> VDR's startup sequence results in
> 
> Sep 14 13:06:59 video vdr: [3309] probing /dev/dvb/adapter0/frontend0
> Sep 14 13:06:59 video vdr: [3313] CI adapter on device 0 thread started (pid=3309, tid=3313)
> Sep 14 13:06:59 video vdr: [3309] ERROR (dvbdevice.c,471): Operation not supported
> Sep 14 13:06:59 video vdr: [3314] section handler thread started (pid=3309, tid=3314)
> Sep 14 13:06:59 video vdr: [3309] probing /dev/dvb/adapter1/frontend0
> Sep 14 13:06:59 video vdr: [3316] CI adapter on device 1 thread started (pid=3309, tid=3316)
> Sep 14 13:06:59 video vdr: [3309] ERROR (dvbdevice.c,471): Operation not supported
> Sep 14 13:06:59 video vdr: [3317] section handler thread started (pid=3309, tid=3317)
> Sep 14 13:06:59 video vdr: [3309] probing /dev/dvb/adapter2/frontend0
> Sep 14 13:06:59 video vdr: [3309] ERROR (dvbdevice.c,471): Operation not supported
> Sep 14 13:06:59 video vdr: [3319] section handler thread started (pid=3309, tid=3319)
> Sep 14 13:06:59 video vdr: [3309] probing /dev/dvb/adapter3/frontend0
> Sep 14 13:06:59 video vdr: [3309] ERROR (dvbdevice.c,471): Operation not supported
> Sep 14 13:06:59 video vdr: [3321] section handler thread started (pid=3309, tid=3321)
> 
> This is the DVBFE_GET_DELSYS call that apparently fails.
> 
> Using the multiproto_plus version 88821ce4ed8d (2008-04-13) works fine.
> So I'm still using that one for now.
> 
> Have there been any API changes since multiproto_plus version 88821ce4ed8d
> that I would need to take into account in VDR?

There hasn't been any further API changes after that changeset.

The only other change (to dvb-core) is a backward compatibility add on
from Anssi Hannula, but that change i haven't ported yet to the
multiproto_plus tree.

Maybe something came up, while merging the two trees .. ?

Let me see what i can dig through.

Thanks for looking it up.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

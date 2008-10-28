Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qb-out-0506.google.com ([72.14.204.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oroitburd@gmail.com>) id 1KukrA-0007th-VT
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 10:27:21 +0100
Received: by qb-out-0506.google.com with SMTP id e11so2051239qbe.25
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 02:27:17 -0700 (PDT)
Message-ID: <b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
Date: Tue, 28 Oct 2008 10:27:16 +0100
From: "oleg roitburd" <oroitburd@gmail.com>
To: "Alex Betis" <alex.betis@gmail.com>
In-Reply-To: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
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

2008/10/25 Alex Betis <alex.betis@gmail.com>:
> Hello all,
>
> I've setup the http://mercurial.intuxication.org/hg/scan-s2/ repository with
> scan utility ported to work with Igor's S2API driver.
> Driver is available here: http://mercurial.intuxication.org/hg/s2-liplianin/
>
> Special thanks to Igor for his driver and for szap-s2 utility that I've used
> as a reference for scan-s2.
> Thanks also to someone from the net that posted his changes to scan utility
> that allowed it to work with uncommitted diseqc.
>
> Pay attention to parameters (see README as well), I've added some and
> removed some that I don't think are needed.
>
> Scan results gave me the same channels as with multiproto driver on all my
> satellites, so that confirms also that Igor's driver is working well.
>
> I didn't yet tested the output files with szap-s2 or with VDR, don't have
> time right now.
> Please test and let me know if changes are needed.
>
> I have only Twinhan 1041 card (stb0899), so I can't test it with DVB-T,
> DVB-C and ATSC standarts, but theoretically it should work.
>
> Enjoy,
> Alex.

Thank you for this usefull tool. I have tried them with TT S2-3200.
It works with s2-liplianin.
Some question
Is it possible to implement in vdr-dump
1. Options for Modulation (MN where N=2  is QPSK if DVB-S and N=2 for
QPSK and N=5 for 8PSK)
2. Options for FEC. As I know cx24116 can't FEC AUTO for DVB-S2
3. ROLLOFF?
4. CAID dump.  http://arvdr-dev.free-x.de:8080/freex-dvb-apps/rev/47e9dbb968fc
5. Channel Name encoding to UTF.
http://arvdr-dev.free-x.de:8080/freex-dvb-apps/rev/55bf7441a602

Thx a lot
Oleg Roitburd

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

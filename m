Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1KF9Mu-0001zC-8U
	for linux-dvb@linuxtv.org; Sat, 05 Jul 2008 17:08:09 +0200
Received: by fg-out-1718.google.com with SMTP id e21so596077fga.25
	for <linux-dvb@linuxtv.org>; Sat, 05 Jul 2008 08:08:03 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 5 Jul 2008 17:08:00 +0200
References: <486C6ED4.4080502@krt.com.au>
In-Reply-To: <486C6ED4.4080502@krt.com.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807051708.01041.christophpfister@gmail.com>
Subject: Re: [linux-dvb] DVB-T Channel configuration for Switzerland / Basel
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

Am Donnerstag 03 Juli 2008 08:16:52 schrieb Kingsley Turner:
> Hi,
>
> I've got some DVB-T channel "channel.conf" data for Europe / Basel
> (Switzerland).
>
> Do I just post it to this list, or how to I get it incorporated into the
> repository.

There's already a scan file including your transmitter [1].

> cheers,
> -kt

Christoph


> sf1:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_NONE:QAM_16:TRANSM
>ISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_4:160:81:81
> sfzwei:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_NONE:QAM_16:TRA
>NSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_4:163:92:93
> tsr1:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_NONE:QAM_16:TRANS
>MISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_4:161:84:85
> tsi1:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_NONE:QAM_16:TRANS
>MISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_4:162:88:89

^ srg ssr says that the fec is 5/6 (except maybe in the mfn areas).

[1] http://linuxtv.org/hg/dvb-apps/file/73b910014d07/util/scan/dvb-t/ch-All

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

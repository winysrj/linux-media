Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KO61m-0004hv-LM
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 09:23:19 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt2.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 488FA13900002328 for linux-dvb@linuxtv.org;
	Wed, 30 Jul 2008 09:23:15 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Wed, 30 Jul 2008 09:23:47 +0200
References: <f3ebb34d0807290258i68f62f57w451a9741ad362b0d@mail.gmail.com>
	<488F40A0.8080201@anevia.com>
	<f29eff0e0807292203r61dde4cdh841e3326ca84202f@mail.gmail.com>
In-Reply-To: <f29eff0e0807292203r61dde4cdh841e3326ca84202f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807300923.47440.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] How to record whole TS?
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

On Wednesday 30 July 2008 07:03:33 vijet m wrote:
> Hi,
>
> Sorry to interrupt your discussion but I have a question regarding
> recording of MPEG2 streams.
> As Kurt said, if you set pesfilter with output as DMX_OUT_TS_TAP
> and pass the pid, it will record the streams corresponding
> to that pid. So, if I pass audio and video pid, then it will record
> only the audio and video streams.
> I wanted to know how to record the DVB SI/PSI tables corresponding
> to the streams I'm recording.
> Do I have to pass the pids of the tables I want to record or is
> there some other way?
> Right now, I'm using the pid value 0x2000 for setting pes filter
> which is proving to be computationally intensive and consuming lot
> of CPU. Please help.
>
> Thanks in advance,
>        Vijet M

using dvbstream from the CVS repository in dvbtools.sf.net:
$ dvbstream -prog -f .... -o:dump.ts "Program name"

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

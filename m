Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <4890242A.20801@anevia.com>
Date: Wed, 30 Jul 2008 10:19:54 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: vijet m <coolvijet@gmail.com>
References: <f3ebb34d0807290258i68f62f57w451a9741ad362b0d@mail.gmail.com>	
	<488EEA80.4060908@anevia.com>	
	<f3ebb34d0807290420l6c943e15jc1e27878963a7206@mail.gmail.com>	
	<488F3E32.1010102@anevia.com> <488F3F0B.3000209@linuxtv.org>	
	<488F40A0.8080201@anevia.com>
	<f29eff0e0807292203r61dde4cdh841e3326ca84202f@mail.gmail.com>
In-Reply-To: <f29eff0e0807292203r61dde4cdh841e3326ca84202f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, Marcel Siegert <mws@linuxtv.org>
Subject: Re: [linux-dvb] How to record whole TS?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

vijet m a =E9crit :
> Hi,
> =

> Sorry to interrupt your discussion but I have a question regarding =

> recording of MPEG2 streams.
> As Kurt said, if you set pesfilter with output as DMX_OUT_TS_TAP and =

> pass the pid, it will record the streams corresponding
> to that pid. So, if I pass audio and video pid, then it will record only =

> the audio and video streams.
> I wanted to know how to record the DVB SI/PSI tables corresponding to =

> the streams I'm recording.
> Do I have to pass the pids of the tables I want to record or is there =

> some other way?
> Right now, I'm using the pid value 0x2000 for setting pes filter which =

> is proving to be computationally intensive and consuming lot of CPU.
> Please help.
> =

> Thanks in advance,
>        Vijet M
> =


Good way to do is set pid 0, analyse the PAT, grab the PMT PID of the =

service you're interested in, add it to the demux, then parse the PMT, =

grabe the ES PIDs you're interested in, and add it to the demux.

With this you'll be able tou watch the video and hear the audio. If you =

need more tables you should read iso-13818-1, and en 300 438

Cheers


-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

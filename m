Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KYP9c-0008Rq-BM
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 19:50:01 +0200
Date: Wed, 27 Aug 2008 19:49:27 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20080827125601.62260@gmx.net>
Message-ID: <20080827174927.271630@gmx.net>
MIME-Version: 1.0
References: <200808252156.52323.ajurik@quick.cz>
	<E1KXq2s-0007z3-00.goga777-bk-ru@f25.mail.ru>	<1219735725.3886.6.camel@HTPC>
	<20080826201530.47fd3bb7@bk.ru> <20080827125601.62260@gmx.net>
To: linux-dvb@linuxtv.org, goga777@bk.ru
Subject: Re: [linux-dvb] HVR 4000 recomneded driver and firmware for
	VDR	1.7.0
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


> Goga,
> as you can see in your own log above, szap2 does not correctly parse the
> APID and SID from =

> your channels.conf file. This does matter if you want to use the szap2 -p
> option [add pat and pmt
> to TS recording (which also implies the -r option)]. get_pmt_pid does not
> get the correct
> value.
> =

> The following channels.conf.fixed works better (format VPID:APID:SID) ,
> but perhaps it would
> be best to fix the parsing in szap2 instead.
> =

> ANIXE HD:11914:hC910M2O35S1:S19.2E:27500:1535:1539:132:133:6:0
> arte HD:11361:hC23M5O0S1:S19.2E:22000:6210:6221:11120:1:1011:0
> ASTRA HD+:11914:hC910M2O35S1:S19.2E:27500:1279:1283:131:133:6:0
> =

> $ szap2 -c ~/channels.conf.fixed -H -p -n3
> =

> reading channels from file '/home/hans/channels.conf.fixed'
> zapping to 3 'ASTRA HD+':
> delivery DVB-S2, modulation QPSK
> sat 0, frequency 11914 MHz H, symbolrate 27500000, coderate 9/10, rolloff
> 0.35
> vpid 0x04ff, apid 0x0503, sid 0x0083
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ** get_pmt_pid returned : 100
> status 1f | signal  77% | snr  50% | ber 0 | unc 0 | FE_HAS_LOCK
> status 1f | signal  77% | snr  50% | ber 0 | unc 0 | FE_HAS_LOCK
> ...
> =

> then watch the channel with:
> $ mplayer - < /dev/dvb/adapter0/dvr0
> =


There still seems to be a problem though. All three FTA HD channels lock, b=
ut only Arte HD plays properly in mplayer.  Mplayer crashes after less than=
 a second for Anixe HD and Astra HD+ :

Playing testfile_anixe.ts.
TS file format detected.
VIDEO H264(pid=3D1535) AUDIO A52(pid=3D1539) NO SUBS (yet)!  PROGRAM N. 132
FPS seems to be: 25.000000
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Selected video codec: [ffh264] vfm: ffmpeg (FFmpeg H.264)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Opening audio decoder: [liba52] AC3 decoding with liba52
Using SSE optimized IMDCT transform
Using MMX optimized resampler
AUDIO: 48000 Hz, 2 ch, s16le, 448.0 kbit/29.17% (ratio: 56000->192000)
Selected audio codec: [a52] afm: liba52 (AC3-liba52)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[AO OSS] audio_setup: Can't open audio device /dev/dsp: Device or resource =
busy
AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)
Starting playback...
[h264 @ 0xbc0b40]number of reference frames exceeds max (probably corrupt i=
nput), discarding one
[h264 @ 0xbc0b40]number of reference frames exceeds max (probably corrupt i=
nput), discarding one
[h264 @ 0xbc0b40]number of reference frames exceeds max (probably corrupt i=
nput), discarding one
[h264 @ 0xbc0b40]number of reference frames exceeds max (probably corrupt i=
nput), discarding one


Does anyone know what is wrong? Audio only sounds fine.

Hans
-- =

Release early, release often.

Psssst! Schon das coole Video vom GMX MultiMessenger gesehen?
Der Eine f=FCr Alle: http://www.gmx.net/de/go/messenger03

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

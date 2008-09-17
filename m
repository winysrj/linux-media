Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KfvP5-0005SF-TE
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 13:41:05 +0200
Received: by wx-out-0506.google.com with SMTP id t16so1259995wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 17 Sep 2008 04:40:58 -0700 (PDT)
Message-ID: <d9def9db0809170440g7ed779f9m9331ff9eddb78745@mail.gmail.com>
Date: Wed, 17 Sep 2008 13:40:58 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "BOUWSMA Barry" <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0809171253300.5927@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
References: <786613.55940.qm@web55106.mail.re4.yahoo.com>
	<alpine.DEB.1.10.0809171253300.5927@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] software radio
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

On Wed, Sep 17, 2008 at 1:20 PM, BOUWSMA Barry
<freebeer.bouwsma@gmail.com> wrote:
> On Wed, 17 Sep 2008, alireza ghahremanian wrote:
>
>> Is it possible to access the sampling subsystem of a dvb card
>> as like skystar 2 or any other ?
>
> I'm not sure I understand your question.
>
> The way a SkyStar 2 card works can be described, in the case
> of radio -- assuming the same radio which I tune with it is
> that which you want to demodulate -- is sort of like this...
>
> Baseband analogue audio is sampled at 48kHz, 16bit, and then
> compressed into a stream, usually MPEG 1/2 Layer II, but
> sometimes Dolby AC3 or similar.  From this, an ES (Elementary
> Stream) is created.
>
> This Elementary Stream is then multiplexed into an MPEG
> Transport Stream with other services.
>
> The resulting datastream is then modulated onto a RF carrier,
> using something like QPSK or whatever is appropriate to the
> delivery system, sent to a satellite (SkyStar) and effectively
> bounced back.  Error correction and whatnot is added at this
> point.
>
> Your hardware tunes into the RF signal, and itself demodulates
> the QPSK modulation and recovers the Transport Stream, or at
> least part of it.
>
> The Linux-DVB API gives you access to this demodulated signal.
>
> Then, an application can work with this TS, extract the payload
> from it (the Layer II or equivalent audio), and decode that into
> a PCM stream.
>
> OF course, I could be wrong...
>
>
>> I want to make a software radio and i want to do demodulation
>> and decoding in software?
>
> The demodulation is performed by the hardware in your SkyStar
> card.
>
> The demultiplexing and decoding are already handled either by
> all-in-one programs, or you could chain together building-block
> tools that already exist, in order to listen to radio...
>
> I use separate, existing utilities to control the frontend (tune
> to a transponder); I'm delivered some part of a transport stream
> which I can either play, with, for example, `mplayer', or I can
> hand it to `ts_es_audio_demux' (if that's not part of the DVB
> libdvb package, then it's a hack based on the existing routines
> to extract ESen from a TS in that package); that's either an mp2
> or ac3 stream which I can pass directly to, for example, `mpg123'
> or in a slightly different fashion, to `ac3dec'
>
>
> The demodulation is performed in the hardware.  You can, of
> course, re-invent the wheel if you like and perform the
> demultiplexing and decoding to PCM in software, if that is
> what you are asking.
>
>
> The sampling is done at the broadcaster/uplink end, and the
> corresponding samples are the PCM output, if I understand
> what you are asking.
>
>
> Sorry if I do not understand your question correctly.
>

Barry,

have you had a look at:
http://www.gnu.org/software/gnuradio/

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

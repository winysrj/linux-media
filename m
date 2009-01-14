Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1LN9ar-0006u1-IJ
	for linux-dvb@linuxtv.org; Wed, 14 Jan 2009 18:31:54 +0100
Received: by rn-out-0910.google.com with SMTP id j43so523841rne.2
	for <linux-dvb@linuxtv.org>; Wed, 14 Jan 2009 09:31:48 -0800 (PST)
Message-ID: <19a3b7a80901140931x4863a29cse6362ed9ca1c7534@mail.gmail.com>
Date: Wed, 14 Jan 2009 18:31:47 +0100
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Koos van den Hout" <koos@kzdoos.xs4all.nl>
In-Reply-To: <20081230103438.GA12942@kzdoos.xs4all.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081224112111.GA15004@kzdoos.xs4all.nl>
	<19a3b7a80812291613kc566f0cua89156b43f1ec7d7@mail.gmail.com>
	<20081230103438.GA12942@kzdoos.xs4all.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Scan file dvb-t nl-Utrecht
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

2008/12/30 Koos van den Hout <koos@kzdoos.xs4all.nl>:
> Quoting Christoph Pfister who wrote on Tue 2008-12-30 at 01:13:
>
>> 2008/12/24 Koos van den Hout <koos@kzdoos.xs4all.nl>:
>> > As attached, tested yesterday evening with scan from Ubuntu dvb-utils
>> > 1.1.1-3.
>> Those nl-* files were removed in favour of a nl-All file 11 months
>> ago. I've recreated the nl-All file as some channels have changed
>> since then [1], so all issues should be solved now.
>
> I found the repository and nl-All in the mean time, which is indeed a
> complete overview. It seems the files delivered with Ubuntu are somewhat
> dated compared to the dvb-apps repository.
>
> You *could* add the following entry:
>
> T 850000000 8MHz 1/2 NONE QAM64 8k 1/4 NONE # UHF 68

Done.

> Which is the local RTV-Stadskanaal dvb-t station (FTA), source
> http://www.rtvvis.nl/rtvvis-freq.tv DVB-T Lokaal NL.htm
>
> Another one I tested in the deep south of the Netherlands:
>
> # Liege - Belgique
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 834000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE

I don't want to mix different countries in one file. The longer term
solution for dvb-t should be auto scan, but that's a different topic
...

> Frequency found from
> http://nl.wikipedia.org/wiki/DVB-T-frequenties
>
> encoding, error correction and guard rate found by experiment: this was the
> setting that gave 0 errors / uncorrectable blocks and good image/sound.
>
>                                           Koos van den Hout

Thanks,

Christoph

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:34973 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3I3JTW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 05:19:22 -0400
Message-ID: <5248D0AA.5090307@schinagl.nl>
Date: Mon, 30 Sep 2013 03:15:22 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: =?UTF-8?B?TnVubyBHb27Dp2FsdmVz?= <nunojpg@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Initial scan files for PT
References: <CAEXMXLQVj+4t5yi0mL8=1Kb9kXn8V40=W0ED9Zz7YeCjjzMcMQ@mail.gmail.com>
In-Reply-To: <CAEXMXLQVj+4t5yi0mL8=1Kb9kXn8V40=W0ED9Zz7YeCjjzMcMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Nuno,

On 28-09-13 13:07, Nuno Gonçalves wrote:
> Here goes the initial scan files for Portugal DVB-T. Please commit them.
Thank you for these files, I decided to merge them all together into a 
pt-All. See github/git.linuxtv.com for details.

>
> Portugal is schedule to migrate from a SFN to a MFN, but for now this
> is how it is.
Whenever this change happens, please feel free to submit these changes 
to us and we will commit them. Do mind formatting next time (whitespaces).
>
> Files in attach and also the hg diff:
Actually, dtv-scan-files are now stored in git, you can use git 
format-patch/send-email or use github's pull request.

Thank you,

Oliver
>
>
> diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-Faial
> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/pt-Azores-Faial Sat Sep 28 11:49:03 2013 +0100
> @@ -0,0 +1,5 @@
> +# PT, Azores, Faial
> +# Generated from http://tdt-portugal.blogspot.pt/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 698000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
> +
> diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-Pico
> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/pt-Azores-Pico Sat Sep 28 11:49:03 2013 +0100
> @@ -0,0 +1,5 @@
> +# PT, Azores, Pico
> +# Generated from http://tdt-portugal.blogspot.pt/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 754000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
> +
> diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-SaoJorge
> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/pt-Azores-SaoJorge Sat Sep 28 11:49:03 2013 +0100
> @@ -0,0 +1,5 @@
> +# PT, Azores, Sao Jorge
> +# Generated from http://tdt-portugal.blogspot.pt/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 682000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
> +
> diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-SaoMiguel-Graciosa
> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/pt-Azores-SaoMiguel-Graciosa Sat Sep 28 11:49:03
> 2013 +0100
> @@ -0,0 +1,5 @@
> +# PT, Azores, Sao Miguel and Graciosa
> +# Generated from http://tdt-portugal.blogspot.pt/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 690000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
> +
> diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-Terceira-SMaria-Flores-Corvo
> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/pt-Azores-Terceira-SMaria-Flores-Corvo Sat Sep
> 28 11:49:03 2013 +0100
> @@ -0,0 +1,5 @@
> +# PT, Azores, Terceira and S. Maria and Graciosa
> +# Generated from http://tdt-portugal.blogspot.pt/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 738000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
> +
> diff -r 3ee111da5b3a util/scan/dvb-t/pt-Madeira
> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/pt-Madeira Sat Sep 28 11:49:03 2013 +0100
> @@ -0,0 +1,5 @@
> +# PT, Madeira
> +# Generated from http://tdt-portugal.blogspot.pt/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 738000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
> +
> diff -r 3ee111da5b3a util/scan/dvb-t/pt-mainland
> --- /dev/null Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/pt-mainland Sat Sep 28 11:49:03 2013 +0100
> @@ -0,0 +1,7 @@
> +# PT, mainland
> +# Generated from http://tdt-portugal.blogspot.pt/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 642000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE # Monte da Virgem
> +T 674000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE # Lousa (Trevim)
> +T 698000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE # Montejunto
> +T 754000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE # Mainland SFN
>
>
> Regards,
> Nuno Goncalves
>


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37059 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZFEUvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 16:51:52 -0400
Received: by bwz9 with SMTP id 9so1764625bwz.37
        for <linux-media@vger.kernel.org>; Fri, 05 Jun 2009 13:51:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <205146930906012241m2e96458cw66f105e60d299cf3@mail.gmail.com>
References: <205146930906011430me1a1327ka9da449169a4e984@mail.gmail.com>
	 <205146930906012241m2e96458cw66f105e60d299cf3@mail.gmail.com>
Date: Fri, 5 Jun 2009 22:51:52 +0200
Message-ID: <19a3b7a80906051351me082027xc50d3810770eb4a@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] dvb-apps DVB-C nl-Ziggo initial tuning file
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-media@vger.kernel.org
Cc: Hein Rigolo <rigolo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applied, thanks :)

Christoph


2009/6/2 Hein Rigolo <rigolo@gmail.com>:
> I have created an initial scanning file that can be used on all DVB-C
> networks that make up the Ziggo DVB-C cable network in the
> Netherlands. Ziggo is the result of a merger of 3 Cable Companies in
> the Netherlands. Because of that the nl-Casema initial tuning file is
> no longer needed (it was merged into nl-Ziggo)
>
> This initial tuning file has the 4 main frequencies that are used
> within the Ziggo DVB-C network for the main transport streams. From
> there you can find all other Transport Streams.
>
> Based on this document:
> http://blob.ziggo.nl/dynamic/NL_HOME/PDF-UPLOAD/Gebruikers-Handleiding-DigitaleTV.pdf
> chapter 4
>
> Because Ziggo is making use of NIT Others to specify the actual
> Frequencies of the other transport streams you really need to to use
> the -n option of the scan utility in dvb-apps.
>
> Based on the resulting channels.conf I have also constructed a more
> detailed initial tuning file for my specific DVB-C network (Region
> Zwolle). Here you do not need to use the -n option of scan.
>
> diff -r 9655c8cfeed8 util/scan/dvb-c/nl-Casema
> --- a/util/scan/dvb-c/nl-Casema    Tue May 19 14:48:06 2009 +0200
> +++ /dev/null    Thu Jan 01 00:00:00 1970 +0000
> @@ -1,3 +0,0 @@
> -# Casema Netherlands
> -# freq sr fec mod
> -C 372000000 6875000 NONE QAM64
> diff -r 9655c8cfeed8 util/scan/dvb-c/nl-Ziggo
> --- /dev/null    Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-c/nl-Ziggo    Sun May 31 21:04:48 2009 +0200
> @@ -0,0 +1,14 @@
> +# Initial Tuning file for nl-Ziggo
> +# This file only lists the main
> +# frequencies. You still need to do
> +# a network scan to find other
> +# transponders.
> +#
> +# based on:
> +# http://blob.ziggo.nl/dynamic/NL_HOME/PDF-UPLOAD/Gebruikers-Handleiding-DigitaleTV.pdf
> +# Chapter 4
> +#
> +C 372000000 6875000 NONE QAM64 # Main Frequency Ziggo/Casema
> +C 514000000 6875000 NONE QAM64 # Main Frequency Ziggo/Multikabel
> +C 356000000 6875000 NONE QAM64 # Main Frequency Ziggo/@Home Zuid
> +C 369000000 6875000 NONE QAM64 # Main Frequency Ziggo/@Home Noord
> diff -r 9655c8cfeed8 util/scan/dvb-c/nl-Ziggo-Zwolle
> --- /dev/null    Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-c/nl-Ziggo-Zwolle    Sun May 31 21:04:48 2009 +0200
> @@ -0,0 +1,26 @@
> +C 313000000 6875000 NONE QAM64 # TS   1
> +C 361000000 6875000 NONE QAM64 # TS   2
> +C 353000000 6875000 NONE QAM64 # TS   3
> +C 345000000 6875000 NONE QAM64 # TS   4
> +C 818000000 6875000 NONE QAM64 # TS   5
> +C 329000000 6875000 NONE QAM64 # TS   6
> +C 810000000 6875000 NONE QAM64 # TS   7
> +C 305000000 6875000 NONE QAM64 # TS   8
> +C 762000000 6875000 NONE QAM64 # TS   9
> +C 618000000 6875000 NONE QAM64 # TS  10
> +C 610000000 6875000 NONE QAM64 # TS  11
> +C 337000000 6875000 NONE QAM64 # TS  12
> +C 321000000 6875000 NONE QAM64 # TS  13
> +C 385000000 6875000 NONE QAM64 # TS  14
> +C 393000000 6875000 NONE QAM64 # TS  15
> +C 401000000 6875000 NONE QAM64 # TS  16
> +C 369000000 6875000 NONE QAM64 # TS  18 (main TS)
> +C 297000000 6875000 NONE QAM64 # TS  19
> +C 377000000 6875000 NONE QAM64 # TS  22
> +C 754000000 6875000 NONE QAM64 # TS  23
> +C 642000000 6875000 NONE QAM64 # TS  24
> +C 650000000 6875000 NONE QAM64 # TS  25
> +C 794000000 6875000 NONE QAM64 # TS  26
> +C 409000000 6875000 NONE QAM64 # TS  27
> +C 425000000 6875000 NONE QAM64 # TS 206
> +C 417000000 6875000 NONE QAM64 # TS 207

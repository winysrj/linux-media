Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxf2.bahnhof.se ([213.80.101.26]:55241 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZBRHA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 02:00:58 -0500
Message-ID: <51508.79.136.92.202.1234940452.squirrel@webmail.bahnhof.se>
In-Reply-To: <854d46170902170925x6a1c8d3x6d953d1d9472a81b@mail.gmail.com>
References: <59052.79.136.92.202.1234853938.squirrel@webmail.bahnhof.se>
    <854d46170902170925x6a1c8d3x6d953d1d9472a81b@mail.gmail.com>
Date: Wed, 18 Feb 2009 08:00:52 +0100 (CET)
Subject: Re: Tevii S650 DVB-S2 diseqc problem
From: svankan@bahnhof.se
To: "Faruk A" <fa@elwak.com>
Cc: svankan@bahnhof.se, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
> Windows softwares are like that with new cards but they usually get
> supported when the card becomes
> popular. My dish is even farther that yours, i live in six floor
> apartment building with over 100 apartments we all
> share four dishes so every apartment is satellite ready.
>
> One thing that i hate about this card is scanning for channels, i
> think it doesn't support AUTO scanning
> for initial transponders.
> For that we have to use scan-s2 with -X option and you need
> transponder files from
> http://joshyfun.peque.org/transponders/kaffeine.html
> before you start scanning edit you transponder files and remove
> transponders that you don't need, stuff like feeds, beams that you
> can't receive
> because it takes allot of time. Every transponders that wont lock it
> scan as dvb-s and then it will rescan as dvb-s2.
>
> scan-s2 -a 1 -s 3 -t 1 -p -X ../ini/astra > test.conf
> -a 1= adaptern 1
> -s 3 = diseqc input 4 (Astra 19E)
> -t 1 = Service TV only
> -p   = for vdr output format: dump provider name
> -X  = Disable AUTOs for initial transponders (esp. for hardware which
>         not support it). Instead try each value of any free parameters.

It works!!! I appreciate your help and I hope the card is stable to use.

/Svankan


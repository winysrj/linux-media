Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47624 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab1F0Gbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 02:31:36 -0400
Received: by iyb12 with SMTP id 12so3830580iyb.19
        for <linux-media@vger.kernel.org>; Sun, 26 Jun 2011 23:31:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309125622.5421.15.camel@wide>
References: <4DFFA7B6.9070906@free.fr>
	<4DFFA917.5060509@iki.fi>
	<4E017D7D.4050307@free.fr>
	<BANLkTimQymz5K6YhhUgPeWjMFkkVoU6j4A@mail.gmail.com>
	<4E079E9F.7050004@free.fr>
	<1309125622.5421.15.camel@wide>
Date: Mon, 27 Jun 2011 08:31:35 +0200
Message-ID: <BANLkTi=we3eOeFq6ru245i20e5uD-YRyMA@mail.gmail.com>
Subject: Re: Updates to French scan files
From: Johann Ollivier Lapeyre <johann.ollivierlapeyre@gmail.com>
To: Alexis de Lattre <alexis@via.ecp.fr>
Cc: mossroy <mossroy@free.fr>, linux-media@vger.kernel.org,
	Christoph Pfister <christophpfister@gmail.com>,
	n_estre@yahoo.fr, alkahan@free.fr, ben@geexbox.org,
	xavier@dalaen.com, jean-michel.baudrey@orange.fr,
	lissyx@dyndns.org, sylvestre.cartier@gmail.com,
	brossard.damien@gmail.com, jean-michel-62@orange.fr
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear LinuxTV friends,

> In order to simplify things, I would propose only ONE scan file with
> offset -166, 0, 166, 333 and 500. OK, it will take more time for users
> to run a scan (+66 %) compared to having a file with only offsets -166,
> 0, 166 but at least we are sure to cover all the possible offset that
> can be used in France, and we simplify things as much as we can for
> users.

As a simple user regarding LinuxTV, i had to:
1) Buy a TV card, and plug it
2) Try TV software to "scan", and see this is not working
3) google the issue and found a tuto
4) try the tuto
5) scan
6) scream "this fucking card **** **** * ****" to everyone ( false, i
keep it in my head)

7 to 34) Iterate many many time between 3 and 6

35) At least found the Freq in Mhz = 306 + (8 x N) + (0,166 x D) thing
on an obscure and random forum
36) take  an editor, my favorite scripting language, and program
something to get the good file for Brest
37) test a scan
38) See this is not working
39) scream " i don't know the **** others parameter like polarisation"
(yes, still in my head)
...
87) Found how to finally get a working file for brest
88) Send the Brest file to [i don't remember], and Alexis gently said
he commited it.

I think this took me enough lifetime to say that +66% on scan is
really not an issue. +66% is good, even 200% is good!
1) You launch the scan, and see how it's progressing
2) take a coffee and read some news on the net.
3) And finally enjoy the fact the card found all TV channel.
4) At the end, say to the world "the linux/linux-media developers are
fu***** good"

IMHO, this is a much better process ;-)

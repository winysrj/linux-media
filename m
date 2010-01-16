Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.velocitynet.com.au ([203.17.154.21]:36917 "EHLO
	webmail2.velocitynet.com.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755375Ab0APCt5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 21:49:57 -0500
MIME-Version: 1.0
Date: Sat, 16 Jan 2010 02:49:52 +0000
From: <paul10@planar.id.au>
To: "Igor M. Liplianin" <liplianin@me.by>,
	"linux-media" <linux-media@vger.kernel.org>
Subject: Re: DM1105: could not attach frontend 195d:1105
Message-ID: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Paul wrote:
> Is it likely that there is a tuner under the card labelled "ERIT"?  To
> take it off I have to unsolder some stuff - I can do that, but I reckon
> it's only 50% chance the card will work again when I put it back
together -
> my soldering isn't so good.

Igor wrote:
> No need to unsolder. I see a Serit can tuner. There is a sticked paper
with a label on right side 
> of the tuner. It must contain something like "sp2636lhb" or "sp2633chb".
Please provide me text of 
> label.

Ah, I see.   The whole thing is a tuner, and the label that I thought said
"ERIT" actually says "SERIT".  Yes, it does have a label on it, I should
have given you that up front.  I had searched for it on the internet and
decided that it didn't mean anything.  Thanks so much for your help.

The label reads SP1514LHb  D0943B

If I follow your decipher instructions that means:

1: DVB-S
5: 16cc
1: Unsure, but it has an LNB in and an LNB out, so I guess it does have
loop through?
4: Si2109
L: Si labs
H: Horizontal
b: Lead free

So I'm looking for some code to enable an Si2109 tuner?

Thanks again,

Paul


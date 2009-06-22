Return-path: <linux-media-owner@vger.kernel.org>
Received: from host-srv-101.hosting.jkg-it-services.net ([85.25.179.239]:46628
	"EHLO mail01.hosting.jkg-it-services.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755758AbZFVRdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 13:33:09 -0400
To: <linux-media@vger.kernel.org>
Subject: Re: Dual DVB-S2 Card
MIME-Version: 1.0
Date: Mon, 22 Jun 2009 19:33:10 +0200
From: =?UTF-8?Q?Jens_Krehbiel-Gr=C3=A4ther?=
	<jens.krehbiel-graether@jkg-it-services.de>
In-Reply-To: <57b4ac7aa53bbb6e913d4c3c16d95fb6@imap.hosting.jkg-it-services.net>
References: <57b4ac7aa53bbb6e913d4c3c16d95fb6@imap.hosting.jkg-it-services.net>
Message-ID: <6cfd8c29e0d5b7cec4541de7e5eb5be8@imap.hosting.jkg-it-services.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi!



I got answer from Media-Pointer about this Dual DVB-S2-Card.



<answer>

das Micronas Referenz Design hat auf dem STB6100 (5V Tuner) du dem STV0899

sowie dem LNBH 221 aufgebaut.

Wir haben die neuen Chips verwendet, STB6110A (3V Tuner) und dem STV 0900B

(Cut/2) und dem LNBH 24.

</answer>



In english:

This card is not based on the reference design of Micronas, which uses the

STB6100 (5V tuner), the STV0899 and the LNBH 221.

They used a "new" chip-version, the STB6110A (3V tuner), the STV0900B

(Cut/2) and the LNBH 24.



How about the driver status under linux? I found Igor Liplianin added

support for it about 3 months ago. Is it working well? And is it working

with dual tuner?? I bouht a few devices in the past 5 years which told to

be working under linux, but some devices won't run. :-(

So when I buy this card it would be nice to know if it works or not..



Jens









On Sat, 20 Jun 2009 22:19:30 +0200, Jens Krehbiel-Gräther

<jens.krehbiel-graether@jkg-it-services.de> wrote:

> Hi!

> 

> Does anyone know something about this card?

> 

>

http://www.media-pointer.de/index.php?page=shop.product_details&flypage=flypage.tpl&product_id=6&category_id=3&option=com_virtuemart&Itemid=1

> 

> I think this card is a type of the reference design from micronas (think

of

> the year 2006??).

> 

>

http://www.computerbase.de/news/hardware/multimedia/2006/august/micronas_pci_express_dual-dvb-s2-tuner/

> 

> (Sorry, all in german)

> 

> I send a request to the manufacturer and asked what chips are used on the

> card. When I get an answer I will post it here.

> 

> If this card hast the STB0899/6100 chip, i think it should work with

S2-API

> repository of Igor Liplianin or Manu Abraham???

> Do you think I can use both tuner "out of the box" with these drivers??

> 

> Thanks for your information!

> 

> Jens

> --

> To unsubscribe from this list: send the line "unsubscribe linux-media" in

> the body of a message to majordomo@vger.kernel.org

> More majordomo info at  http://vger.kernel.org/majordomo-info.html

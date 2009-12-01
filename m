Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZLARPd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 12:15:33 -0500
Message-ID: <4B154F26.6070607@redhat.com>
Date: Tue, 01 Dec 2009 15:15:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "OrazioPirataDelloSpazio (Lorenzo)" <ziducaixao@autistici.org>
CC: no To-header on input
	<"unlisted-recipients:; "@bombadil.infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: DIY Satellite Web Radio
References: <4B14195D.6000205@autistici.org> <4B142E2C.1020108@redhat.com> <4B143E29.4090307@autistici.org>
In-Reply-To: <4B143E29.4090307@autistici.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OrazioPirataDelloSpazio (Lorenzo) wrote:
> Mauro Carvalho Chehab ha scritto:
>> Receiving sat signals without dishes? From some trials we had on a telco
>> I used to work, You would need to use a network of low-orbit satellites,
>> carefully choosing the better frequencies and it will provide you
>> low bandwidth.
> I also believed this, but their use geostationary orbit [1] and
> terrestrial devices handly and without dishes [2] [3].
> I belive they should rely on some very robust modulation e channel
> coding, but unfortunately I didn't find any specification.

>From what I remember from the tests, the worse problem were related to the transmission.

If you're just receiving data, it is possible to receive without a dish, depending
on the transmission frequency and modulation schema. It works better with some spread
spectrum modulation, since you'll have some gain due to frequency diversity. You may also
use a dual antenna to gain a few more dB's. However, if you need to transmit data to the
satellite (to have something close to Internet via Amateur Radio), I doubt you'll be able
to do it without a highly directional antenna.
> 
> Lorenzo
> 
> 
> [1]http://en.wikipedia.org/wiki/XM_Satellite_Radio
> [2]http://shop.xmradio.com/xm/ctl10600/cp49770/si4025808/cl1/xmp3_portable_radio_with_home_kit
> [3]http://shop.xmradio.com/xm/ctl10600/cp56879/si4343009/cl1/xm_direct_2
> 


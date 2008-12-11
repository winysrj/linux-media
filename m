Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LAukb-0007IP-9C
	for linux-dvb@linuxtv.org; Fri, 12 Dec 2008 00:15:22 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: xweber.alex@googlemail.com
In-Reply-To: <49412E14.5090001@googlemail.com>
References: <493AC65E.3010900@googlemail.com>
	<493D593F.7010707@googlemail.com> <337548152.20081208193816@gmail.com>
	<493D62F5.4010207@googlemail.com>
	<1228770724.2587.16.camel@pc10.localdom.local>
	<493D9545.4080605@googlemail.com> <1689947513.20081209045705@gmail.com>
	<49412E14.5090001@googlemail.com>
Date: Fri, 12 Dec 2008 00:10:19 +0100
Message-Id: <1229037019.5863.35.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134 with Avermedia M115S hybrid card
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

Hi,

Am Donnerstag, den 11.12.2008, 16:13 +0100 schrieb Alexander Weber:
> Tanguy Pruvot wrote:
> >   Mini  PCI  Cards  are  often  (but  not always) accessible under the
> >   laptop, like RAM or Hard disk, because that could be an option of the laptop...
> > 
> >   Did you take a look closer ?
> > 
> 
> Hi all,
> 
> yes today i took a closer look and have taken some hires pictures from 
> that mini-pc card. Now I am looking for a smooth place to upload them. 
> Is the a "central-point" in linuxtv.org wiki for those kind of 
> "documentation"?

yes, currently it seems so, but you also can mail to me or anybody else
interested also directly.

> For the impatient ;)
> the main chips are labeled with
> 
> SAA7135HL/203
> CK2534    03
> TSG07522

That one was clear.

> NEC
> D61151F1 A02
> 0741E3005

That is the expected but unsupported and undocumented mpeg encoder I
suspect to be on 0x82.
http://www.necel.com/digital_av/en/mpegenc/d61151_d61152.html

> ESMT
> M12L64322A-     7T
> AZG1P72G4     0747

That is the the SDRAM belonging to it.

So we have no trace of a digital channel decoder yet and also no new
ideas how to activate the XCeive tuner.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

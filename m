Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f172.mail.ru ([194.67.57.165])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1K5Z1B-0001op-H4
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 06:30:05 +0200
From: Goga777 <goga777@bk.ru>
To: Faruk A <fa@elwak.com>
Mime-Version: 1.0
Date: Mon, 09 Jun 2008 08:29:31 +0400
References: <854d46170806081250u3e7ca97er32d47be3ccf368fb@mail.gmail.com>
In-Reply-To: <854d46170806081250u3e7ca97er32d47be3ccf368fb@mail.gmail.com>
Message-Id: <E1K5Z0d-000P20-00.goga777-bk-ru@f172.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?c2NhbiAmIHN6YXAgZm9yIG5ldyBtdWx0aXByb3Rv?=
	=?koi8-r?b?IGFwaSAod2FzIC0gSG93IHRvIGdldCBhIFBDVFYgU2F0IEhEVEMg?=
	=?koi8-r?b?UHJvIFVTQiAoNDUyZSkgcnVubmluZz8p?=
Reply-To: Goga777 <goga777@bk.ru>
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

> I'm glad everything worked out for you :).
> with szap to tune to DVB-S2 channels use this option "-t 2" default is
> "- t 0" which is for DVB-S
> to tune to 'Astra HD Promo 2' you do:
> szap -r -c 19 -t 2 "Astra HD Promo 2"

I will try so. It will be fine if new dvb-s2 option will include in szap --help output

btw, why do you use the -r option ?

> As for scan you don't have do anything as far as i know it finds
> DVB-S2  channels as well.

no, I couldn't find the dvb-s2 transponders on 13e and 19e

19e

S 11914000 H 27500000 9/10
S 12522000 V 22000000 2/3 
S 12581000 V 22000000 2/3

13e

S 11258000 H 27500000 2/3 
S 11278000 V 27500000 2/3
S 11449000 H 27500000 2/3
S 11996000 V 27500000 2/3


Goga

> 
> Faruk
> 
> On Sun, Jun 8, 2008 at 9:06 PM, Goga777 <goga777@bk.ru> wrote:
> > Hi, Jens
> >
> >> >> For szap you have to download
> >> >>
> >> >> http://abraham.manu.googlepages.com/szap.c
> >> >> then applie the api-v3.3 patch and compile it. This should work too.
> >> >>
> >> >> Or download the hg tree of dvb-apps and apply the attached patch on the whole tree. After that go to the scan and szap
> >> >> directory and run "make". This works for me.
> >> >>
> >> >
> >> > should your patch for scan/szap from dvb-apps work with others dvb-s2 cards - tt3200, vp1041, hvr4000  and the latest
> >> > multiproto/multiproto_plus ?
> >> >
> >>
> >> Well, I don't have such a device for testing, but why not? The dvb-apps
> >> are not driver dependent.
> >
> > I hope so
> >
> >>>Or am I wrong? The HVR4000 I don't know? I
> >
> > here's information about this card
> > http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
> >
> >> think this card works only with the szap2-util!? (But I'm not sure!!)
> >
> > thanks for your patch. It's working with dvb-s
> > i applied your patch_scan_szap.diff for HG dvb-apps. And I could run szap & scan with my hvr4000
> > But only with dvb-s channels.
> >
> > And what about dvb-s2 ? I couldn't find any dvb-s2 option in szap & scan
> > How can I scan dvb-s2 transponders and switch to dvb-s2 channels ?
> >
> > btw - there's patched szap2 in
> > http://linuxtv.org/hg/dvb-apps/file/9311c900f746/test/szap2.c
> > but it doesn't work with my card
> >
> > /usr/src/dvb-apps/test# ./szap2 -c 19 -n1
> > reading channels from file '19'
> > zapping to 1 'Astra HD Promo 2':
> > sat 0, frequency = 11914 MHz H, symbolrate 27500000, vpid = 0x04ff, apid = 0x0503 sid = 0x0083
> > Querying info .. Delivery system=DVB-S
> > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> > ioctl DVBFE_GET_INFO failed: Operation not supported
> >
> > Goga
> >
> >
> >
> >
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

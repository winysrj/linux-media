Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KQKf7-0006yn-CR
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 13:25:11 +0200
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KQKf0-0004KJ-MZ
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 11:25:02 +0000
Received: from fw.sj.tdf-pmm.net ([91.197.165.186])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Tue, 05 Aug 2008 11:25:02 +0000
Received: from alexandre.lissy by fw.sj.tdf-pmm.net with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Tue, 05 Aug 2008 11:25:02 +0000
To: linux-dvb@linuxtv.org
From: alex <alexandre.lissy@smartjog.com>
Date: Tue, 05 Aug 2008 13:03:55 +0200
Message-ID: <g79bv2$8u8$1@webmisc.dmz-ext.rep.sj>
References: <11920.130.36.62.139.1217489885.squirrel@webmail.xs4all.nl>
	<20080731215032.687f32a3@bk.ru>
	<Pine.LNX.4.64.0808020204110.14769@shogun.pilppa.org>
Mime-Version: 1.0
Subject: Re: [linux-dvb] latest hvr-4000 driver patches
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

Mika Laitio wrote:

>>>> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/liplianindvb/
>>>> It works well. I recommend it for your case
>>>> Of course it's not multifrontend drivers
> 
> If I use this driver for dvb-s, can I use the normal szap and scan utils
> from dvb-apps repository or should download the szap2 and scan2 from
> somewhere?
> 
> Mika

Considering this driver is using multiproto, you need userland which is able
to use multiproto, so use szap2 from the same repository :)

I've just updated my working copy of this repository, and got a
WINTV-NOVA-HD-S2 to work, or at least, to some point where it looks like it
works with DVB-S2. I tested it with some conf :
more Astra-19.2E.conf
Anixe HD:12722:h:1:22000:1023:1027:10203
Astra HD Promo:11914:h:1:27500:1279:1283:131

before the commit from last sunday :
szap2 -a 2 -x -S 1 -c ./Astra-19.2E.conf "Anixe HD"
reading channels from file './Astra-19.2E.conf'
zapping to 1 'Anixe HD':
API ver 3, delivery DVB-S2, modulation QPSK
sat 1, frequency 12722 MHz H, symbolrate 22000000, coderate auto, rolloff
0.35
vpid 0x03ff, apid 0x0403, sid 0x27db
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
ioctl DVBFE_SET_DELSYS failed or not supported: Invalid argument
status 01 | signal c440 | snr 0000 | ber 00000000 | unc 00000000 |
^C

after :
szap2 -a 2 -x -S 1 -c ./Astra-19.2E.conf "Anixe HD"
reading channels from file './Astra-19.2E.conf'
zapping to 1 'Anixe HD':
API ver 3, delivery DVB-S2, modulation QPSK
sat 1, frequency 12722 MHz H, symbolrate 22000000, coderate auto, rolloff
0.35
vpid 0x03ff, apid 0x0403, sid 0x27db
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 |


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

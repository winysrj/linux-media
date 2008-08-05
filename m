Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f110.mail.ru ([194.67.57.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KQMOl-0007r4-Vu
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 15:16:26 +0200
From: Goga777 <goga777@bk.ru>
To: alex <alexandre.lissy@smartjog.com>
Mime-Version: 1.0
Date: Tue, 05 Aug 2008 17:15:44 +0400
In-Reply-To: <g79bv2$8u8$1@webmisc.dmz-ext.rep.sj>
References: <g79bv2$8u8$1@webmisc.dmz-ext.rep.sj>
Message-Id: <E1KQMO8-000CmA-00.goga777-bk-ru@f110.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] =?koi8-r?b?bmV3IGR2Yi1zMi1saXBsaWFuaW5kdmItcmVwbyAo?=
	=?koi8-r?b?d2FzIC0gUmVbMl06ICBsYXRlc3QgaHZyLTQwMDAgZHJpdmVyIHBh?=
	=?koi8-r?b?dGNoZXMp?=
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

 
> >>>> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/liplianindvb/
> >>>> It works well. I recommend it for your case
> >>>> Of course it's not multifrontend drivers
> > 
> > If I use this driver for dvb-s, can I use the normal szap and scan utils
> > from dvb-apps repository or should download the szap2 and scan2 from
> > somewhere?
> > 
> > Mika
> 
> Considering this driver is using multiproto, you need userland which is able
> to use multiproto, so use szap2 from the same repository :)

yes, you're right - you should use dvb-application with multiproto support - vdr 170, szap2 from that repo.
But old application should work correctly with this driver too, but only with dvb-s.

> I've just updated my working copy of this repository, and got a
> WINTV-NOVA-HD-S2 to work, or at least, to some point where it looks like it
> works with DVB-S2. I tested it with some conf :
> more Astra-19.2E.conf
> Anixe HD:12722:h:1:22000:1023:1027:10203
> Astra HD Promo:11914:h:1:27500:1279:1283:131
> 
> before the commit from last sunday :
> szap2 -a 2 -x -S 1 -c ./Astra-19.2E.conf "Anixe HD"
> reading channels from file './Astra-19.2E.conf'
> zapping to 1 'Anixe HD':
> API ver 3, delivery DVB-S2, modulation QPSK
> sat 1, frequency 12722 MHz H, symbolrate 22000000, coderate auto, rolloff
> 0.35
> vpid 0x03ff, apid 0x0403, sid 0x27db
> using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
> ioctl DVBFE_SET_DELSYS failed or not supported: Invalid argument
> status 01 | signal c440 | snr 0000 | ber 00000000 | unc 00000000 |
> ^C
> 
> after :
> szap2 -a 2 -x -S 1 -c ./Astra-19.2E.conf "Anixe HD"
> reading channels from file './Astra-19.2E.conf'
> zapping to 1 'Anixe HD':
> API ver 3, delivery DVB-S2, modulation QPSK
> sat 1, frequency 12722 MHz H, symbolrate 22000000, coderate auto, rolloff
> 0.35
> vpid 0x03ff, apid 0x0403, sid 0x27db
> using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
> status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal c040 | snr 0000 | ber 00000000 | unc 00000000 |


with scan2 you should use -C and -M parameters too !

Goga


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

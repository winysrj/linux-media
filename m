Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1K5Jb1-0005aS-1E
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 14:02:06 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1226005fga.25
	for <linux-dvb@linuxtv.org>; Sun, 08 Jun 2008 05:01:57 -0700 (PDT)
Message-ID: <854d46170806080501l19b03e99jb42a49eabb517abe@mail.gmail.com>
Date: Sun, 8 Jun 2008 14:01:57 +0200
From: "Faruk A" <fa@elwak.com>
To: "Zeno Zoli" <zeno.zoli@gmail.com>
In-Reply-To: <45e226e50806080329t3e5962b1w8f6701b72119f36f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_11605_25690486.1212926517467"
References: <45e226e50806060327s7e3ecf86wb9141ee394e854d1@mail.gmail.com>
	<E1K4ZQk-000ARd-00.goga777-bk-ru@f145.mail.ru>
	<45e226e50806060353o32b215afwc3017e3ab8a2dd10@mail.gmail.com>
	<854d46170806060550u5c238e26ia003c713ed68095e@mail.gmail.com>
	<45e226e50806071017y4e09413dl23c119da0910fae2@mail.gmail.com>
	<854d46170806071111s65b96325mfc8beaa6171259dd@mail.gmail.com>
	<45e226e50806080329t3e5962b1w8f6701b72119f36f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy S2 PCI HD ioctl DVBFE_GET_INFO
	failed:Operation not supported
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_11605_25690486.1212926517467
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Zeno!

I'm glad it worked out for you, as for szap2 is included in dvb-apps
under "test" directory.
http://linuxtv.org/hg/dvb-apps

Kaffeine doesn't have support for multiproto someone is working on
that according to him he was suppose to release
last week, I don't know what happened. You can ask him yourself
"webdev at chaosmedia dot org"

As for "Using 'STB0899 Multistandard' DVB-S" it's always been that
like that when scanning but it should find HD channels
as well.

If you want to use Kaffeine or any other DVB applications that lack
multiproto support there is another alternative.
You cant patch mutiproto with old api patch, if you go with this i
think you are going to need unpatched scan and szap
which can be found in standard dvb-apps.
(This DVB-S only, but if you use it with multiproto supported apps
like vdr u can use DVB_S2)

I have attached "multiproto-support-old-api.diff"

Faruk

On Sun, Jun 8, 2008 at 12:29 PM, Zeno Zoli <zeno.zoli@gmail.com> wrote:
> Thanks. I got the scan working. It failed on most frequencies though.
>
> ----------------------------------> Using 'STB0899 Multistandard' DVB-S
>
> Shouldn't that be:
> ----------------------------------> Using 'STB0899 Multistandard' DVB-S2  ?
>
> Besides that. Do you know where the patched szap2 can be found, or is there
> an alternative?
> Tried Kaffeine, but still without success. Guess I need a kaffeine patch
> too.
>
>
> On Sat, Jun 7, 2008 at 8:11 PM, Faruk A <fa@elwak.com> wrote:
>>
>> Hi Zeno!
>>
>> If i remember correctly i think i got Hunk failed too i had to paste
>> it manually.
>> here is my copy already been patched and compiled. If the binary scan
>> doesn't work run "make clean" and then "make"
>> http://www.zshare.net/download/1322006118c9c70a/
>>
>> Faruk
>>
>>
>> On Sat, Jun 7, 2008 at 7:17 PM, Zeno Zoli <zeno.zoli@gmail.com> wrote:
>> > Tried, and got
>> >
>> > Hunk #1 FAILED at 1674.
>> > Hunk #2 FAILED at 1693.
>> > Hunk #3 FAILED at 1704.
>> >
>> >
>> >
>> > On Fri, Jun 6, 2008 at 2:50 PM, Faruk A <fa@elwak.com> wrote:
>> >>
>> >> Hi Zeno!
>> >>
>> >> Apply this patch.
>> >>
>> >> diff -Naur 1/scan.c 2/scan.c
>> >> --- 1/scan.c    2008-04-03 02:00:19.000000000 +0200
>> >> +++ 2/scan.c    2008-04-03 12:29:32.000000000 +0200
>> >> @@ -1674,15 +1674,18 @@
>> >>        }
>> >>
>> >>         struct dvbfe_info fe_info1;
>> >> +       enum dvbfe_delsys delivery;
>> >>
>> >>         // a temporary hack, need to clean
>> >>         memset(&fe_info1, 0, sizeof (struct dvbfe_info));
>> >>
>> >>         if(t->modulation_system == 0)
>> >> -            fe_info1.delivery = DVBFE_DELSYS_DVBS;
>> >> +            delivery = DVBFE_DELSYS_DVBS;
>> >>         else if(t->modulation_system == 1)
>> >> -            fe_info1.delivery = DVBFE_DELSYS_DVBS2;
>> >> -
>> >> +            delivery = DVBFE_DELSYS_DVBS2;
>> >> +
>> >> +        ioctl(frontend_fd, DVBFE_SET_DELSYS, &delivery); //switch
>> >> system
>> >> +
>> >>         int result = ioctl(frontend_fd, DVBFE_GET_INFO, &fe_info1);
>> >>         if (result < 0) {
>> >>             perror("ioctl DVBFE_GET_INFO failed");
>> >> @@ -1690,7 +1693,7 @@
>> >>             return -1;
>> >>         }
>> >>
>> >> -        switch (fe_info1.delivery) {
>> >> +        switch (delivery) {
>> >>             case DVBFE_DELSYS_DVBS:
>> >>                 info("----------------------------------> Using '%s'
>> >> DVB-S\n", fe_info.name);
>> >>                 break;
>> >> @@ -1701,7 +1704,7 @@
>> >>                 info("----------------------------------> Using '%s'
>> >> DVB-S2\n", fe_info.name);
>> >>                 break;
>> >>             default:
>> >> -                info("Unsupported Delivery system (%d)!\n",
>> >> fe_info1.delivery);
>> >> +                info("Unsupported Delivery system (%d)!\n", delivery);
>> >>                 t->last_tuning_failed = 1;
>> >>                 return -1;
>> >>         }
>> >>
>> >>
>> >>
>> >> 2008/6/6 Zeno Zoli <zeno.zoli@gmail.com>:
>> >> > I suppose so
>> >> >
>> >> > wget http://jusst.de/manu/scan.tar.bz2
>> >> > from
>> >> > http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI
>> >> >
>> >> >
>> >> >
>> >> >
>> >> >
>> >> > 2008/6/6 Goga777 <goga777@bk.ru>:
>> >> >>
>> >> >> which scan version do you use ? does it support the multiproto api ?
>> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >> >> > I'm new to DVB on linux, but have some linux experience. I have
>> >> >> > trouble
>> >> >> > to
>> >> >> > get my new Terratec Cinergy S2 PCI HD to work properly. I have
>> >> >> > followed
>> >> >> > the
>> >> >> > guide here:
>> >> >> > http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI
>> >> >> >
>> >> >> > I get "ioctl DVBFE_GET_INFO failed: Operation not supported"
>> >> >> > when I try to ./scan -vv dvb-s/Thor-1.0W ( more info below)
>> >> >> >
>> >> >> > Could it be related to my choice of Ubuntu 2.6.24-16-server?
>> >> >> > Thanks for your help.
>> >> >> >
>> >> >> > Zeno.
>> >> >> >
>> >> >> >
>> >> >> > uname -a
>> >> >> > Linux htpc 2.6.24-16-server #1 SMP i686 GNU/Linux
>> >> >> >
>> >> >> > /home/htpc/scan# ./scan -vv dvb-s/Thor-1.0W
>> >> >> > scanning dvb-s/Thor-1.0W
>> >> >> > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> >> >> > initial transponder 11247000 V 24500000 24500000
>> >> >> > initial transponder 11293000 H 24500000 24500000
>> >> >> > initial transponder 11325000 H 24500000 24500000
>> >> >> > initial transponder 12054000 H 28000000 28000000
>> >> >> > initial transponder 12169000 H 28000000 28000000
>> >> >> > initial transponder 12226000 V 28000000 28000000
>> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
>> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
>> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
>> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
>> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
>> >> >> > ioctl DVBFE_GET_INFO failed: Operation not supported
>> >> >> > ERROR: initial tuning failed
>> >> >> > dumping lists (0 services)
>> >> >> >
>> >> >> > lsmod
>> >> >> >
>> >> >> > lnbp21                  3200  1 mantis
>> >> >> > mb86a16                21632  1 mantis
>> >> >> > stb6100                 8836  1 mantis
>> >> >> > tda10021                7684  1 mantis
>> >> >> > tda10023                7300  1 mantis
>> >> >> > stb0899                36224  1 mantis
>> >> >> > stv0299                11528  1 mantis
>> >> >> > dvb_core               89212  2 mantis,stv0299
>> >> >> >
>> >> >> >
>> >> >> > dmesg
>> >> >> >
>> >> >> >  36.793511] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on
>> >> >> > (02:09.0),
>> >> >> > [   36.793513]     Mantis Rev 1 [153b:1179], irq: 20, latency: 64
>> >> >> > [   36.793515]     memory: 0xfddff000, mmio: 0xf8a54000
>> >> >> > [   36.796981]     MAC Address=[00:08:ca:1c:a8:e9]
>> >> >> > [   36.797011] mantis_alloc_buffers (0): DMA=0x37560000
>> >> >> > cpu=0xf7560000
>> >> >> > size=65536
>> >> >> > [   36.797061] mantis_alloc_buffers (0): RISC=0x37501000
>> >> >> > cpu=0xf7501000
>> >> >> > size=1000
>> >> >> > [   36.797107] DVB: registering new adapter (Mantis dvb adapter)
>> >> >> > [   37.345712] stb0899_get_dev_id: Device ID=[8], Release=[2]
>> >> >> > [   37.358369] stb0899_get_dev_id: Demodulator Core ID=[DMD1],
>> >> >> > Version=[1]
>> >> >> > [   37.371023] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
>> >> >> > [   37.371074] stb0899_attach: Attaching STB0899
>> >> >> > [   37.371076] mantis_frontend_init (0): found STB0899
>> >> >> > DVB-S/DVB-S2
>> >> >> > frontend
>> >> >> > @0x68
>> >> >> > [   37.371135] stb6100_attach: Attaching STB6100
>> >> >> > [   37.371491] DVB: registering frontend 0 (STB0899
>> >> >> > Multistandard)...
>> >> >> > [   37.371523] mantis_ca_init (0): Registering EN50221 device
>> >> >> > [   37.372914] mantis_ca_init (0): Registered EN50221 device
>> >> >> > [   37.372973] mantis_hif_init (0): Adapter(0) Initializing Mantis
>> >> >> > Host
>> >> >> > Interface
>> >> >> >
>> >> >> > lspci -v
>> >> >> > 02:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis
>> >> >> > DTV
>> >> >> > PCI
>> >> >> > Bridge Controller [Ver 1.0] (rev 01)
>> >> >> >         Subsystem: TERRATEC Electronic GmbH Unknown device 1179
>> >> >> >         Flags: bus master, medium devsel, latency 64, IRQ 20
>> >> >> >         Memory at fddff000 (32-bit, prefetchable) [size=4K]
>> >> >>
>> >> >> >
>> >> >>
>> >> >> _______________________________________________
>> >> >> linux-dvb mailing list
>> >> >> linux-dvb@linuxtv.org
>> >> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>> >> >
>> >> >
>> >> > _______________________________________________
>> >> > linux-dvb mailing list
>> >> > linux-dvb@linuxtv.org
>> >> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>> >> >
>> >
>> >
>
>

------=_Part_11605_25690486.1212926517467
Content-Type: text/x-patch; name=multiproto-support-old-api.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh7kvvpf0
Content-Disposition: attachment; filename=multiproto-support-old-api.diff

RnJvbTogQW5zc2kgSGFubnVsYSA8YW5zc2kuaGFubnVsYUBnbWFpbC5jb20+CgptdWx0aXByb3Rv
OiBhZGQgc3VwcG9ydCBmb3IgdXNpbmcgbXVsdGlwcm90byBkcml2ZXJzIHdpdGggb2xkIGFwaQoK
QWxsb3cgdXNpbmcgbXVsdGlwcm90byBkcml2ZXJzIHdpdGggdGhlIG9sZCBBUEkuIE11bHRpcHJv
dG8gZHJpdmVycwp3aWxsIHByb3ZpZGUgb25lIGZyb250ZW5kIHR5cGUgb3ZlciB0aGUgb2xkIEFQ
SS4gRm9yIFNUQjA4OTkgdGhpcyBpcwpGRV9RUFNLLiBvbGRkcnZfdG9fbmV3YXBpKCkgYW5kIG5l
d2FwaV90b19vbGRkcnYoKSBhcmUgcmVuYW1lZCB0bwpvbGRhcGlfdG9fbmV3YXBpKCkgYW5kIG5l
d2FwaV90b19vbGRhcGkoKSwgcmVzcGVjdGl2ZWx5LgoKU2lnbmVkLW9mZi1ieTogQW5zc2kgSGFu
bnVsYSA8YW5zc2kuaGFubnVsYUBnbWFpbC5jb20+CgotLS0KCmRpZmYgLXIgNmZkZmIyYjIyMjQx
IC1yIDVkYzU0NDc2MGJlNiBsaW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItY29yZS9kdmJfZnJv
bnRlbmQuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItY29yZS9kdmJfZnJvbnRl
bmQuYwlGcmkgTWF5IDIzIDE3OjE3OjAyIDIwMDggKzAzMDAKKysrIGIvbGludXgvZHJpdmVycy9t
ZWRpYS9kdmIvZHZiLWNvcmUvZHZiX2Zyb250ZW5kLmMJRnJpIE1heSAyMyAxNzoyNTo1OSAyMDA4
ICswMzAwCkBAIC0zNTQsNyArMzU0LDcgQEAKIAlyZXR1cm4gMDsKIH0KIAotaW50IG5ld2FwaV90
b19vbGRkcnYoc3RydWN0IGR2YmZlX3BhcmFtcyAqcGFyYW1zLAoraW50IG5ld2FwaV90b19vbGRh
cGkoc3RydWN0IGR2YmZlX3BhcmFtcyAqcGFyYW1zLAogCQkgICAgIHN0cnVjdCBkdmJfZnJvbnRl
bmRfcGFyYW1ldGVycyAqcCwKIAkJICAgICBlbnVtIGR2YmZlX2RlbHN5cyBkZWxzeXMpCiB7CkBA
IC00NjYsNyArNDY2LDcgQEAKIAlyZXR1cm4gMDsKIH0KIAotaW50IG9sZGRydl90b19uZXdhcGko
c3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsCitpbnQgb2xkYXBpX3RvX25ld2FwaShzdHJ1Y3QgZHZi
X2Zyb250ZW5kICpmZSwKIAkJICAgICBzdHJ1Y3QgZHZiZmVfcGFyYW1zICpwYXJhbXMsCiAJCSAg
ICAgc3RydWN0IGR2Yl9mcm9udGVuZF9wYXJhbWV0ZXJzICpwLAogCQkgICAgIGVudW0gZmVfdHlw
ZSBmZV90eXBlKQpAQCAtMTY0OSw2ICsxNjQ5LDkgQEAKIAkJbWVtc2V0KCZmZXR1bmVzZXR0aW5n
cywgMCwgc2l6ZW9mKHN0cnVjdCBkdmJfZnJvbnRlbmRfdHVuZV9zZXR0aW5ncykpOwogCQltZW1j
cHkoJmZldHVuZXNldHRpbmdzLnBhcmFtZXRlcnMsIHBhcmcsIHNpemVvZiAoc3RydWN0IGR2Yl9m
cm9udGVuZF9wYXJhbWV0ZXJzKSk7CiAKKwkJLyogUmVxdWVzdCB0aGUgc2VhcmNoIGFsZ29yaXRo
bSB0byBzZWFyY2ggKi8KKwkJZmVwcml2LT5hbGdvX3N0YXR1cyB8PSBEVkJGRV9BTEdPX1NFQVJD
SF9BR0FJTjsKKwogCQkvKiBmb3JjZSBhdXRvIGZyZXF1ZW5jeSBpbnZlcnNpb24gaWYgcmVxdWVz
dGVkICovCiAJCWlmIChkdmJfZm9yY2VfYXV0b19pbnZlcnNpb24pIHsKIAkJCWZlcHJpdi0+cGFy
YW1ldGVycy5pbnZlcnNpb24gPSBJTlZFUlNJT05fQVVUTzsKQEAgLTE2OTcsNiArMTcwMCwyNyBA
QAogCQlpZiAoZHZiX292ZXJyaWRlX3R1bmVfZGVsYXkgPiAwKQogCQkJZmVwcml2LT5taW5fZGVs
YXkgPSAoZHZiX292ZXJyaWRlX3R1bmVfZGVsYXkgKiBIWikgLyAxMDAwOwogCisJCWlmIChvbGRh
cGlfdG9fbmV3YXBpKGZlLCAmZmVwcml2LT5mZV9wYXJhbXMsICZmZXByaXYtPnBhcmFtZXRlcnMs
IGZlLT5vcHMuaW5mby50eXBlKSA9PSAtRUlOVkFMKQorCQkJcHJpbnRrKCIlczogRVJST1IgISEh
IENvbnZlcnRpbmcgT2xkIHBhcmFtZXRlcnMgLS0+IE5ldyBwYXJhbWV0ZXJzXG4iLCBfX2Z1bmNf
Xyk7CisKKwkJLyogc2V0IGRlbGl2ZXJ5IHN5c3RlbSB0byB0aGUgZGVmYXVsdCBvbGQtQVBJIG9u
ZSAqLworCQlpZiAoZmUtPm9wcy5zZXRfZGVsc3lzKSB7CisJCQlzd2l0Y2goZmUtPm9wcy5pbmZv
LnR5cGUpIHsKKwkJCWNhc2UgRkVfUVBTSzoKKwkJCQlmZS0+b3BzLnNldF9kZWxzeXMoZmUsIERW
QkZFX0RFTFNZU19EVkJTKTsKKwkJCQlmZS0+b3BzLnNldF9kZWxzeXMoZmUsIERWQkZFX0RFTFNZ
U19EVkJTKTsKKwkJCWNhc2UgRkVfUUFNOgorCQkJCWZlLT5vcHMuc2V0X2RlbHN5cyhmZSwgRFZC
RkVfREVMU1lTX0RWQkMpOworCQkJCWJyZWFrOworCQkJY2FzZSBGRV9PRkRNOgorCQkJCWZlLT5v
cHMuc2V0X2RlbHN5cyhmZSwgRFZCRkVfREVMU1lTX0RWQlQpOworCQkJCWJyZWFrOworCQkJY2Fz
ZSBGRV9BVFNDOgorCQkJCWZlLT5vcHMuc2V0X2RlbHN5cyhmZSwgRFZCRkVfREVMU1lTX0FUU0Mp
OworCQkJCWJyZWFrOworCQkJfQorCQl9CisKIAkJZmVwcml2LT5zdGF0ZSA9IEZFU1RBVEVfUkVU
VU5FOwogCQlkdmJfZnJvbnRlbmRfd2FrZXVwKGZlKTsKIAkJZHZiX2Zyb250ZW5kX2FkZF9ldmVu
dChmZSwgMCk7CkBAIC0xNzIwLDYgKzE3NDQsMTMgQEAKIAkJaWYgKGZlLT5vcHMuZ2V0X2Zyb250
ZW5kKSB7CiAJCQltZW1jcHkgKHBhcmcsICZmZXByaXYtPnBhcmFtZXRlcnMsIHNpemVvZiAoc3Ry
dWN0IGR2Yl9mcm9udGVuZF9wYXJhbWV0ZXJzKSk7CiAJCQllcnIgPSBmZS0+b3BzLmdldF9mcm9u
dGVuZChmZSwgKHN0cnVjdCBkdmJfZnJvbnRlbmRfcGFyYW1ldGVycyopIHBhcmcpOworCQl9IGVs
c2UgaWYgKGZlLT5vcHMuZ2V0X3BhcmFtcykgeworCQkJZXJyID0gZmUtPm9wcy5nZXRfcGFyYW1z
KGZlLCAmZmVwcml2LT5mZV9wYXJhbXMpOworCQkJaWYgKCFlcnIpIHsKKwkJCQlpZiAobmV3YXBp
X3RvX29sZGFwaSgmZmVwcml2LT5mZV9wYXJhbXMsICZmZXByaXYtPnBhcmFtZXRlcnMsIGZlcHJp
di0+ZGVsc3lzKSAgPT0gLUVJTlZBTCkKKwkJCQkJcHJpbnRrKCIlczogRVJST1IgISEhIENvbnZl
cnRpbmcgTmV3IHBhcmFtZXRlcnMgLS0+IE9sZCBwYXJhbWV0ZXJzXG4iLCBfX2Z1bmNfXyk7CisJ
CQkJbWVtY3B5KHBhcmcsICZmZXByaXYtPnBhcmFtZXRlcnMsIHNpemVvZiAoc3RydWN0IGR2Yl9m
cm9udGVuZF9wYXJhbWV0ZXJzKSk7CisJCQl9CiAJCX0KIAkJYnJlYWs7CiAKQEAgLTE3NTEsNyAr
MTc4Miw3IEBACiAJCSAgICAoZGVsc3lzICYgRFZCRkVfREVMU1lTX0RWQlQpIHx8CiAJCSAgICAo
ZGVsc3lzICYgRFZCRkVfREVMU1lTX0FUU0MpKSB7CiAKLQkJCWlmIChuZXdhcGlfdG9fb2xkZHJ2
KCZmZXByaXYtPmZlX3BhcmFtcywgJmZlcHJpdi0+cGFyYW1ldGVycywgZmVwcml2LT5kZWxzeXMp
ICA9PSAtRUlOVkFMKQorCQkJaWYgKG5ld2FwaV90b19vbGRhcGkoJmZlcHJpdi0+ZmVfcGFyYW1z
LCAmZmVwcml2LT5wYXJhbWV0ZXJzLCBmZXByaXYtPmRlbHN5cykgID09IC1FSU5WQUwpCiAJCQkJ
cHJpbnRrKCIlczogRVJST1IgISEhIENvbnZlcnRpbmcgTmV3IHBhcmFtZXRlcnMgLS0+IE9sZCBw
YXJhbWV0ZXJzXG4iLCBfX2Z1bmNfXyk7CiAJCX0KIAkJLyogUmVxdWVzdCB0aGUgc2VhcmNoIGFs
Z29yaXRobSB0byBzZWFyY2gJKi8KQEAgLTE4NDEsNyArMTg3Miw3IEBACiAJCX0gZWxzZSBpZiAo
ZmUtPm9wcy5nZXRfZnJvbnRlbmQpIHsKIAkJCWVyciA9IGZlLT5vcHMuZ2V0X2Zyb250ZW5kKGZl
LCAmZmVwcml2LT5wYXJhbWV0ZXJzKTsKIAkJCWlmICghZXJyKSB7Ci0JCQkJaWYgKG9sZGRydl90
b19uZXdhcGkoZmUsICZmZXByaXYtPmZlX3BhcmFtcywgJmZlcHJpdi0+cGFyYW1ldGVycywgZmUt
Pm9wcy5pbmZvLnR5cGUpID09IC1FSU5WQUwpCisJCQkJaWYgKG9sZGFwaV90b19uZXdhcGkoZmUs
ICZmZXByaXYtPmZlX3BhcmFtcywgJmZlcHJpdi0+cGFyYW1ldGVycywgZmUtPm9wcy5pbmZvLnR5
cGUpID09IC1FSU5WQUwpCiAJCQkJCXByaW50aygiJXM6IEVSUk9SICEhISBDb252ZXJ0aW5nIE9s
ZCBwYXJhbWV0ZXJzIC0tPiBOZXcgcGFyYW1ldGVyc1xuIiwgX19mdW5jX18pOwogCQkJCW1lbWNw
eShwYXJnLCAmZmVwcml2LT5mZV9wYXJhbXMsIHNpemVvZiAoc3RydWN0IGR2YmZlX3BhcmFtcykp
OwogCQkJfQpkaWZmIC1yIDZmZGZiMmIyMjI0MSAtciA1ZGM1NDQ3NjBiZTYgbGludXgvZHJpdmVy
cy9tZWRpYS9kdmIvZnJvbnRlbmRzL3N0YjA4OTlfZHJ2LmMKLS0tIGEvbGludXgvZHJpdmVycy9t
ZWRpYS9kdmIvZnJvbnRlbmRzL3N0YjA4OTlfZHJ2LmMJRnJpIE1heSAyMyAxNzoxNzowMiAyMDA4
ICswMzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zdGIwODk5X2Ry
di5jCUZyaSBNYXkgMjMgMTc6MjU6NTkgMjAwOCArMDMwMApAQCAtMjAzNiw2ICsyMDM2LDcgQEAK
IAogCS5pbmZvID0gewogCQkubmFtZQkJCT0gIlNUQjA4OTkgTXVsdGlzdGFuZGFyZCIsCisJCS50
eXBlCQkJPSBGRV9RUFNLLCAvKiB3aXRoIG9sZCBBUEkgKi8KIAl9LAogCiAJLnJlbGVhc2UJCQk9
IHN0YjA4OTlfcmVsZWFzZSwK
------=_Part_11605_25690486.1212926517467
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_11605_25690486.1212926517467--

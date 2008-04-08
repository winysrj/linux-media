Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zdenek.kabelac@gmail.com>) id 1JjNEO-0000Ji-JK
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 01:28:01 +0200
Received: by wr-out-0506.google.com with SMTP id c30so1990623wra.14
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 16:27:49 -0700 (PDT)
Message-ID: <c4e36d110804081627s21cc5683l886e2a4a8782cd59@mail.gmail.com>
Date: Wed, 9 Apr 2008 01:27:48 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47FAFDDA.4050109@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2972_6843995.1207697268358"
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>
	<47FA3A7A.3010002@iki.fi> <47FAFDDA.4050109@iki.fi>
Cc: linux-dvb@linuxtv.org, Benoit Paquin <benoitpaquindk@gmail.com>
Subject: Re: [linux-dvb] USB 1.1 support for AF9015 DVB-T tuner
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

------=_Part_2972_6843995.1207697268358
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Antti

2008/4/8, Antti Palosaari <crope@iki.fi>:
> Antti Palosaari wrote:
>  > Benoit Paquin wrote:
>  >> Antti,
>
> >> Can you explain this? It would be neat if it worked with USB 1.1. There
>  >> are several old laptops around that could be used as digital video
>  >> recorder. The main stream vendors (Pinnacle, Hauppauge and ASUS) do not
>  >> support USB 1.1.
>  >
>  > AF9015 chipset does support USB1.1 but driver not. I haven't see this
>  > important enough to implement yet... It is rather easy to implement,
>  > lets see if I get inspirations soon ;)
>
>
> Implemented now.
>


As it looks like my AverTV Hybrid Volar HX is a little bit of no use
for quite some time -
and your afatech driver seems to helpfull to many other users - maybe you could
try to make it help for me as well ??

What do I need to do ?

I've got somewhere some old   dvb-usb-af9015.fw size:15913  md5:
dccbc92c9168cc629a88b34ee67ede7b
(Unsure where do I get the latest one ?))

Then I have added patch (see attachment) to enable usage of your
af9015 driver with my USB stick.

And then I get this dmesg error (with debug=63)

[40667.159908] af9015_usb_probe: interface:0
[40667.159915] >>> 10 00 38 00 00 00 00 01
[40667.159924] af9015: af9015_rw_udev: sending failed: -22 (8/-32512)
[40668.152369] af9015: af9015_rw_udev: receiving failed: -110
[40668.152382] dvb-usb: found a 'AverMedia AverTV Hybrid Volar HX' in
cold state, will try to load a firmware
[40668.166309] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[40668.166323] af9015_download_firmware:
[40668.166328] >>> 11 01 38 51 00 00 00 37 02 52 00 04 5f 00 00 02 89
52 02 89 56 02 89 5a 02 89 5e 02 89 62 02 89 66 02 89 6a 02 8a 44 02
8a 48 02 8a 4c 02 8a 50 02 8a 54 02 8a 58 02 86 aa 02 68 2d 02 8d 50
[40668.166516] af9015: af9015_rw_udev: sending failed: -22 (63/-1)
[40668.166521] >>> 11 02 38 51 37 00 00 37 02 8e 48 02 8e 4c 02 8e 75
02 7d 2e 02 7d 5c 02 7d 8a 02 7d a7 02 8e 79 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[40668.166710] af9015: af9015_rw_udev: sending failed: -22 (63/-1)
... skip ...
[40668.206928] >>> 11 21 38 8e e0 00 00 37 03 04 05 06 07 06 03 0a 01
00 01 01 02 01 03 03 06 01 01 01 01 3e 80 06 40 7d 00 12 c0 0c 80 0c
80 fa 00 12 c0 0c 80 bb 80 64 00 00 a0 00 00 01 02 01 02 02 02 01 02
[40668.207027] af9015: af9015_rw_udev: sending failed: -22 (63/-1)
[40668.207031] >>> 11 22 38 8f 17 00 00 12 01 01 02 39 18 fe 04 ee 0e
aa 10 d5 14 c9 13 0d 08 fb
[40668.207076] af9015: af9015_rw_udev: sending failed: -22 (26/-1)
[40668.207080] >>> 13 23 38 8f 17 00 00 12
[40668.207097] af9015: af9015_rw_udev: sending failed: -22 (8/-1)
[40834.069145] af9015: af9015_rw_udev: receiving failed: -110
[40834.069161] af9015: af9015_download_firmware: boot failed: -110
[40834.069231] dvb_usb_af9015: probe of 2-2:1.0 failed with error -110
[40834.069367] usbcore: registered new interface driver dvb_usb_af9015


So this doesn't look like a usable for now - is there any chance this
will ever work ?

Thanks

Zdenek

------=_Part_2972_6843995.1207697268358
Content-Type: application/octet-stream; name=patch1
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fet3qy76
Content-Disposition: attachment; filename=patch1

ZGlmZiAtcnVOIGFmOTAxNS1vcmlnL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvYWY5
MDE1LmMgYWY5MDE1LTZkNWU1YTZjNTI4MS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNi
L2FmOTAxNS5jCi0tLSBhZjkwMTUtb3JpZy9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNi
L2FmOTAxNS5jCTIwMDgtMDQtMDggMDQ6MjI6MjguMDAwMDAwMDAwICswMjAwCisrKyBhZjkwMTUt
NmQ1ZTVhNmM1MjgxL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvYWY5MDE1LmMJMjAw
OC0wNC0wOSAwMToxNTowNy4wMDAwMDAwMDAgKzAyMDAKQEAgLTg2Miw2ICs4NjIsOCBAQAogCXtV
U0JfREVWSUNFKFVTQl9WSURfVklTSU9OUExVUywgMHgzMjM3KX0sCiAJLyogVGVycmFUZWMgQ2lu
ZXJneSBUIFVTQiBYRSAoUmV2LiAyKSAqLwogCXtVU0JfREVWSUNFKFVTQl9WSURfVEVSUkFURUMs
ICAgMHgwMDY5KX0sCisJLyogQXZlck1lZGlhIFZvbGFyIEhYICovCisJe1VTQl9ERVZJQ0UoVVNC
X1ZJRF9BVkVSTUVESUEsIFVTQl9QSURfQVZFUk1FRElBX1ZPTEFSIHwgMHgyMCl9LAogCXswfSwK
IH07CiBNT0RVTEVfREVWSUNFX1RBQkxFKHVzYiwgYWY5MDE1X3VzYl90YWJsZSk7CkBAIC05MDcs
NyArOTA5LDcgQEAKIAkJCX0sCiAJCX0KIAl9LAotCS5udW1fZGV2aWNlX2Rlc2NzID0gNywKKwku
bnVtX2RldmljZV9kZXNjcyA9IDgsCiAJLmRldmljZXMgPSB7CiAJCXsKIAkJCS5uYW1lID0gIkFm
YXRlY2ggQUY5MDE1IERWQi1UIFVTQjIuMCBzdGljayIsCkBAIC05NDUsNiArOTQ3LDExIEBACiAJ
CQkuY29sZF9pZHMgPSB7JmFmOTAxNV91c2JfdGFibGVbN10sIE5VTEx9LAogCQkJLndhcm1faWRz
ID0ge05VTEx9LAogCQl9LAorCQl7CisJCQkubmFtZSA9ICJBdmVyTWVkaWEgQVZlclRWIEh5YnJp
ZCBWb2xhciBIWCIsCisJCQkuY29sZF9pZHMgPSB7JmFmOTAxNV91c2JfdGFibGVbOF0sIE5VTEx9
LAorCQkJLndhcm1faWRzID0ge05VTEx9LAorCQl9LAogCQl7TlVMTH0sCiAJfQogfTsK
------=_Part_2972_6843995.1207697268358
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_2972_6843995.1207697268358--

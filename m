Return-path: <mchehab@pedra>
Received: from nm14-vm0.bullet.mail.ird.yahoo.com ([77.238.189.193]:27498 "HELO
	nm14-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751682Ab1C2Ney (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 09:34:54 -0400
Message-ID: <212680.72169.qm@web29506.mail.ird.yahoo.com>
References: <601699.85761.qm@web29505.mail.ird.yahoo.com> <1301168432.2338.19.camel@localhost>
Date: Tue, 29 Mar 2011 14:34:51 +0100 (BST)
From: Emil Meier <emil276me@yahoo.com>
Subject: Re: Analog input for Hauppauge express-card HVR-1400
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1301168432.2338.19.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-213100320-1301405691=:72169"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--0-213100320-1301405691=:72169
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>----- Original Message ----=0A=0A>On Tue, 2011-03-22 at 19:57 +0000, Emil =
Meier wrote:=0A>> The patch in cx25840-core.c was needed to get PAL support=
 for the video input. =0A>=0A>> If the line=0A>> cx25840_write(client, 0x2,=
 0x76);=0A>> is needed by other cards,=0A=0A> You patches have a problem:=
=0A=0A> Your first patch modifies a card entry in the cx23885 driver, but y=
our=0A> second patch changes the cx231xx_initialize() function in=0A> cx258=
40-core.c. =0A=0A>http://git.linuxtv.org/media_tree.git?a=3Dblob;f=3Ddriver=
s/media/video/cx25840/cx25840-core.c;h=3D35796e0352475b6536bfd47315107e418e=
6716fa;hb=3Drefs/heads/staging/for_v2.6.39#l638=0A>8=0A=0A> The second patc=
h should have no effect on the operation of a CX2388[578]=0A> based card.=
=0A=0A=0AThanks Andy,=0Ayour are right, the patch is applied in the wrong f=
unction. In earlyer kernels, =0AI have placed the patch in cx23885_initiali=
ze()...=0AChecking this again I found the patch not working in 2.6.36.4 van=
illa...The =0Apatches are working in 2.6.35.11 vanilla. But there are a lot=
 af changes between =0A2.6.35.11 and 2.6.36.4  in the code.=0AI have attach=
ed the patches against 2.6.35.11 vanilla. The last time I have =0Atried the=
 dvb-drivers, they don't compile against older kenrels...=0AWith 2.6.36.4 a=
nd the last patch I get the following error:=0A=0A2.6.36.4:=0Acx23885[1]: h=
auppauge eeprom: model=3D80019=0Acx25840 2-0044: cx23885 A/V decoder found =
@ 0x88 (cx23885[1])=0Acx25840: probe of 2-0044 failed with error -34=0Atune=
r 1-0061: chip found @ 0xc2 (cx23885[1])=0Axc2028 1-0061: creating new inst=
ance=0Axc2028 1-0061: type set to XCeive xc2028/xc3028 tuner=0A....=0Awhile=
 grabbing:=0Axc2028 1-0061: xc2028/3028 firmware name not set!=0Acx23885[1]=
: VID A - dma channel status dump=0Acx23885[1]:   cmds: init risc lo   : 0x=
37c70000=0Acx23885[1]:   cmds: init risc hi   : 0x00000000=0Acx23885[1]:   =
cmds: cdt base       : 0x000104c0=0Acx23885[1]:   cmds: cdt size       : 0x=
0000000c=0Acx23885[1]:   cmds: iq base        : 0x00010380=0Acx23885[1]:   =
cmds: iq size        : 0x00000010=0Acx23885[1]:   cmds: risc pc lo     : 0x=
37c70034=0Acx23885[1]:   cmds: risc pc hi     : 0x00000000=0Acx23885[1]:   =
cmds: iq wr ptr      : 0x000040ed=0Acx23885[1]:   cmds: iq rd ptr      : 0x=
000040e1=0Acx23885[1]:   cmds: cdt current    : 0x000104c8=0Acx23885[1]:   =
cmds: pci target lo  : 0x00000000=0Acx23885[1]:   cmds: pci target hi  : 0x=
00000000=0Acx23885[1]:   cmds: line / byte    : 0x00000000=0Acx23885[1]:   =
risc0: 0x80008000 [ sync resync count=3D0 ]=0Acx23885[1]:   risc1: 0x1c0005=
00 [ write sol eol count=3D1280 ]=0Acx23885[1]:   risc2: 0x37cb7500 [ INVAL=
ID eol irq2 irq1 23 22 19 cnt1 cnt0 14 13=0A =0A=0A=0Ainstead of: 2.6.35.11=
:=0Acx23885[2]: hauppauge eeprom: model=3D80019=0Acx25840 2-0044: cx23885 A=
/V decoder found @ 0x88 (cx23885[2])=0Acx25840 2-0044: loaded v4l-cx23885-a=
vcore-01.fw firmware (16382 bytes)=0Atuner 1-0061: chip found @ 0xc2 (cx238=
85[2])=0Axc2028 1-0061: creating new instance=0A=0AEmil
--0-213100320-1301405691=:72169
Content-Type: text/x-patch; name="patch-cx23885-cards.c.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch-cx23885-cards.c.diff"

KioqIGxpbnV4LTIuNi4zNS4xMS9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4
ODUvY3gyMzg4NS1jYXJkcy5jCTIwMTEtMDItMDYgMjA6MDQ6MDcuMDAwMDAw
MDAwICswMTAwCi0tLSAvdXNyL3NyYy9saW51eC0yLjYuMzUuMTEvZHJpdmVy
cy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtY2FyZHMuYwkyMDExLTAz
LTI5IDE0OjI5OjI0LjAwMDAwMDAwMCArMDIwMAoqKioqKioqKioqKioqKioK
KioqIDE0NCwxNTAgKioqKgotLS0gMTQ0LDE3MyAtLS0tCiAgCX0sCiAgCVtD
WDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxNDAwXSA9IHsKICAJCS5uYW1l
CQk9ICJIYXVwcGF1Z2UgV2luVFYtSFZSMTQwMCIsCisgCQkucG9ydGEgICAg
ICAgICAgPSBDWDIzODg1X0FOQUxPR19WSURFTywKICAJCS5wb3J0YwkJPSBD
WDIzODg1X01QRUdfRFZCLAorIAkJLnR1bmVyX3R5cGUJPSBUVU5FUl9YQzIw
MjgsCisgCQkudHVuZXJfYWRkcgk9IDB4NjEsIC8qIDB4ODQgPj4gMSAqLwor
IAkJLmlucHV0ICAgICAgICAgID0ge3sKKyAJCSAgICAgLnR5cGUgICA9IENY
MjM4ODVfVk1VWF9URUxFVklTSU9OLAorIAkJICAgICAudm11eCAgID0gICAg
ICAgQ1gyNTg0MF9WSU43X0NIMyB8CisgCQkgICAgIENYMjU4NDBfVklONV9D
SDIgfAorIAkJICAgICBDWDI1ODQwX1ZJTjJfQ0gxLAorIAkJICAgICAuZ3Bp
bzAgID0gMCwKKyAJCSAgIH0sIHsKKyAJCSAgICAgLnR5cGUgICA9IENYMjM4
ODVfVk1VWF9DT01QT1NJVEUxLAorIAkJICAgICAudm11eCAgID0gICAgICAg
Q1gyNTg0MF9WSU43X0NIMyB8CisgCQkgICAgIENYMjU4NDBfVklONF9DSDIg
fAorIAkJICAgICBDWDI1ODQwX1ZJTjZfQ0gxLAorIAkJICAgICAuZ3BpbzAg
ID0gMCwKKyAJCSAgIH0sIHsKKyAJCSAgICAgLnR5cGUgICA9IENYMjM4ODVf
Vk1VWF9TVklERU8sCisgCQkgICAgIC52bXV4ICAgPSAgICAgICBDWDI1ODQw
X1ZJTjdfQ0gzIHwKKyAJCSAgICAgQ1gyNTg0MF9WSU40X0NIMiB8CisgCQkg
ICAgIENYMjU4NDBfVklOOF9DSDEgfAorIAkJICAgICBDWDI1ODQwX1NWSURF
T19PTiwKKyAJCSAgICAgLmdwaW8wICA9IDAsCisgCSAgICAgICAJICAgfSB9
LAogIAl9LAogIAlbQ1gyMzg4NV9CT0FSRF9EVklDT19GVVNJT05IRFRWXzdf
RFVBTF9FWFBdID0gewogIAkJLm5hbWUJCT0gIkRWaUNPIEZ1c2lvbkhEVFY3
IER1YWwgRXhwcmVzcyIsCioqKioqKioqKioqKioqKgoqKiogMTEwMiwxMTA3
ICoqKioKLS0tIDExMjUsMTEzMSAtLS0tCiAgCWNhc2UgQ1gyMzg4NV9CT0FS
RF9MRUFEVEVLX1dJTkZBU1RfUFhEVlIzMjAwX0g6CiAgCWNhc2UgQ1gyMzg4
NV9CT0FSRF9DT01QUk9fVklERU9NQVRFX0U2NTBGOgogIAljYXNlIENYMjM4
ODVfQk9BUkRfTkVUVVBfRFVBTF9EVkJTMl9DSToKKyAJY2FzZSBDWDIzODg1
X0JPQVJEX0hBVVBQQVVHRV9IVlIxNDAwOgogIAljYXNlIENYMjM4ODVfQk9B
UkRfQ09NUFJPX1ZJREVPTUFURV9FODAwOgogIAljYXNlIENYMjM4ODVfQk9B
UkRfSEFVUFBBVUdFX0hWUjE4NTA6CiAgCWNhc2UgQ1gyMzg4NV9CT0FSRF9N
WUdJQ0FfWDg1MDY6Cg==

--0-213100320-1301405691=:72169
Content-Type: text/x-patch; name="patch-cx25840-core.c.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch-cx25840-core.c.diff"

KioqIGxpbnV4LTIuNi4zNS4xMS9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjU4
NDAvY3gyNTg0MC1jb3JlLmMJMjAxMS0wMi0wNiAyMDowNDowNy4wMDAwMDAw
MDAgKzAxMDAKLS0tIC91c3Ivc3JjL2xpbnV4LTIuNi4zNS4xMS9kcml2ZXJz
L21lZGlhL3ZpZGVvL2N4MjU4NDAvY3gyNTg0MC1jb3JlLmMJMjAxMS0wMy0y
OSAxNDo1MDowMS4wMDAwMDAwMDAgKzAyMDAKKioqKioqKioqKioqKioqCioq
KiAyODIsMjg4ICoqKioKICAJICogJzg4NzogMjUuMDAwMDAwIE1IegogIAkg
KiAnODg4OiA1MC4wMDAwMDAgTUh6CiAgCSAqLwohIAljeDI1ODQwX3dyaXRl
KGNsaWVudCwgMHgyLCAweDc2KTsKICAKICAJLyogUG93ZXIgdXAgYWxsIHRo
ZSBQTEwncyBhbmQgRExMICovCiAgCWN4MjU4NDBfd3JpdGUoY2xpZW50LCAw
eDEsIDB4NDApOwotLS0gMjgyLDI5MCAtLS0tCiAgCSAqICc4ODc6IDI1LjAw
MDAwMCBNSHoKICAJICogJzg4ODogNTAuMDAwMDAwIE1IegogIAkgKi8KISAJ
LyogVGhpcyBjaGFuZ2VzIGZvciB0aGUgY3gyMzg4OCBwcm9kdWN0cyAqLwoh
IAkvLyBub3QgZm9yIGh2cjE0MDAgZW0gMDkwODE4CiEgCS8vY3gyNTg0MF93
cml0ZShjbGllbnQsIDB4MiwgMHg3Nik7CiAgCiAgCS8qIFBvd2VyIHVwIGFs
bCB0aGUgUExMJ3MgYW5kIERMTCAqLwogIAljeDI1ODQwX3dyaXRlKGNsaWVu
dCwgMHgxLCAweDQwKTsK

--0-213100320-1301405691=:72169--

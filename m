Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:61934 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab0AEUMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 15:12:01 -0500
Received: by fxm25 with SMTP id 25so10157913fxm.21
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2010 12:12:00 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 5 Jan 2010 21:11:59 +0100
Message-ID: <d49708701001051211r447f6293g59dfac2b1af2818c@mail.gmail.com>
Subject: WinTV Radio rev-c121 remote support
From: =?ISO-8859-2?Q?Samuel_Rakitni=E8an?= <samuel.rakitnican@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001485f3b90e51a0f9047c7073ee
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001485f3b90e51a0f9047c7073ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I have an old bt878 based analog card. It's 'Hauppauge WinTV Radio' model 4=
4914,
rev C121.

I'm trying to workout support for this shipped remote control. I have
tried to add
following lines to bttv-cards.c and bttv-input.c, but that gived
really bad results
(dmesg output is in attachment).


diff -r b6b82258cf5e linux/drivers/media/video/bt8xx/bttv-cards.c
--- a/linux/drivers/media/video/bt8xx/bttv-cards.c=A0=A0=A0=A0=A0 Thu Dec 3=
1 19:14:54 2009
-0200
+++ b/linux/drivers/media/video/bt8xx/bttv-cards.c=A0=A0=A0=A0=A0 Tue Jan 0=
5 13:25:09 2010
+0100
@@ -491,6 +491,7 @@
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .pll=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 =3D PLL_28,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .tuner_type=A0=A0=A0=A0 =3D U=
NSET,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .tuner_addr=A0=A0=A0=A0 =3D A=
DDR_UNSET,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .has_remote=A0=A0=A0=A0 =3D 1,
=A0=A0=A0=A0=A0=A0=A0 },
=A0=A0=A0=A0=A0=A0=A0 [BTTV_BOARD_MIROPRO] =3D {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 .name=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D "MIRO PCTV pro",
diff -r b6b82258cf5e linux/drivers/media/video/bt8xx/bttv-input.c
--- a/linux/drivers/media/video/bt8xx/bttv-input.c=A0=A0=A0=A0=A0 Thu Dec 3=
1 19:14:54 2009
-0200
+++ b/linux/drivers/media/video/bt8xx/bttv-input.c=A0=A0=A0=A0=A0 Tue Jan 0=
5 13:25:09 2010
+0100
@@ -341,6 +341,12 @@
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ir->last_gpio=A0=A0=A0 =3D ir=
_extract_bits(bttv_gpio_read(&btv->c),
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 ir->mask_keycode);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0 case BTTV_BOARD_HAUPPAUGE878:
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ir_codes=A0=A0=A0=A0=A0=A0=A0=
=A0 =3D &ir_codes_pctv_sedna_table;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ir->mask_keycode =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ir->mask_keyup=A0=A0 =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 //ir->polling=A0=A0=A0=A0=A0 =
=3D 50;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 if (NULL =3D=3D ir_codes) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dprintk(KERN_INFO "Ooops: IR =
config error [card=3D%d]\n",
btv->c.type);



root@crni:~/v4l-dvb# modprobe bttv
Segmentation fault
root@crni:~/v4l-dvb#
Message from syslogd@crni at Tue Jan=A0 5 13:03:08 2010 ...
crni kernel: Oops: 0000 [#1] SMP

=A0[...]




So I guess that's not going to work. I have read in
wiki that Hauppauge cards needs ir-kbd-i2c, so I tried with that too, but
then similar error like previous happens when I try 'modprobe ir-kbd-i2c de=
bug=3D1
hauppauge=3D1' as well as just 'modprobe ir-kbd-i2c'.

Can I have a little pointer what to do?

Regards,
Samuel
--
Card: http://linuxtv.org/wiki/index.php/File:Wintv-radio-C121.jpg
Remote: http://linuxtv.org/wiki/index.php/File:Wintv-radio-remote.jpg

--001485f3b90e51a0f9047c7073ee
Content-Type: application/octet-stream; name=ir-dmesg
Content-Disposition: attachment; filename=ir-dmesg
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4346q480

YnR0djogZHJpdmVyIHZlcnNpb24gMC45LjE4IGxvYWRlZApidHR2OiB1c2luZyA4IGJ1ZmZlcnMg
d2l0aCAyMDgwayAoNTIwIHBhZ2VzKSBlYWNoIGZvciBjYXB0dXJlCmJ0dHY6IEJ0OHh4IGNhcmQg
Zm91bmQgKDApLgpidHR2MDogQnQ4NzggKHJldiAxNykgYXQgMDAwMDowMDowYS4wLCBpcnE6IDE4
LCBsYXRlbmN5OiAzMiwgbW1pbzogMHhkZmRmZTAwMApidHR2MDogZGV0ZWN0ZWQ6IEhhdXBwYXVn
ZSBXaW5UViBbY2FyZD0xMF0sIFBDSSBzdWJzeXN0ZW0gSUQgaXMgMDA3MDoxM2ViCmJ0dHYwOiB1
c2luZzogSGF1cHBhdWdlIChidDg3OCkgW2NhcmQ9MTAsYXV0b2RldGVjdGVkXQpJUlEgMTgvYnR0
djA6IElSUUZfRElTQUJMRUQgaXMgbm90IGd1YXJhbnRlZWQgb24gc2hhcmVkIElSUXMKYnR0djA6
IGdwaW86IGVuPTAwMDAwMDAwLCBvdXQ9MDAwMDAwMDAgaW49MDBmZmZmZGIgW2luaXRdCmJ0dHYw
OiBIYXVwcGF1Z2UvVm9vZG9vIG1zcDM0eHg6IHJlc2V0IGxpbmUgaW5pdCBbNV0KdHZlZXByb20g
MS0wMDUwOiBIYXVwcGF1Z2UgbW9kZWwgNDQ5MTQsIHJldiBDMTIxLCBzZXJpYWwjIDM5NTk5MDYK
dHZlZXByb20gMS0wMDUwOiB0dW5lciBtb2RlbCBpcyBQaGlsaXBzIEZNMTIxNiAoaWR4IDIxLCB0
eXBlIDUpCnR2ZWVwcm9tIDEtMDA1MDogVFYgc3RhbmRhcmRzIFBBTChCL0cpIChlZXByb20gMHgw
NCkKdHZlZXByb20gMS0wMDUwOiBhdWRpbyBwcm9jZXNzb3IgaXMgTm9uZSAoaWR4IDApCnR2ZWVw
cm9tIDEtMDA1MDogaGFzIHJhZGlvCmJ0dHYwOiBIYXVwcGF1Z2UgZWVwcm9tIGluZGljYXRlcyBt
b2RlbCM0NDkxNApidHR2MDogdHVuZXIgdHlwZT01CmJ0dHYwOiBhdWRpbyBhYnNlbnQsIG5vIGF1
ZGlvIGRldmljZSBmb3VuZCEKdHVuZXIgMS0wMDYxOiBjaGlwIGZvdW5kIEAgMHhjMiAoYnQ4Nzgg
IzAgW3N3XSkKdHVuZXItc2ltcGxlIDEtMDA2MTogY3JlYXRpbmcgbmV3IGluc3RhbmNlCnR1bmVy
LXNpbXBsZSAxLTAwNjE6IHR5cGUgc2V0IHRvIDUgKFBoaWxpcHMgUEFMX0JHIChGSTEyMTYgYW5k
IGNvbXBhdGlibGVzKSkKYnR0djA6IHJlZ2lzdGVyZWQgZGV2aWNlIHZpZGVvMApidHR2MDogcmVn
aXN0ZXJlZCBkZXZpY2UgdmJpMApidHR2MDogcmVnaXN0ZXJlZCBkZXZpY2UgcmFkaW8wCmJ0dHYw
OiBQTEw6IDI4NjM2MzYzID0+IDM1NDY4OTUwIC4gb2sKaW5wdXQ6IGJ0dHYgSVIgKGNhcmQ9MTAp
IGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDowYS4wL2lucHV0L2lucHV0NgpDcmVhdGlu
ZyBJUiBkZXZpY2UgaXJyY3YwCkJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJl
cXVlc3QgYXQgNzI3Mjc1NjMKSVA6IFs8YzAyMmU1YmY+XSBzdHJjbXArMHhmLzB4MzAKKnBkZSA9
IDAwMDAwMDAwIApPb3BzOiAwMDAwIFsjMV0gU01QIApsYXN0IHN5c2ZzIGZpbGU6IC9zeXMvZGV2
aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MGEuMC92aWRlbzRsaW51eC92aWRlbzAvaW5kZXgKTW9k
dWxlcyBsaW5rZWQgaW46IHR1bmVyX3NpbXBsZSB0dW5lcl90eXBlcyB0dW5lciB0dmF1ZGlvIHRk
YTc0MzIgbXNwMzQwMCBidHR2KCspIHY0bDJfY29tbW9uIHZpZGVvZGV2IHY0bDFfY29tcGF0IGly
X2NvbW1vbiB2aWRlb2J1Zl9kbWFfc2cgdmlkZW9idWZfY29yZSBidGN4X3Jpc2MgdHZlZXByb20g
aXJfY29yZSBpMmNfYWxnb19iaXQgc25kX3NlcV9kdW1teSBzbmRfc2VxX29zcyBzbmRfc2VxX21p
ZGlfZXZlbnQgc25kX3NlcSBzbmRfcGNtX29zcyBzbmRfbWl4ZXJfb3NzIGlwdjYgcGNtY2lhIHBj
bWNpYV9jb3JlIG5sc19pc284ODU5XzEgbmxzX2NwNDM3IHZmYXQgZmF0IGV4dDMgbHAgZnVzZSBw
cGRldiB1c2JoaWQgaGlkIHNuZF92aWE4Mnh4IHNuZF9hYzk3X2NvZGVjIGFjOTdfYnVzIHNuZF9t
cHU0MDFfdWFydCBmZ2xyeChQKSBzbmRfcmF3bWlkaSBuczU1OCBzbmRfc2VxX2RldmljZSBydGNf
Y21vcyBwYXJwb3J0X3BjIHJ0Y19jb3JlIHZpYV9hZ3Agc25kX3BjbSBzbmRfdGltZXIgaTJjX3Zp
YXBybyBldmRldiB0aGVybWFsIHZpYV9yaGluZSBwYXJwb3J0IGdhbWVwb3J0IHJ0Y19saWIgYWdw
Z2FydCBzaHBjaHAgc25kIHNuZF9wYWdlX2FsbG9jIGkyY19jb3JlIHVoY2lfaGNkIHNvdW5kY29y
ZSBlaGNpX2hjZCBtaWkgcHJvY2Vzc29yIHRoZXJtYWxfc3lzIGJ1dHRvbiBod21vbiBzZyBleHQ0
IGpiZDIgY3JjMTYgamJkIG1iY2FjaGUgW2xhc3QgdW5sb2FkZWQ6IHY0bDFfY29tcGF0XQoKUGlk
OiAxMjQzNCwgY29tbTogbW9kcHJvYmUgVGFpbnRlZDogUCAgICAgICAgICAgKDIuNi4yOS42LXNt
cCAjMSkgUDRWVDggICAKRUlQOiAwMDYwOls8YzAyMmU1YmY+XSBFRkxBR1M6IDAwMjEwMjg2IENQ
VTogMApFSVAgaXMgYXQgc3RyY21wKzB4Zi8weDMwCkVBWDogYzA0YzVjNzUgRUJYOiBmNjQ1M2Zj
MCBFQ1g6IGMwMWQ2ZDgwIEVEWDogNzI3Mjc1NjMKRVNJOiBjMDRjNWM2NSBFREk6IDcyNzI3NTYz
IEVCUDogZjY0NTNmOTAgRVNQOiBlY2Y1ZGNkNAogRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDgg
R1M6IDAwMzMgU1M6IDAwNjgKUHJvY2VzcyBtb2Rwcm9iZSAocGlkOiAxMjQzNCwgdGk9ZWNmNWMw
MDAgdGFzaz1lY2VhMGQwMCB0YXNrLnRpPWVjZjVjMDAwKQpTdGFjazoKIDcyNzI3NTYzIGVjZjVk
ZDI0IGMwMWQ3MDUxIGY4MzljZDI0IGY2NDUzZGIwIGMwMWQ3MWE0IGVjZjVkZDM0IGMwMWEwZjc5
CiBmNjQ1M2Y5MCBmODM5Y2QyNCBmNjQ1M2RiMCBmNjQ1M2RiMCBjMDFkNzI2MiBmNjQ1M2Y5MCAw
MDAwMzdjOSBmODM5Y2QyNAogZjgzOWNkMjQgZjgzOWNkMjQgZmZmZmZmZjQgYzAxZDZiNWMgZjY0
NTNmOTAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAKQ2FsbCBUcmFjZToKIFs8YzAxZDcwNTE+
XSBzeXNmc19maW5kX2RpcmVudCsweDIxLzB4MzAKIFs8YzAxZDcxYTQ+XSBfX3N5c2ZzX2FkZF9v
bmUrMHgxNC8weGMwCiBbPGMwMWEwZjc5Pl0gaWxvb2t1cDUrMHgzOS8weDUwCiBbPGMwMWQ3MjYy
Pl0gc3lzZnNfYWRkX29uZSsweDEyLzB4NTAKIFs8YzAxZDZiNWM+XSBzeXNmc19hZGRfZmlsZV9t
b2RlKzB4NGMvMHg5MAogWzxjMDFkOGE2OD5dIGludGVybmFsX2NyZWF0ZV9ncm91cCsweGQ4LzB4
MTkwCiBbPGY4MzljOTdiPl0gaXJfcmVnaXN0ZXJfY2xhc3MrMHg4Yi8weGQwIFtpcl9jb3JlXQog
WzxmODM5YzI2OD5dIGlyX2lucHV0X3JlZ2lzdGVyKzB4MWI4LzB4MjgwIFtpcl9jb3JlXQogWzxm
ODU1YTJkNz5dIHR1bmVyX3Nfc3RkKzB4ZDcvMHg4MTAgW3R1bmVyXQogWzxjMDIyODVjYT5dIGtv
YmplY3RfaW5pdCsweDJhLzB4YTAKIFs8Zjg3ZjdmZDY+XSBidHR2X2lucHV0X2luaXQrMHgyNDYv
MHg0YTAgW2J0dHZdCiBbPGY4N2Y5NDFiPl0gYnR0dl9wcm9iZSsweDUxYi8weDlkMCBbYnR0dl0K
IFs8YzAyNDBiMmI+XSBsb2NhbF9wY2lfcHJvYmUrMHhiLzB4MTAKIFs8YzAyNDE4ODk+XSBwY2lf
ZGV2aWNlX3Byb2JlKzB4NjkvMHg5MAogWzxjMDJhNGY4Mz5dIGRyaXZlcl9wcm9iZV9kZXZpY2Ur
MHg4My8weDFiMAogWzxjMDI0MGJmNj5dIHBjaV9tYXRjaF9kZXZpY2UrMHgxNi8weGIwCiBbPGMw
MmE1MTM5Pl0gX19kcml2ZXJfYXR0YWNoKzB4ODkvMHg5MAogWzxjMDI0MTdjMD5dIHBjaV9kZXZp
Y2VfcmVtb3ZlKzB4MC8weDQwCiBbPGMwMmE0OGU0Pl0gYnVzX2Zvcl9lYWNoX2RldisweDQ0LzB4
NzAKIFs8YzAyNDE3YzA+XSBwY2lfZGV2aWNlX3JlbW92ZSsweDAvMHg0MAogWzxjMDJhNGUxNj5d
IGRyaXZlcl9hdHRhY2grMHgxNi8weDIwCiBbPGMwMmE1MGIwPl0gX19kcml2ZXJfYXR0YWNoKzB4
MC8weDkwCiBbPGMwMmE0MjlmPl0gYnVzX2FkZF9kcml2ZXIrMHgxYmYvMHgyNDAKIFs8YzAyNDE3
YzA+XSBwY2lfZGV2aWNlX3JlbW92ZSsweDAvMHg0MAogWzxjMDJhNTJmYz5dIGRyaXZlcl9yZWdp
c3RlcisweDVjLzB4MTMwCiBbPGMwMmE0YmQ1Pl0gYnVzX3JlZ2lzdGVyKzB4MTY1LzB4MjEwCiBb
PGY4NTdlMDAwPl0gYnR0dl9pbml0X21vZHVsZSsweDAvMHgxMDAgW2J0dHZdCiBbPGMwMjQxYWVk
Pl0gX19wY2lfcmVnaXN0ZXJfZHJpdmVyKzB4M2QvMHg4MAogWzxmODU3ZTAwMD5dIGJ0dHZfaW5p
dF9tb2R1bGUrMHgwLzB4MTAwIFtidHR2XQogWzxmODU3ZTBhMz5dIGJ0dHZfaW5pdF9tb2R1bGUr
MHhhMy8weDEwMCBbYnR0dl0KIFs8YzAxMDExMWE+XSBkb19vbmVfaW5pdGNhbGwrMHgyYS8weDE2
MAogWzxjMDE1YmNmNz5dIHRyYWNlcG9pbnRfbW9kdWxlX25vdGlmeSsweDI3LzB4MzAKIFs8YzAx
NDE2ZTY+XSBub3RpZmllcl9jYWxsX2NoYWluKzB4MzYvMHg3MAogWzxjMDE0MWFkMz5dIF9fYmxv
Y2tpbmdfbm90aWZpZXJfY2FsbF9jaGFpbisweDUzLzB4NzAKIFs8YzAxNGYyNWI+XSBzeXNfaW5p
dF9tb2R1bGUrMHg4Yi8weDFjMAogWzxjMDE4ZjJkMT5dIHN5c19yZWFkKzB4NDEvMHg4MAogWzxj
MDEwMzNhZT5dIHN5c2NhbGxfY2FsbCsweDcvMHhiCiBbPGMwNDAwMDAwPl0gcXVpcmtfbnZpZGlh
X2NrODA0X21zaV9odF9jYXArMHgxMi8weDc1CkNvZGU6IDc1IGY3IDMxIGMwIGFhIDg5IGU4IDhi
IDVjIDI0IDA0IDhiIDc0IDI0IDA4IDhiIDdjIDI0IDBjIDhiIDZjIDI0IDEwIDgzIGM0IDE0IGMz
IDkwIDgzIGVjIDA4IDg5IDM0IDI0IDg5IGM2IDg5IDdjIDI0IDA0IDg5IGQ3IGFjIDxhZT4gNzUg
MDggODQgYzAgNzUgZjggMzEgYzAgZWIgMDQgMTkgYzAgMGMgMDEgOGIgMzQgMjQgOGIgN2MgMjQg
CkVJUDogWzxjMDIyZTViZj5dIHN0cmNtcCsweGYvMHgzMCBTUzpFU1AgMDA2ODplY2Y1ZGNkNAot
LS1bIGVuZCB0cmFjZSA0NDY2OGYwNDJhNDU5YzI4IF0tLS0K
--001485f3b90e51a0f9047c7073ee--

Return-path: <mchehab@gaivota>
Received: from blu0-omc2-s32.blu0.hotmail.com ([65.55.111.107]:13478 "EHLO
	blu0-omc2-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759145Ab1EMCCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 22:02:12 -0400
Message-ID: <BLU157-w6C6865120D491FB84946AD8880@phx.gbl>
Content-Type: multipart/mixed;
	boundary="_010aab95-a7ef-4fd3-ba3a-a55543361f13_"
From: Manoel PN <pinusdtv@hotmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>, <lgspn@hotmail.com>
Subject: [PATCH 1/4] Modifications to the driver mb86a20s
Date: Fri, 13 May 2011 05:02:11 +0300
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--_010aab95-a7ef-4fd3-ba3a-a55543361f13_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hi to all=2C

I added some modifications to the driver mb86a20s and would appreciate your=
 comments.

>
> File: drivers/media/dvb/frontends/mb86a20s.c
>
> -static int debug =3D 1=3B
> +static int debug =3D 0=3B
> module_param(debug=2C int=2C 0644)=3B
> MODULE_PARM_DESC(debug=2C "Activates frontend debugging (default:0)")=3B
>
=A0
How is in the description by default debug is off.

>
> -#define rc(args...)=A0 do {
> +#define printk_rc(args...)=A0 do {
>

For clarity=2C only rc is somewhat vague.

>
> +static int mb86a20s_i2c_gate_ctrl(struct dvb_frontend *fe=2C int enable)=
=20
>=20

Adds the i2c_gate_ctrl to mb86a20s driver.


The mb86a20s has an i2c bus which controls the flow of data to the tuner. W=
hen enabled=2C the data stream flowing normally through the i2c bus=2C when=
 disabled the data stream to the tuner is cut and the i2c bus between mb86a=
20s and the tuner goes to tri-state. The data flow between the mb86a20s and=
 its controller (CPU=2C USB)=2C is not affected.

In hybrid systems with analog and digital TV=2C the i2c bus control can be =
done in the analog demodulator.

>
> -=A0=A0=A0 if (fe->ops.i2c_gate_ctrl)
>-=A0=A0=A0 =A0=A0=A0 fe->ops.i2c_gate_ctrl(fe=2C 0)=3B
> =A0=A0=A0 val =3D mb86a20s_readreg(state=2C 0x0a) & 0xf=3B
> -=A0=A0=A0 if (fe->ops.i2c_gate_ctrl)
> -=A0=A0=A0 =A0=A0=A0 fe->ops.i2c_gate_ctrl(fe=2C 1)=3B
>

The i2c_gate_ctrl controls the i2c bus of the tuner so does not need to ena=
ble it or disable it here.


>
> +=A0=A0=A0 for (i =3D 0=3B i < 20=3B i++) {
> +=A0=A0=A0 =A0=A0=A0 if (mb86a20s_readreg(state=2C 0x0a) >=3D 8) break=3B
> +=A0=A0=A0 =A0=A0=A0 msleep(100)=3B
> +=A0=A0=A0 }
>

Waits for the stabilization of the demodulator.

>
> +static int mb86a20s_get_algo(struct dvb_frontend *fe)
> +{
> +=A0=A0=A0 return DVBFE_ALGO_HW=3B
> +}
>

Because the mb86a20s_tune function was implemented.

Thanks=2C best regards=2C

Manoel.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>



 		 	   		  =

--_010aab95-a7ef-4fd3-ba3a-a55543361f13_
Content-Type: application/octet-stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="i2c_gate_ctrl.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9tYjg2YTIwcy5jIGIvZHJp
dmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKaW5kZXggMGY4NjdhNS4uZmM4Yzkz
MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKKysr
IGIvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL21iODZhMjBzLmMKQEAgLTIyLDExICsyMiwx
MSBAQAogI2luY2x1ZGUgImR2Yl9mcm9udGVuZC5oIgogI2luY2x1ZGUgIm1iODZhMjBzLmgiCiAK
LXN0YXRpYyBpbnQgZGVidWcgPSAxOworc3RhdGljIGludCBkZWJ1ZyA9IDA7CiBtb2R1bGVfcGFy
YW0oZGVidWcsIGludCwgMDY0NCk7CiBNT0RVTEVfUEFSTV9ERVNDKGRlYnVnLCAiQWN0aXZhdGVz
IGZyb250ZW5kIGRlYnVnZ2luZyAoZGVmYXVsdDowKSIpOwogCi0jZGVmaW5lIHJjKGFyZ3MuLi4p
ICBkbyB7CQkJCQkJXAorI2RlZmluZSBwcmludGtfcmMoYXJncy4uLikgIGRvIHsJCQkJCQlcCiAJ
cHJpbnRrKEtFUk5fRVJSICAibWI4NmEyMHM6ICIgYXJncyk7CQkJCVwKIH0gd2hpbGUgKDApCiAK
QEAgLTM1NSw3ICszNTUsNyBAQCBzdGF0aWMgaW50IG1iODZhMjBzX2kyY19yZWFkcmVnKHN0cnVj
dCBtYjg2YTIwc19zdGF0ZSAqc3RhdGUsCiAJcmMgPSBpMmNfdHJhbnNmZXIoc3RhdGUtPmkyYywg
bXNnLCAyKTsKIAogCWlmIChyYyAhPSAyKSB7Ci0JCXJjKCIlczogcmVnPTB4JXggKGVycm9yPSVk
KVxuIiwgX19mdW5jX18sIHJlZywgcmMpOworCQlwcmludGtfcmMoIiVzOiByZWc9MHgleCAoZXJy
b3I9JWQpXG4iLCBfX2Z1bmNfXywgcmVnLCByYyk7CiAJCXJldHVybiByYzsKIAl9CiAKQEAgLTM3
MCw2ICszNzAsMjYgQEAgc3RhdGljIGludCBtYjg2YTIwc19pMmNfcmVhZHJlZyhzdHJ1Y3QgbWI4
NmEyMHNfc3RhdGUgKnN0YXRlLAogCW1iODZhMjBzX2kyY193cml0ZXJlZ2RhdGEoc3RhdGUsIHN0
YXRlLT5jb25maWctPmRlbW9kX2FkZHJlc3MsIFwKIAlyZWdkYXRhLCBBUlJBWV9TSVpFKHJlZ2Rh
dGEpKQogCisvKgorICogVGhlIG1iODZhMjBzIGhhcyBhbiBpMmMgYnVzIHdoaWNoIGNvbnRyb2xz
IHRoZSBmbG93IG9mIGRhdGEgdG8gdGhlIHR1bmVyLgorICogV2hlbiBlbmFibGVkLCB0aGUgZGF0
YSBzdHJlYW0gZmxvd2luZyBub3JtYWxseSB0aHJvdWdoIHRoZSBpMmMgYnVzLCB3aGVuCisgKiBk
aXNhYmxlZCB0aGUgZGF0YSBzdHJlYW0gdG8gdGhlIHR1bmVyIGlzIGN1dCBhbmQgdGhlIGkyYyBi
dXMgYmV0d2VlbgorICogbWI4NmEyMHMgYW5kIHRoZSB0dW5lciBnb2VzIHRvIHRyaS1zdGF0ZS4K
KyAqIFRoZSBkYXRhIGZsb3cgYmV0d2VlbiB0aGUgbWI4NmEyMHMgYW5kIGl0cyBjb250cm9sbGVy
IChDUFUsIFVTQiksIGlzIG5vdCBhZmZlY3RlZC4KKyAqIEluIGh5YnJpZCBzeXN0ZW1zIHdpdGgg
YW5hbG9nIGFuZCBkaWdpdGFsIFRWLCB0aGUgaTJjIGJ1cyBjb250cm9sIGNhbiBiZSBkb25lCisg
KiBpbiB0aGUgYW5hbG9nIGRlbW9kdWxhdG9yLgorICovCitzdGF0aWMgaW50IG1iODZhMjBzX2ky
Y19nYXRlX2N0cmwoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsIGludCBlbmFibGUpCit7CisJc3Ry
dWN0IG1iODZhMjBzX3N0YXRlICpzdGF0ZSA9IChzdHJ1Y3QgbWI4NmEyMHNfc3RhdGUgKilmZS0+
ZGVtb2R1bGF0b3JfcHJpdjsKKworCS8qIEVuYWJsZS9EaXNhYmxlIEkyQyBidXMgZm9yIHR1bmVy
IGNvbnRyb2wgKi8KKwlpZiAoZW5hYmxlKQorCQlyZXR1cm4gbWI4NmEyMHNfd3JpdGVyZWcoc3Rh
dGUsIDB4ZmUsIDApOworCWVsc2UKKwkJcmV0dXJuIG1iODZhMjBzX3dyaXRlcmVnKHN0YXRlLCAw
eGZlLCAxKTsKK30KKwogc3RhdGljIGludCBtYjg2YTIwc19pbml0ZmUoc3RydWN0IGR2Yl9mcm9u
dGVuZCAqZmUpCiB7CiAJc3RydWN0IG1iODZhMjBzX3N0YXRlICpzdGF0ZSA9IGZlLT5kZW1vZHVs
YXRvcl9wcml2OwpAQCAtNDU5LDExICs0NzksNyBAQCBzdGF0aWMgaW50IG1iODZhMjBzX3JlYWRf
c3RhdHVzKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLCBmZV9zdGF0dXNfdCAqc3RhdHVzKQogCWRw
cmludGsoIlxuIik7CiAJKnN0YXR1cyA9IDA7CiAKLQlpZiAoZmUtPm9wcy5pMmNfZ2F0ZV9jdHJs
KQotCQlmZS0+b3BzLmkyY19nYXRlX2N0cmwoZmUsIDApOwogCXZhbCA9IG1iODZhMjBzX3JlYWRy
ZWcoc3RhdGUsIDB4MGEpICYgMHhmOwotCWlmIChmZS0+b3BzLmkyY19nYXRlX2N0cmwpCi0JCWZl
LT5vcHMuaTJjX2dhdGVfY3RybChmZSwgMSk7CiAKIAlpZiAodmFsID49IDIpCiAJCSpzdGF0dXMg
fD0gRkVfSEFTX1NJR05BTDsKQEAgLTQ4OSwxNCArNTA1LDE4IEBAIHN0YXRpYyBpbnQgbWI4NmEy
MHNfc2V0X2Zyb250ZW5kKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLAogCXN0cnVjdCBkdmJfZnJv
bnRlbmRfcGFyYW1ldGVycyAqcCkKIHsKIAlzdHJ1Y3QgbWI4NmEyMHNfc3RhdGUgKnN0YXRlID0g
ZmUtPmRlbW9kdWxhdG9yX3ByaXY7Ci0JaW50IHJjOworCWludCBpLCByYzsKIAogCWRwcmludGso
IlxuIik7CiAKLQlpZiAoZmUtPm9wcy5pMmNfZ2F0ZV9jdHJsKQotCQlmZS0+b3BzLmkyY19nYXRl
X2N0cmwoZmUsIDEpOwotCWRwcmludGsoIkNhbGxpbmcgdHVuZXIgc2V0IHBhcmFtZXRlcnNcbiIp
OwotCWZlLT5vcHMudHVuZXJfb3BzLnNldF9wYXJhbXMoZmUsIHApOworCWlmIChmZS0+b3BzLnR1
bmVyX29wcy5zZXRfcGFyYW1zKSB7CisJCWRwcmludGsoIkNhbGxpbmcgdHVuZXIgc2V0IHBhcmFt
ZXRlcnNcbiIpOworCQlmZS0+b3BzLnR1bmVyX29wcy5zZXRfcGFyYW1zKGZlLCBwKTsKKwkJLyog
ZGlzYWJsZSBJMkMgYnVzIHR1bmVyIGNvbnRyb2wgKi8KKwkJaWYgKGZlLT5vcHMuaTJjX2dhdGVf
Y3RybCkKKwkJCWZlLT5vcHMuaTJjX2dhdGVfY3RybChmZSwgMCk7CisJCW1zbGVlcCgxMDApOwor
CX0KIAogCS8qCiAJICogTWFrZSBpdCBtb3JlIHJlbGlhYmxlOiBpZiwgZm9yIHNvbWUgcmVhc29u
LCB0aGUgaW5pdGlhbApAQCAtNTExLDEzICs1MzEsMTYgQEAgc3RhdGljIGludCBtYjg2YTIwc19z
ZXRfZnJvbnRlbmQoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsCiAJaWYgKHN0YXRlLT5uZWVkX2lu
aXQpCiAJCW1iODZhMjBzX2luaXRmZShmZSk7CiAKLQlpZiAoZmUtPm9wcy5pMmNfZ2F0ZV9jdHJs
KQotCQlmZS0+b3BzLmkyY19nYXRlX2N0cmwoZmUsIDApOwogCXJjID0gbWI4NmEyMHNfd3JpdGVy
ZWdkYXRhKHN0YXRlLCBtYjg2YTIwc19yZXNldF9yZWNlcHRpb24pOwotCWlmIChmZS0+b3BzLmky
Y19nYXRlX2N0cmwpCi0JCWZlLT5vcHMuaTJjX2dhdGVfY3RybChmZSwgMSk7CisJaWYgKHJjIDwg
MCkKKwkJcmV0dXJuIHJjOwogCi0JcmV0dXJuIHJjOworCWZvciAoaSA9IDA7IGkgPCAyMDsgaSsr
KSB7CisJCWlmIChtYjg2YTIwc19yZWFkcmVnKHN0YXRlLCAweDBhKSA+PSA4KSBicmVhazsKKwkJ
bXNsZWVwKDEwMCk7CisJfQorCisJcmV0dXJuIDA7CiB9CiAKIHN0YXRpYyBpbnQgbWI4NmEyMHNf
Z2V0X2Zyb250ZW5kKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLApAQCAtNTUzLDYgKzU3NiwxMSBA
QCBzdGF0aWMgaW50IG1iODZhMjBzX3R1bmUoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsCiAJcmV0
dXJuIHJjOwogfQogCitzdGF0aWMgaW50IG1iODZhMjBzX2dldF9hbGdvKHN0cnVjdCBkdmJfZnJv
bnRlbmQgKmZlKQoreworCXJldHVybiBEVkJGRV9BTEdPX0hXOworfQorCiBzdGF0aWMgdm9pZCBt
Yjg2YTIwc19yZWxlYXNlKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlKQogewogCXN0cnVjdCBtYjg2
YTIwc19zdGF0ZSAqc3RhdGUgPSBmZS0+ZGVtb2R1bGF0b3JfcHJpdjsKQEAgLTU3NSw3ICs2MDMs
NyBAQCBzdHJ1Y3QgZHZiX2Zyb250ZW5kICptYjg2YTIwc19hdHRhY2goY29uc3Qgc3RydWN0IG1i
ODZhMjBzX2NvbmZpZyAqY29uZmlnLAogCiAJZHByaW50aygiXG4iKTsKIAlpZiAoc3RhdGUgPT0g
TlVMTCkgewotCQlyYygiVW5hYmxlIHRvIGt6YWxsb2NcbiIpOworCQlwcmludGtfcmMoIlVuYWJs
ZSB0byBremFsbG9jXG4iKTsKIAkJZ290byBlcnJvcjsKIAl9CiAKQEAgLTYzMSw2ICs2NTksOCBA
QCBzdGF0aWMgc3RydWN0IGR2Yl9mcm9udGVuZF9vcHMgbWI4NmEyMHNfb3BzID0gewogCS5nZXRf
ZnJvbnRlbmQgPSBtYjg2YTIwc19nZXRfZnJvbnRlbmQsCiAJLnJlYWRfc3RhdHVzID0gbWI4NmEy
MHNfcmVhZF9zdGF0dXMsCiAJLnJlYWRfc2lnbmFsX3N0cmVuZ3RoID0gbWI4NmEyMHNfcmVhZF9z
aWduYWxfc3RyZW5ndGgsCisJLmkyY19nYXRlX2N0cmwgPSBtYjg2YTIwc19pMmNfZ2F0ZV9jdHJs
LAorCS5nZXRfZnJvbnRlbmRfYWxnbyA9IG1iODZhMjBzX2dldF9hbGdvLAogCS50dW5lID0gbWI4
NmEyMHNfdHVuZSwKIH07CiAK

--_010aab95-a7ef-4fd3-ba3a-a55543361f13_--

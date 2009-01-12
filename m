Return-path: <linux-media-owner@vger.kernel.org>
Received: from web90407.mail.mud.yahoo.com ([216.252.100.159]:23295 "HELO
	web90407.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751746AbZALXcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 18:32:22 -0500
References: <209163.20581.qm@web90406.mail.mud.yahoo.com> <alpine.LRH.1.10.0901121617000.29492@pub2.ifh.de>
Date: Mon, 12 Jan 2009 15:32:21 -0800 (PST)
From: Nicolas Fournier <nicolasfournier@yahoo.com>
Subject: AW: [PATCH] Terratec Cinergy DT XS Diversity new USB ID (0ccd:0081)
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-490609683-1231803141=:70208"
Message-ID: <519879.70208.qm@web90407.mail.mud.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0-490609683-1231803141=:70208
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This time with the patch as attachment:=0A=0AThe following patch adds suppo=
rt for a new version of the=0ATerratec Cinergy DT USB XS Diversity Dual DVB=
-T TV tuner stick.=0AThe USB ID of the new stick is 0ccd:0081.=0AThe hardwa=
re of the stick has changed, when compared to the first version of=0Athis s=
tick, but it still uses quite standard components, so that only minor=0Acha=
nges are needed to the sources.=0A=0AThe patch has been successfully tested=
 with hotplugging the device and then =0A2 x tzap and 2 x mplayer, to watch=
 two different TV programs simultaneously.=0A=0AThe stick works with both, =
the old and new firmwares:=0A- dvb-usb-dib0700-1.10.fw and =0A- dvb-usb-dib=
0700-1.20.fw=0A=0APriority: normal=0A=0ASigned-off-by: Nicolas Fournier <ni=
colasfournier -at- yahoo -dot- com>=0A=0A=0A      
--0-490609683-1231803141=:70208
Content-Type: text/x-patch; name="new_terratec_cinergy_dt_xs_div.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="new_terratec_cinergy_dt_xs_div.patch"

ZGlmZiAtciAwMjkzNjg4ZDM1M2YgbGludXgvZHJpdmVycy9tZWRpYS9kdmIv
ZHZiLXVzYi9kaWIwNzAwX2RldmljZXMuYwotLS0gYS9saW51eC9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCU1vbiBKYW4g
MTIgMDk6MDk6MDggMjAwOSAtMDgwMAorKysgYi9saW51eC9kcml2ZXJzL21l
ZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVR1ZSBKYW4gMTMg
MDA6MjQ6NDIgMjAwOSArMDEwMApAQCAtMTM5NCw2ICsxMzk0LDggQEAgc3Ry
dWN0IHVzYl9kZXZpY2VfaWQgZGliMDcwMF91c2JfaWRfdGFibAogLyogNDAg
Ki97IFVTQl9ERVZJQ0UoVVNCX1ZJRF9QSU5OQUNMRSwgIFVTQl9QSURfUElO
TkFDTEVfUENUVjgwMUUpIH0sCiAJeyBVU0JfREVWSUNFKFVTQl9WSURfUElO
TkFDTEUsICBVU0JfUElEX1BJTk5BQ0xFX1BDVFY4MDFFX1NFKSB9LAogCXsg
VVNCX0RFVklDRShVU0JfVklEX1RFUlJBVEVDLAlVU0JfUElEX1RFUlJBVEVD
X0NJTkVSR1lfVF9FWFBSRVNTKSB9LAorCXsgVVNCX0RFVklDRShVU0JfVklE
X1RFUlJBVEVDLAorCQkJVVNCX1BJRF9URVJSQVRFQ19DSU5FUkdZX0RUX1hT
X0RJVkVSU0lUWV8yKSB9LAogCXsgMCB9CQkvKiBUZXJtaW5hdGluZyBlbnRy
eSAqLwogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBkaWIwNzAwX3Vz
Yl9pZF90YWJsZSk7CkBAIC0xNjU5LDcgKzE2NjEsNyBAQCBzdHJ1Y3QgZHZi
X3VzYl9kZXZpY2VfcHJvcGVydGllcyBkaWIwNzAwCiAJCQl9CiAJCX0sCiAK
LQkJLm51bV9kZXZpY2VfZGVzY3MgPSA0LAorCQkubnVtX2RldmljZV9kZXNj
cyA9IDUsCiAJCS5kZXZpY2VzID0gewogCQkJeyAgICJEaUJjb20gU1RLNzA3
MFBEIHJlZmVyZW5jZSBkZXNpZ24iLAogCQkJCXsgJmRpYjA3MDBfdXNiX2lk
X3RhYmxlWzE3XSwgTlVMTCB9LApAQCAtMTY3NSw2ICsxNjc3LDEwIEBAIHN0
cnVjdCBkdmJfdXNiX2RldmljZV9wcm9wZXJ0aWVzIGRpYjA3MDAKIAkJCX0s
CiAJCQl7ICAgIkhhdXBwYXVnZSBOb3ZhLVRELTUwMCAoODR4eHgpIiwKIAkJ
CQl7ICZkaWIwNzAwX3VzYl9pZF90YWJsZVszNl0sIE5VTEwgfSwKKwkJCQl7
IE5VTEwgfSwKKwkJCX0sCisJCQl7ICAiVGVycmF0ZWMgQ2luZXJneSBEVCBV
U0IgWFMgRGl2ZXJzaXR5IiwKKwkJCQl7ICZkaWIwNzAwX3VzYl9pZF90YWJs
ZVs0M10sIE5VTEwgfSwKIAkJCQl7IE5VTEwgfSwKIAkJCX0KIAkJfQpkaWZm
IC1yIDAyOTM2ODhkMzUzZiBsaW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmIt
dXNiL2R2Yi11c2ItaWRzLmgKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9k
dmIvZHZiLXVzYi9kdmItdXNiLWlkcy5oCU1vbiBKYW4gMTIgMDk6MDk6MDgg
MjAwOSAtMDgwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmIt
dXNiL2R2Yi11c2ItaWRzLmgJVHVlIEphbiAxMyAwMDoyNTozOCAyMDA5ICsw
MTAwCkBAIC0xNjIsNiArMTYyLDcgQEAKICNkZWZpbmUgVVNCX1BJRF9BVkVS
TUVESUFfQTMwOQkJCQkweGEzMDkKICNkZWZpbmUgVVNCX1BJRF9URUNITk9U
UkVORF9DT05ORUNUX1MyNDAwICAgICAgICAgICAgICAgMHgzMDA2CiAjZGVm
aW5lIFVTQl9QSURfVEVSUkFURUNfQ0lORVJHWV9EVF9YU19ESVZFUlNJVFkJ
MHgwMDVhCisjZGVmaW5lIFVTQl9QSURfVEVSUkFURUNfQ0lORVJHWV9EVF9Y
U19ESVZFUlNJVFlfMgkweDAwODEKICNkZWZpbmUgVVNCX1BJRF9URVJSQVRF
Q19DSU5FUkdZX0hUX1VTQl9YRQkJMHgwMDU4CiAjZGVmaW5lIFVTQl9QSURf
VEVSUkFURUNfQ0lORVJHWV9IVF9FWFBSRVNTCQkweDAwNjAKICNkZWZpbmUg
VVNCX1BJRF9URVJSQVRFQ19DSU5FUkdZX1RfRVhQUkVTUwkJMHgwMDYyCg==


--0-490609683-1231803141=:70208--

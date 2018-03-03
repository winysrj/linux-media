Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0110.outbound.protection.outlook.com ([104.47.40.110]:19475
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932440AbeCCW2D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 17:28:03 -0500
From: Sasha Levin <Alexander.Levin@microsoft.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: =?utf-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Shashank Sharma <shashank.sharma@intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Subject: [PATCH AUTOSEL for 4.14 03/84] video/hdmi: Allow "empty" HDMI
 infoframes
Date: Sat, 3 Mar 2018 22:26:01 +0000
Message-ID: <20180303222518.26271-3-alexander.levin@microsoft.com>
References: <20180303222518.26271-1-alexander.levin@microsoft.com>
In-Reply-To: <20180303222518.26271-1-alexander.levin@microsoft.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8A10CF2DF82704DBBBD97384C74250F@namprd21.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RnJvbTogVmlsbGUgU3lyasOkbMOkIDx2aWxsZS5zeXJqYWxhQGxpbnV4LmludGVsLmNvbT4NCg0K
WyBVcHN0cmVhbSBjb21taXQgNTkzZjRiMTlhMDk0YzQ0MjZiZDFlMWUzY2JhYjg3YTQ4YmQxM2M3
MSBdDQoNCkhETUkgMi4wIEFwcGVuZGl4IEYgc3VnZ2VzdCB0aGF0IHdlIHNob3VsZCBrZWVwIHNl
bmRpbmcgdGhlIGluZm9mcmFtZQ0Kd2hlbiBzd2l0Y2hpbmcgZnJvbSAzRCB0byAyRCBtb2RlLCBl
dmVuIGlmIHRoZSBpbmZvZnJhbWUgaXNuJ3Qgc3RyaWN0bHkNCm5lY2Vzc2FyeSAoaWUuIG5vdCBu
ZWVkZWQgdG8gdHJhbnNtaXQgdGhlIFZJQyBvciBzdGVyZW8gaW5mb3JtYXRpb24pLg0KVGhpcyBp
cyBhIHdvcmthcm91bmQgYWdhaW5zdCBzb21lIHNpbmtzIHRoYXQgZmFpbCB0byByZWFsaXplIHRo
YXQgdGhleQ0Kc2hvdWxkIHN3aXRjaCBmcm9tIDNEIHRvIDJEIG1vZGUgd2hlbiB0aGUgc291cmNl
IHN0b3AgdHJhbnNtaXR0aW5nDQp0aGUgaW5mb2ZyYW1lLg0KDQp2MjogSGFuZGxlIHVucGFjaygp
IGFzIHdlbGwNCiAgICBQdWxsIHRoZSBsZW5ndGggY2FsY3VsYXRpb24gaW50byBhIGhlbHBlcg0K
DQpDYzogU2hhc2hhbmsgU2hhcm1hIDxzaGFzaGFuay5zaGFybWFAaW50ZWwuY29tPg0KQ2M6IEFu
ZHJ6ZWogSGFqZGEgPGEuaGFqZGFAc2Ftc3VuZy5jb20+DQpDYzogVGhpZXJyeSBSZWRpbmcgPHRo
aWVycnkucmVkaW5nQGdtYWlsLmNvbT4NCkNjOiBIYW5zIFZlcmt1aWwgPGhhbnMudmVya3VpbEBj
aXNjby5jb20+DQpDYzogbGludXgtbWVkaWFAdmdlci5rZXJuZWwub3JnDQpSZXZpZXdlZC1ieTog
QW5kcnplaiBIYWpkYSA8YS5oYWpkYUBzYW1zdW5nLmNvbT4gI3YxDQpTaWduZWQtb2ZmLWJ5OiBW
aWxsZSBTeXJqw6Rsw6QgPHZpbGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPg0KTGluazogaHR0
cHM6Ly9wYXRjaHdvcmsuZnJlZWRlc2t0b3Aub3JnL3BhdGNoL21zZ2lkLzIwMTcxMTEzMTcwNDI3
LjQxNTAtMi12aWxsZS5zeXJqYWxhQGxpbnV4LmludGVsLmNvbQ0KUmV2aWV3ZWQtYnk6IFNoYXNo
YW5rIFNoYXJtYSA8c2hhc2hhbmsuc2hhcm1hQGludGVsLmNvbT4NClNpZ25lZC1vZmYtYnk6IFNh
c2hhIExldmluIDxhbGV4YW5kZXIubGV2aW5AbWljcm9zb2Z0LmNvbT4NCi0tLQ0KIGRyaXZlcnMv
dmlkZW8vaGRtaS5jIHwgNTEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
LS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDMxIGluc2VydGlvbnMoKyksIDIwIGRlbGV0
aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy92aWRlby9oZG1pLmMgYi9kcml2ZXJzL3Zp
ZGVvL2hkbWkuYw0KaW5kZXggMWNmOTA3ZWNkZWQ0Li4xMTFhMGFiNjI4MGEgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3ZpZGVvL2hkbWkuYw0KKysrIGIvZHJpdmVycy92aWRlby9oZG1pLmMNCkBAIC0z
MjEsNiArMzIxLDE3IEBAIGludCBoZG1pX3ZlbmRvcl9pbmZvZnJhbWVfaW5pdChzdHJ1Y3QgaGRt
aV92ZW5kb3JfaW5mb2ZyYW1lICpmcmFtZSkNCiB9DQogRVhQT1JUX1NZTUJPTChoZG1pX3ZlbmRv
cl9pbmZvZnJhbWVfaW5pdCk7DQogDQorc3RhdGljIGludCBoZG1pX3ZlbmRvcl9pbmZvZnJhbWVf
bGVuZ3RoKGNvbnN0IHN0cnVjdCBoZG1pX3ZlbmRvcl9pbmZvZnJhbWUgKmZyYW1lKQ0KK3sNCisJ
LyogZm9yIHNpZGUgYnkgc2lkZSAoaGFsZikgd2UgYWxzbyBuZWVkIHRvIHByb3ZpZGUgM0RfRXh0
X0RhdGEgKi8NCisJaWYgKGZyYW1lLT5zM2Rfc3RydWN0ID49IEhETUlfM0RfU1RSVUNUVVJFX1NJ
REVfQllfU0lERV9IQUxGKQ0KKwkJcmV0dXJuIDY7DQorCWVsc2UgaWYgKGZyYW1lLT52aWMgIT0g
MCB8fCBmcmFtZS0+czNkX3N0cnVjdCAhPSBIRE1JXzNEX1NUUlVDVFVSRV9JTlZBTElEKQ0KKwkJ
cmV0dXJuIDU7DQorCWVsc2UNCisJCXJldHVybiA0Ow0KK30NCisNCiAvKioNCiAgKiBoZG1pX3Zl
bmRvcl9pbmZvZnJhbWVfcGFjaygpIC0gd3JpdGUgYSBIRE1JIHZlbmRvciBpbmZvZnJhbWUgdG8g
YmluYXJ5IGJ1ZmZlcg0KICAqIEBmcmFtZTogSERNSSBpbmZvZnJhbWUNCkBAIC0zNDEsMTkgKzM1
MiwxMSBAQCBzc2l6ZV90IGhkbWlfdmVuZG9yX2luZm9mcmFtZV9wYWNrKHN0cnVjdCBoZG1pX3Zl
bmRvcl9pbmZvZnJhbWUgKmZyYW1lLA0KIAl1OCAqcHRyID0gYnVmZmVyOw0KIAlzaXplX3QgbGVu
Z3RoOw0KIA0KLQkvKiBlbXB0eSBpbmZvIGZyYW1lICovDQotCWlmIChmcmFtZS0+dmljID09IDAg
JiYgZnJhbWUtPnMzZF9zdHJ1Y3QgPT0gSERNSV8zRF9TVFJVQ1RVUkVfSU5WQUxJRCkNCi0JCXJl
dHVybiAtRUlOVkFMOw0KLQ0KIAkvKiBvbmx5IG9uZSBvZiB0aG9zZSBjYW4gYmUgc3VwcGxpZWQg
Ki8NCiAJaWYgKGZyYW1lLT52aWMgIT0gMCAmJiBmcmFtZS0+czNkX3N0cnVjdCAhPSBIRE1JXzNE
X1NUUlVDVFVSRV9JTlZBTElEKQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQotCS8qIGZvciBzaWRl
IGJ5IHNpZGUgKGhhbGYpIHdlIGFsc28gbmVlZCB0byBwcm92aWRlIDNEX0V4dF9EYXRhICovDQot
CWlmIChmcmFtZS0+czNkX3N0cnVjdCA+PSBIRE1JXzNEX1NUUlVDVFVSRV9TSURFX0JZX1NJREVf
SEFMRikNCi0JCWZyYW1lLT5sZW5ndGggPSA2Ow0KLQllbHNlDQotCQlmcmFtZS0+bGVuZ3RoID0g
NTsNCisJZnJhbWUtPmxlbmd0aCA9IGhkbWlfdmVuZG9yX2luZm9mcmFtZV9sZW5ndGgoZnJhbWUp
Ow0KIA0KIAlsZW5ndGggPSBIRE1JX0lORk9GUkFNRV9IRUFERVJfU0laRSArIGZyYW1lLT5sZW5n
dGg7DQogDQpAQCAtMzcyLDE0ICszNzUsMTYgQEAgc3NpemVfdCBoZG1pX3ZlbmRvcl9pbmZvZnJh
bWVfcGFjayhzdHJ1Y3QgaGRtaV92ZW5kb3JfaW5mb2ZyYW1lICpmcmFtZSwNCiAJcHRyWzVdID0g
MHgwYzsNCiAJcHRyWzZdID0gMHgwMDsNCiANCi0JaWYgKGZyYW1lLT52aWMpIHsNCi0JCXB0cls3
XSA9IDB4MSA8PCA1OwkvKiB2aWRlbyBmb3JtYXQgKi8NCi0JCXB0cls4XSA9IGZyYW1lLT52aWM7
DQotCX0gZWxzZSB7DQorCWlmIChmcmFtZS0+czNkX3N0cnVjdCAhPSBIRE1JXzNEX1NUUlVDVFVS
RV9JTlZBTElEKSB7DQogCQlwdHJbN10gPSAweDIgPDwgNTsJLyogdmlkZW8gZm9ybWF0ICovDQog
CQlwdHJbOF0gPSAoZnJhbWUtPnMzZF9zdHJ1Y3QgJiAweGYpIDw8IDQ7DQogCQlpZiAoZnJhbWUt
PnMzZF9zdHJ1Y3QgPj0gSERNSV8zRF9TVFJVQ1RVUkVfU0lERV9CWV9TSURFX0hBTEYpDQogCQkJ
cHRyWzldID0gKGZyYW1lLT5zM2RfZXh0X2RhdGEgJiAweGYpIDw8IDQ7DQorCX0gZWxzZSBpZiAo
ZnJhbWUtPnZpYykgew0KKwkJcHRyWzddID0gMHgxIDw8IDU7CS8qIHZpZGVvIGZvcm1hdCAqLw0K
KwkJcHRyWzhdID0gZnJhbWUtPnZpYzsNCisJfSBlbHNlIHsNCisJCXB0cls3XSA9IDB4MCA8PCA1
OwkvKiB2aWRlbyBmb3JtYXQgKi8NCiAJfQ0KIA0KIAloZG1pX2luZm9mcmFtZV9zZXRfY2hlY2tz
dW0oYnVmZmVyLCBsZW5ndGgpOw0KQEAgLTExNjUsNyArMTE3MCw3IEBAIGhkbWlfdmVuZG9yX2Fu
eV9pbmZvZnJhbWVfdW5wYWNrKHVuaW9uIGhkbWlfdmVuZG9yX2FueV9pbmZvZnJhbWUgKmZyYW1l
LA0KIA0KIAlpZiAocHRyWzBdICE9IEhETUlfSU5GT0ZSQU1FX1RZUEVfVkVORE9SIHx8DQogCSAg
ICBwdHJbMV0gIT0gMSB8fA0KLQkgICAgKHB0clsyXSAhPSA1ICYmIHB0clsyXSAhPSA2KSkNCisJ
ICAgIChwdHJbMl0gIT0gNCAmJiBwdHJbMl0gIT0gNSAmJiBwdHJbMl0gIT0gNikpDQogCQlyZXR1
cm4gLUVJTlZBTDsNCiANCiAJbGVuZ3RoID0gcHRyWzJdOw0KQEAgLTExOTMsMTYgKzExOTgsMjIg
QEAgaGRtaV92ZW5kb3JfYW55X2luZm9mcmFtZV91bnBhY2sodW5pb24gaGRtaV92ZW5kb3JfYW55
X2luZm9mcmFtZSAqZnJhbWUsDQogDQogCWh2Zi0+bGVuZ3RoID0gbGVuZ3RoOw0KIA0KLQlpZiAo
aGRtaV92aWRlb19mb3JtYXQgPT0gMHgxKSB7DQotCQlodmYtPnZpYyA9IHB0cls0XTsNCi0JfSBl
bHNlIGlmIChoZG1pX3ZpZGVvX2Zvcm1hdCA9PSAweDIpIHsNCisJaWYgKGhkbWlfdmlkZW9fZm9y
bWF0ID09IDB4Mikgew0KKwkJaWYgKGxlbmd0aCAhPSA1ICYmIGxlbmd0aCAhPSA2KQ0KKwkJCXJl
dHVybiAtRUlOVkFMOw0KIAkJaHZmLT5zM2Rfc3RydWN0ID0gcHRyWzRdID4+IDQ7DQogCQlpZiAo
aHZmLT5zM2Rfc3RydWN0ID49IEhETUlfM0RfU1RSVUNUVVJFX1NJREVfQllfU0lERV9IQUxGKSB7
DQotCQkJaWYgKGxlbmd0aCA9PSA2KQ0KLQkJCQlodmYtPnMzZF9leHRfZGF0YSA9IHB0cls1XSA+
PiA0Ow0KLQkJCWVsc2UNCisJCQlpZiAobGVuZ3RoICE9IDYpDQogCQkJCXJldHVybiAtRUlOVkFM
Ow0KKwkJCWh2Zi0+czNkX2V4dF9kYXRhID0gcHRyWzVdID4+IDQ7DQogCQl9DQorCX0gZWxzZSBp
ZiAoaGRtaV92aWRlb19mb3JtYXQgPT0gMHgxKSB7DQorCQlpZiAobGVuZ3RoICE9IDUpDQorCQkJ
cmV0dXJuIC1FSU5WQUw7DQorCQlodmYtPnZpYyA9IHB0cls0XTsNCisJfSBlbHNlIHsNCisJCWlm
IChsZW5ndGggIT0gNCkNCisJCQlyZXR1cm4gLUVJTlZBTDsNCiAJfQ0KIA0KIAlyZXR1cm4gMDsN
Ci0tIA0KMi4xNC4xDQo=

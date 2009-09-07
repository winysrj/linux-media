Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f217.google.com ([209.85.219.217])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <henk.vergonet@gmail.com>) id 1MkZW9-0004Q2-13
	for linux-dvb@linuxtv.org; Mon, 07 Sep 2009 10:24:05 +0200
Received: by ewy17 with SMTP id 17so2194347ewy.26
	for <linux-dvb@linuxtv.org>; Mon, 07 Sep 2009 01:23:31 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Sep 2009 10:23:31 +0200
Message-ID: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
From: Henk <henk.vergonet@gmail.com>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary=000e0cdf936aa6c9bd0472f89093
Subject: [linux-dvb] [PATCH] Add support for Zolid Hybrid PCI card
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--000e0cdf936aa6c9bd0472f89093
Content-Type: text/plain; charset=ISO-8859-1

This patch adds support for Zolid Hybrid TV card. The results are
pretty encouraging DVB reception and analog TV reception are confirmed
to work. Might still need to find the GPIO pin that switches AGC on
the TDA18271.

see:
http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
for more information.

Signed-off-by: Henk.Vergonet@gmail.com

--000e0cdf936aa6c9bd0472f89093
Content-Type: application/octet-stream; name="Zolid_Hybrid_PCI.patch"
Content-Disposition: attachment; filename="Zolid_Hybrid_PCI.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzaxtuk10

ZGlmZiAtciAyYjQ5ODEzZjg0ODIgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3Nh
YTcxMzQtY2FyZHMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2Fh
NzEzNC1jYXJkcy5jCVRodSBTZXAgMDMgMDk6MDY6MzQgMjAwOSAtMDMwMAorKysgYi9saW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2FhNzEzNC1jYXJkcy5jCU1vbiBTZXAgMDcgMDA6
MTY6MjQgMjAwOSArMDIwMApAQCAtMzUyMSw2ICszNTIxLDM1IEBACiAJCQkuZ3BpbyA9IDB4MDgw
MDEwMCwgLyogR1BJTyAyMyBISSBmb3IgRk0gKi8KIAkJfSwKIAl9LAorCVtTQUE3MTM0X0JPQVJE
X1pPTElEX0hZQlJJRF9QQ0ldID0geworCQkubmFtZSAgICAgICAgICAgPSAiTlhQIEV1cm9wYSBE
VkItVCBoeWJyaWQgcmVmZXJlbmNlIGRlc2lnbiIsCisJCS5hdWRpb19jbG9jayAgICA9IDB4MDAx
ODdkZTcsCisJCS50dW5lcl90eXBlICAgICA9IFRVTkVSX1BISUxJUFNfVERBODI5MCwKKwkJLnJh
ZGlvX3R5cGUgICAgID0gVU5TRVQsCisJCS50dW5lcl9hZGRyICAgICA9IEFERFJfVU5TRVQsCisJ
CS5yYWRpb19hZGRyICAgICA9IEFERFJfVU5TRVQsCisJCS50dW5lcl9jb25maWcgICA9IDMsCisJ
CS5tcGVnICAgICAgICAgICA9IFNBQTcxMzRfTVBFR19EVkIsCisJCS50c190eXBlCT0gU0FBNzEz
NF9NUEVHX1RTX1BBUkFMTEVMLAorCQkuaW5wdXRzICAgICAgICAgPSB7eworCQkJLm5hbWUgPSBu
YW1lX3R2LAorCQkJLnZtdXggPSAxLAorCQkJLmFtdXggPSBUViwKKwkJCS50diAgID0gMSwKKwkJ
fSwgeworCQkJLm5hbWUgPSBuYW1lX2NvbXAxLAorCQkJLnZtdXggPSAwLAorCQkJLmFtdXggPSBM
SU5FMSwKKwkJfSwgeworCQkJLm5hbWUgPSBuYW1lX3N2aWRlbywKKwkJCS52bXV4ID0gNiwKKwkJ
CS5hbXV4ID0gTElORTEsCisJCX0gfSwKKwkJLnJhZGlvID0geworCQkJLm5hbWUgPSBuYW1lX3Jh
ZGlvLAorCQkJLmFtdXggPSBUViwKKwkJfSwKKwl9LAogCVtTQUE3MTM0X0JPQVJEX0NJTkVSR1lf
SFRfUENNQ0lBXSA9IHsKIAkJLm5hbWUgICAgICAgICAgID0gIlRlcnJhdGVjIENpbmVyZ3kgSFQg
UENNQ0lBIiwKIAkJLmF1ZGlvX2Nsb2NrICAgID0gMHgwMDE4N2RlNywKQEAgLTY0MjksNiArNjQ1
OCwxMiBAQAogCQkuc3ViZGV2aWNlICAgID0gMHgwMTM4LCAvKiBMaWZlVmlldyBGbHlUViBQcmlt
ZTMwIE9FTSAqLwogCQkuZHJpdmVyX2RhdGEgID0gU0FBNzEzNF9CT0FSRF9ST1ZFUk1FRElBX0xJ
TktfUFJPX0ZNLAogCX0sIHsKKwkJLnZlbmRvciAgICAgICA9IFBDSV9WRU5ET1JfSURfUEhJTElQ
UywKKwkJLmRldmljZSAgICAgICA9IFBDSV9ERVZJQ0VfSURfUEhJTElQU19TQUE3MTMzLAorCQku
c3VidmVuZG9yICAgID0gUENJX1ZFTkRPUl9JRF9QSElMSVBTLAorCQkuc3ViZGV2aWNlICAgID0g
MHgyMDA0LAorCQkuZHJpdmVyX2RhdGEgID0gU0FBNzEzNF9CT0FSRF9aT0xJRF9IWUJSSURfUENJ
LAorCX0sIHsKIAkJLyogLS0tIGJvYXJkcyB3aXRob3V0IGVlcHJvbSArIHN1YnN5c3RlbSBJRCAt
LS0gKi8KIAkJLnZlbmRvciAgICAgICA9IFBDSV9WRU5ET1JfSURfUEhJTElQUywKIAkJLmRldmlj
ZSAgICAgICA9IFBDSV9ERVZJQ0VfSURfUEhJTElQU19TQUE3MTM0LApAQCAtNjY1NSw2ICs2Njkw
LDcgQEAKIAlzd2l0Y2ggKGRldi0+Ym9hcmQpIHsKIAljYXNlIFNBQTcxMzRfQk9BUkRfSEFVUFBB
VUdFX0hWUjExNTA6CiAJY2FzZSBTQUE3MTM0X0JPQVJEX0hBVVBQQVVHRV9IVlIxMTIwOgorCWNh
c2UgU0FBNzEzNF9CT0FSRF9aT0xJRF9IWUJSSURfUENJOgogCQkvKiB0ZGE4MjkwICsgdGRhMTgy
NzEgKi8KIAkJcmV0ID0gc2FhNzEzNF90ZGE4MjkwXzE4MjcxX2NhbGxiYWNrKGRldiwgY29tbWFu
ZCwgYXJnKTsKIAkJYnJlYWs7CmRpZmYgLXIgMmI0OTgxM2Y4NDgyIGxpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vc2FhNzEzNC9zYWE3MTM0LWR2Yi5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vc2FhNzEzNC9zYWE3MTM0LWR2Yi5jCVRodSBTZXAgMDMgMDk6MDY6MzQgMjAwOSAtMDMw
MAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2FhNzEzNC1kdmIuYwlN
b24gU2VwIDA3IDAwOjE2OjI0IDIwMDkgKzAyMDAKQEAgLTExMjUsNiArMTEyNSwxMyBAQAogCQkJ
Z290byBkZXR0YWNoX2Zyb250ZW5kOwogCQlicmVhazsKIAljYXNlIFNBQTcxMzRfQk9BUkRfSEFV
UFBBVUdFX0hWUjExMjA6CisJY2FzZSBTQUE3MTM0X0JPQVJEX1pPTElEX0hZQlJJRF9QQ0k6CisJ
CS8qIG1hdGNoIGludGVyZmFjZSB0eXBlIG9mIFNBQTcxM3ggYW5kIFREQTEwMDQ4ICovCisgICAg
ICAgICAgICAgICAgaWYgKHNhYTcxMzRfYm9hcmRzW2Rldi0+Ym9hcmRdLnRzX3R5cGUgPT0gU0FB
NzEzNF9NUEVHX1RTX1BBUkFMTEVMKSB7CisJCQloY3dfdGRhMTAwNDhfY29uZmlnLm91dHB1dF9t
b2RlID0gVERBMTAwNDhfUEFSQUxMRUxfT1VUUFVUOworCQl9IGVsc2UgeworCQkJaGN3X3RkYTEw
MDQ4X2NvbmZpZy5vdXRwdXRfbW9kZSA9IFREQTEwMDQ4X1NFUklBTF9PVVRQVVQ7CisJCX0KIAkJ
ZmUwLT5kdmIuZnJvbnRlbmQgPSBkdmJfYXR0YWNoKHRkYTEwMDQ4X2F0dGFjaCwKIAkJCQkJICAg
ICAgICZoY3dfdGRhMTAwNDhfY29uZmlnLAogCQkJCQkgICAgICAgJmRldi0+aTJjX2FkYXApOwpk
aWZmIC1yIDJiNDk4MTNmODQ4MiBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2Fh
NzEzNC5oCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEzNC9zYWE3MTM0LmgJ
VGh1IFNlcCAwMyAwOTowNjozNCAyMDA5IC0wMzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vc2FhNzEzNC9zYWE3MTM0LmgJTW9uIFNlcCAwNyAwMDoxNjoyNCAyMDA5ICswMjAwCkBA
IC0yOTcsNiArMjk3LDcgQEAKICNkZWZpbmUgU0FBNzEzNF9CT0FSRF9BVkVSTUVESUFfU1RVRElP
XzUwNSAgMTcwCiAjZGVmaW5lIFNBQTcxMzRfQk9BUkRfQkVIT0xEX1g3ICAgICAgICAgICAgIDE3
MQogI2RlZmluZSBTQUE3MTM0X0JPQVJEX1JPVkVSTUVESUFfTElOS19QUk9fRk0gMTcyCisjZGVm
aW5lIFNBQTcxMzRfQk9BUkRfWk9MSURfSFlCUklEX1BDSQkJMTczCiAKICNkZWZpbmUgU0FBNzEz
NF9NQVhCT0FSRFMgMzIKICNkZWZpbmUgU0FBNzEzNF9JTlBVVF9NQVggOAo=
--000e0cdf936aa6c9bd0472f89093
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--000e0cdf936aa6c9bd0472f89093--

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2-g19.free.fr ([212.27.42.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <castet.matthieu@free.fr>) id 1K4wjk-0005fV-LK
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 13:37:33 +0200
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 13AF212B6F3
	for <linux-dvb@linuxtv.org>; Sat,  7 Jun 2008 13:37:29 +0200 (CEST)
Received: from [192.168.0.3] (cac94-1-81-57-151-96.fbx.proxad.net
	[81.57.151.96])
	by smtp2-g19.free.fr (Postfix) with ESMTP id D132112B716
	for <linux-dvb@linuxtv.org>; Sat,  7 Jun 2008 13:37:28 +0200 (CEST)
Message-ID: <484A72D3.7070500@free.fr>
Date: Sat, 07 Jun 2008 13:36:51 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------070200060802030008050607"
Subject: [linux-dvb] [PATCH] Support faulty USB IDs on DIBUSB_MC
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

This is a multi-part message in MIME format.
--------------070200060802030008050607
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I got a LITE-ON USB2.0 DVB-T Tuner that loose it's cold state vid/pid 
and got  FX2 dev kit one (0x04b4, 0x8613).

This patch introduce an option similar to the DVB_USB_DIBUSB_MB_FAULTY :
it add the FX2 dev kit ids to the DIBUSB_MC driver if 
DVB_USB_DIBUSB_MC_FAULTY is selected.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

--------------070200060802030008050607
Content-Type: text/plain;
 name="dib3000c_faulty_id"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="dib3000c_faulty_id"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvS2NvbmZpZyBiL2RyaXZl
cnMvbWVkaWEvZHZiL2R2Yi11c2IvS2NvbmZpZwppbmRleCBmMDBhMGViLi5hNjU2YjliIDEw
MDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL0tjb25maWcKKysrIGIvZHJp
dmVycy9tZWRpYS9kdmIvZHZiLXVzYi9LY29uZmlnCkBAIC02OCw2ICs2OCwxMiBAQCBjb25m
aWcgRFZCX1VTQl9ESUJVU0JfTUMKIAkgIFNheSBZIGlmIHlvdSBvd24gc3VjaCBhIGRldmlj
ZSBhbmQgd2FudCB0byB1c2UgaXQuIFlvdSBzaG91bGQgYnVpbGQgaXQgYXMKIAkgIGEgbW9k
dWxlLgogCitjb25maWcgRFZCX1VTQl9ESUJVU0JfTUNfRkFVTFRZCisJYm9vbCAiU3VwcG9y
dCBmYXVsdHkgVVNCIElEcyIKKwlkZXBlbmRzIG9uIERWQl9VU0JfRElCVVNCX01DCisJaGVs
cAorCSAgU3VwcG9ydCBmb3IgZmF1bHR5IFVTQiBJRHMgZHVlIHRvIGFuIGludmFsaWQgRUVQ
Uk9NIG9uIHNvbWUgTElURS1PTiBkZXZpY2VzLgorCiBjb25maWcgRFZCX1VTQl9ESUIwNzAw
CiAJdHJpc3RhdGUgIkRpQmNvbSBEaUIwNzAwIFVTQiBEVkIgZGV2aWNlcyAoc2VlIGhlbHAg
Zm9yIHN1cHBvcnRlZCBkZXZpY2VzKSIKIAlkZXBlbmRzIG9uIERWQl9VU0IKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGlidXNiLW1jLmMgYi9kcml2ZXJzL21l
ZGlhL2R2Yi9kdmItdXNiL2RpYnVzYi1tYy5jCmluZGV4IDA1OWNlYzkuLmFiNTc2NmEgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGlidXNiLW1jLmMKKysrIGIv
ZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWJ1c2ItbWMuYwpAQCAtNDIsNiArNDIsMTcg
QEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGRpYnVzYl9kaWIzMDAwbWNfdGFibGUg
W10gPSB7CiAvKiAxMSAqLwl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9VTFRJTUFfRUxFQ1RST05J
QywJVVNCX1BJRF9BUlRFQ19UMTRfV0FSTSkgfSwKIC8qIDEyICovCXsgVVNCX0RFVklDRShV
U0JfVklEX0xFQURURUssCQlVU0JfUElEX1dJTkZBU1RfRFRWX0RPTkdMRV9DT0xEKSB9LAog
LyogMTMgKi8JeyBVU0JfREVWSUNFKFVTQl9WSURfTEVBRFRFSywJCVVTQl9QSURfV0lORkFT
VF9EVFZfRE9OR0xFX1dBUk0pIH0sCisvKgorICogWFhYOiBTb21lIExJVEUtT04gZGV2aWNl
cyBzZWVtIHRvIGxvb3NlIHRoZWlyIGlkIGFmdGVyIHNvbWUgdGltZS4gQmFkIEVFUFJPTSA/
Pz8uCisgKiAgICAgIFdlIGRvbid0IGNhdGNoIHRoZXNlIGZhdWx0eSBJRHMgKG5hbWVseSAn
Q3lwcmVzcyBGWDIgVVNCIGNvbnRyb2xsZXInKSB0aGF0CisgKiAgICAgIGhhdmUgYmVlbiBs
ZWZ0IG9uIHRoZSBkZXZpY2UuIElmIHlvdSBkb24ndCBoYXZlIHN1Y2ggYSBkZXZpY2UgYnV0
IGFuIExJVEUtT04KKyAqICAgICAgZGV2aWNlIHRoYXQncyBzdXBwb3NlZCB0byB3b3JrIHdp
dGggdGhpcyBkcml2ZXIgYnV0IGlzIG5vdCBkZXRlY3RlZCBieSBpdCwKKyAqICAgICAgZnJl
ZSB0byBlbmFibGUgQ09ORklHX0RWQl9VU0JfRElCVVNCX01DX0ZBVUxUWSB2aWEgeW91ciBr
ZXJuZWwgY29uZmlnLgorICovCisKKyNpZmRlZiBDT05GSUdfRFZCX1VTQl9ESUJVU0JfTUNf
RkFVTFRZCisvKiAxNCAqLwl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9DWVBSRVNTLAkJVVNCX1BJ
RF9VTFRJTUFfVFZCT1hfVVNCMl9GWF9DT0xEKSB9LAorI2VuZGlmCiAJCQl7IH0JCS8qIFRl
cm1pbmF0aW5nIGVudHJ5ICovCiB9OwogTU9EVUxFX0RFVklDRV9UQUJMRSAodXNiLCBkaWJ1
c2JfZGliMzAwMG1jX3RhYmxlKTsKQEAgLTg4LDcgKzk5LDExIEBAIHN0YXRpYyBzdHJ1Y3Qg
ZHZiX3VzYl9kZXZpY2VfcHJvcGVydGllcyBkaWJ1c2JfbWNfcHJvcGVydGllcyA9IHsKIAog
CS5nZW5lcmljX2J1bGtfY3RybF9lbmRwb2ludCA9IDB4MDEsCiAKKyNpZmRlZiBDT05GSUdf
RFZCX1VTQl9ESUJVU0JfTUNfRkFVTFRZCisJLm51bV9kZXZpY2VfZGVzY3MgPSA4LAorI2Vs
c2UKIAkubnVtX2RldmljZV9kZXNjcyA9IDcsCisjZW5kaWYKIAkuZGV2aWNlcyA9IHsKIAkJ
eyAgICJEaUJjb20gVVNCMi4wIERWQi1UIHJlZmVyZW5jZSBkZXNpZ24gKE1PRDMwMDBQKSIs
CiAJCQl7ICZkaWJ1c2JfZGliMzAwMG1jX3RhYmxlWzBdLCBOVUxMIH0sCkBAIC0xMTksNiAr
MTM0LDEzIEBAIHN0YXRpYyBzdHJ1Y3QgZHZiX3VzYl9kZXZpY2VfcHJvcGVydGllcyBkaWJ1
c2JfbWNfcHJvcGVydGllcyA9IHsKIAkJCXsgJmRpYnVzYl9kaWIzMDAwbWNfdGFibGVbMTJd
LCBOVUxMIH0sCiAJCQl7ICZkaWJ1c2JfZGliMzAwMG1jX3RhYmxlWzEzXSwgTlVMTCB9LAog
CQl9LAorI2lmZGVmIENPTkZJR19EVkJfVVNCX0RJQlVTQl9NQ19GQVVMVFkKKwkJeyAgICJM
SVRFLU9OIFVTQjIuMCBEVkItVCBUdW5lciAoZmF1bHR5IFVTQiBJRHMpIiwKKwkJICAgIC8q
IEFsc28gcmVicmFuZGVkIGFzIEludHVpeCBTODAwLCBUb3NoaWJhICovCisJCQl7ICZkaWJ1
c2JfZGliMzAwMG1jX3RhYmxlWzE0XSwgTlVMTCB9LAorCQkJeyBOVUxMIH0sCisJCX0sCisj
ZW5kaWYKIAkJeyBOVUxMIH0sCiAJfQogfTsK
--------------070200060802030008050607
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070200060802030008050607--

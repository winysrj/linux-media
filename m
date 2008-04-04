Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1JhoQv-0001Ep-8b
	for linux-dvb@linuxtv.org; Fri, 04 Apr 2008 18:06:30 +0200
Received: by wx-out-0506.google.com with SMTP id s11so123029wxc.17
	for <linux-dvb@linuxtv.org>; Fri, 04 Apr 2008 09:06:19 -0700 (PDT)
Message-ID: <c8b4dbe10804040906k56385599w3cdff9adf5145290@mail.gmail.com>
Date: Fri, 4 Apr 2008 17:06:18 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Another Sillyname" <anothersname@googlemail.com>
In-Reply-To: <a413d4880804032123r55fa7f68we895550dc61a24f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_5853_12159181.1207325178779"
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
	<d9def9db0803311559p3b4fe2a7gfb20477a2ac47144@mail.gmail.com>
	<c8b4dbe10804011406i6923397fw84de9393335dfee9@mail.gmail.com>
	<a413d4880804011641v1d20ebabo376d2b41b179b022@mail.gmail.com>
	<c8b4dbe10804020942r6930fd6fu144b1b445534fda8@mail.gmail.com>
	<a413d4880804021704g369cef0ak9b0998197ae847a2@mail.gmail.com>
	<c8b4dbe10804030611p6481043bgc6ed3cc0803fcadf@mail.gmail.com>
	<a413d4880804032123r55fa7f68we895550dc61a24f4@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Lifeview DVB-T from v4l-dvb and Pinnacle Hybrid USb
	from v4l-dvb-kernel......help
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

------=_Part_5853_12159181.1207325178779
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 4/4/08, Another Sillyname <anothersname@googlemail.com> wrote:
> Aidan
>
> Just to let you know that after tweaking around I've managed to get it
> working stable.  I had to add a sleep in modprobe.conf else the
> em2880-dvb module was trying to load before em28xx had 'settled'.
>
> Just in case you see the problem in the future I added this to my
> modprobe.conf file to fix the problem.....
>
> install em28xx /sbin/modprobe --ignore-install em28xx; /bin/sleep 2;
> /sbin/modprobe em2880-dvb

That really shouldn't happen. What problems were you seeing, exactly?

> I've been reading that once 2.6.25 kernel is released there will be a
> lot more support for the em28 products....hopefully it'll reduce some
> of these issues going forward.

The 2.6.25 code is basically just a slightly older version of v4l-dvb
upstream - it adds (analog only) support for a few devices. While
hopefully analog support for this device should at least make 2.6.26
as long as I get a patch tested and submitted on time, I don't expect
DVB-T support for any em28xx-based device will. Perhaps for 2.6.27,
perhaps not.

(By the way, if it's not too much hassle, could you check if the
attached patch against  http://linuxtv.org/hg/v4l-dvb works for
analog, especially that the device works correctly after being freshly
plugged in and that sound works? It shouldn't need the card= option,
and neither should the latest http://www.makomk.com/hg/v4l-dvb-em28xx.
If you do test the patch, be careful not to load em2880-dvb - it's not
compatible and you won't be able to unload it short of rebooting.)

> Best Regards and once again thanks for your help.
>
> J

------=_Part_5853_12159181.1207325178779
Content-Type: text/x-patch; name=em28xx-pinnacle-hybrid-pro-support.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=em28xx-pinnacle-hybrid-pro-support.patch

ZGlmZiAtciAzN2Q1YTAxYTE0Y2EgbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJE
TElTVC5lbTI4eHgKLS0tIGEvbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElT
VC5lbTI4eHgJV2VkIEFwciAwMiAxMToxMDo1OSAyMDA4IC0wNzAwCisrKyBiL2xpbnV4L0RvY3Vt
ZW50YXRpb24vdmlkZW80bGludXgvQ0FSRExJU1QuZW0yOHh4CUZyaSBBcHIgMDQgMTc6MDQ6MDcg
MjAwOCArMDEwMApAQCAtMTUsMyArMTUsNCBAQAogIDE0IC0+IFBpeGVsdmlldyBQcm9saW5rIFBs
YXlUViBVU0IgMi4wICAgICAgICAgKGVtMjgyMC9lbTI4NDApCiAgMTUgLT4gVi1HZWFyIFBvY2tl
dFRWICAgICAgICAgICAgICAgICAgICAgICAgICAoZW0yODAwKQogIDE2IC0+IEhhdXBwYXVnZSBX
aW5UViBIVlIgOTUwICAgICAgICAgICAgICAgICAgKGVtMjg4MCkgICAgICAgIFsyMDQwOjY1MTNd
CisgMTcgLT4gUGlubmFjbGUgSHlicmlkIFBybyAoRU0yODgxKSAgICAgICAgICAgICAoZW0yODgx
KQpkaWZmIC1yIDM3ZDVhMDFhMTRjYSBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9l
bTI4eHgtY2FyZHMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4
eHgtY2FyZHMuYwlXZWQgQXByIDAyIDExOjEwOjU5IDIwMDggLTA3MDAKKysrIGIvbGludXgvZHJp
dmVycy9tZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LWNhcmRzLmMJRnJpIEFwciAwNCAxNzowNDow
NyAyMDA4ICswMTAwCkBAIC03Miw2ICs3Miw3IEBACiAjZGVmaW5lIEVNMjgyMF9CT0FSRF9QUk9M
SU5LX1BMQVlUVl9VU0IyCTE0CiAjZGVmaW5lIEVNMjgwMF9CT0FSRF9WR0VBUl9QT0NLRVRUViAg
ICAgICAgICAgICAxNQogI2RlZmluZSBFTTI4ODBfQk9BUkRfSEFVUFBBVUdFX1dJTlRWX0hWUl85
NTAJMTYKKyNkZWZpbmUgRU0yODgxX0JPQVJEX1BJTk5BQ0xFX0hZQlJJRF9QUk8JMTcKIAogc3Ry
dWN0IGVtMjh4eF9ib2FyZCBlbTI4eHhfYm9hcmRzW10gPSB7CiAJW0VNMjgwMF9CT0FSRF9VTktO
T1dOXSA9IHsKQEAgLTQwNSw2ICs0MDYsMjcgQEAKIAkJCS5hbXV4ICAgICA9IEVNMjhYWF9BTVVY
X0xJTkVfSU4sCiAJCX0gfSwKIAl9LAorCVtFTTI4ODFfQk9BUkRfUElOTkFDTEVfSFlCUklEX1BS
T10gPSB7CisJCS5uYW1lICAgICAgICAgPSAiUGlubmFjbGUgSHlicmlkIFBybyAoRU0yODgxKSIs
CisJCS52Y2hhbm5lbHMgICAgPSAzLAorCQkudHVuZXJfdHlwZSAgID0gVFVORVJfWEMyMDI4LAor
CQkubXRzX2Zpcm13YXJlID0gMSwKKwkJLmRlY29kZXIgICAgICA9IEVNMjhYWF9UVlA1MTUwLAor
CQkuaW5wdXQgICAgICAgICAgPSB7IHsKKwkJCS50eXBlICAgICA9IEVNMjhYWF9WTVVYX1RFTEVW
SVNJT04sCisJCQkudm11eCAgICAgPSBUVlA1MTUwX0NPTVBPU0lURTAsCisJCQkuYW11eCAgICAg
PSAwLAorCQl9LCB7CisJCQkudHlwZSAgICAgPSBFTTI4WFhfVk1VWF9DT01QT1NJVEUxLAorCQkJ
LnZtdXggICAgID0gVFZQNTE1MF9DT01QT1NJVEUxLAorCQkJLmFtdXggICAgID0gMSwKKwkJfSwg
eworCQkJLnR5cGUgICAgID0gRU0yOFhYX1ZNVVhfU1ZJREVPLAorCQkJLnZtdXggICAgID0gVFZQ
NTE1MF9TVklERU8sCisJCQkuYW11eCAgICAgPSAxLAorCQl9IH0sCisJCS5hbmFsb2dfZ3BpbyA9
IDB4MDgwMDdkNmQsCisJfSwKIH07CiBjb25zdCB1bnNpZ25lZCBpbnQgZW0yOHh4X2Jjb3VudCA9
IEFSUkFZX1NJWkUoZW0yOHh4X2JvYXJkcyk7CiAKQEAgLTQ1OCw2ICs0ODAsNyBAQAogc3RhdGlj
IHN0cnVjdCBlbTI4eHhfaGFzaF90YWJsZSBlbTI4eHhfZWVwcm9tX2hhc2ggW10gPSB7CiAJLyog
UC9OOiBTQSA2MDAwMjA3MDQ2NSBUdW5lcjogVFZGNzUzMy1NRiAqLwogCXsweDZjZTA1YThmLCBF
TTI4MjBfQk9BUkRfUFJPTElOS19QTEFZVFZfVVNCMiwgVFVORVJfWU1FQ19UVkZfNTUzM01GfSwK
Kwl7MHhiODg0NmIyMCwgRU0yODgxX0JPQVJEX1BJTk5BQ0xFX0hZQlJJRF9QUk8sIFRVTkVSX1hD
MjAyOH0sCiB9OwogCiAvKiBJMkMgZGV2aWNlbGlzdCBoYXNoIHRhYmxlIGZvciBkZXZpY2VzIHdp
dGggZ2VuZXJpYyBVU0IgSURzICovCkBAIC03NDMsNiArNzY2LDMwIEBACiAjZW5kaWYKIAkJYnJl
YWs7CiAJfQorCWNhc2UgRU0yODgxX0JPQVJEX1BJTk5BQ0xFX0hZQlJJRF9QUk86CisJeworCQll
bTI4eHhfd3JpdGVfcmVncyhkZXYsIEkyQ19DTEtfUkVHLCAiXHg0YyIsIDEpOworCQltc2xlZXAo
MTApOworCQllbTI4eHhfd3JpdGVfcmVncyhkZXYsIDB4MDQsICJceDA4IiwgMSk7CisJCW1zbGVl
cCgxMDApOworCQllbTI4eHhfd3JpdGVfcmVncyhkZXYsIDB4MDgsICJceGZkIiwgMSk7CisJCW1z
bGVlcCgxMDApOworCQllbTI4eHhfd3JpdGVfcmVncyhkZXYsIDB4MDgsICJceGZkIiwgMSk7CisJ
CW1zbGVlcCgxMDApOworCQllbTI4eHhfd3JpdGVfcmVncyhkZXYsIDB4MDgsICJceGZmIiwgMSk7
CisJCW1zbGVlcCg1KTsKKwkJZW0yOHh4X3dyaXRlX3JlZ3MoZGV2LCBYQ0xLX1JFRywgIlx4Mjci
LCAxKTsgLyogc3dpdGNoIGVtMjg4MCByYyBwcm90b2NvbCAqLworI2lmIDAKKwkJZW0yODgwX2ly
X2F0dGFjaChkZXYsaXJfY29kZXNfcGlubmFjbGUyLEFSUkFZX1NJWkUoaXJfY29kZXNfcGlubmFj
bGUyKSwgZW0yODgwX2dldF9rZXlfcGlubmFjbGUpOworI2VuZGlmCisKKwkJZW0yOHh4X3dyaXRl
X3JlZ3MoZGV2LCAweDA4LCAiXHg2ZCIsIDEpOworCQltc2xlZXAoMTApOworCQllbTI4eHhfd3Jp
dGVfcmVncyhkZXYsIDB4MDgsICJceDdkIiwgMSk7CisJCW1zbGVlcCgxMCk7CisJCWJyZWFrOwor
CX0KKwkKIAljYXNlIEVNMjgyMF9CT0FSRF9LV09STERfUFZSVFYyODAwUkY6CiAJCS8qIEdQSU8g
ZW5hYmxlcyBzb3VuZCBvbiBLV09STEQgUFZSIFRWIDI4MDBSRiAqLwogCQllbTI4eHhfd3JpdGVf
cmVnc19yZXEoZGV2LCAweDAwLCAweDA4LCAiXHhmOSIsIDEpOwo=
------=_Part_5853_12159181.1207325178779
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_5853_12159181.1207325178779--

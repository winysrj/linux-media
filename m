Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I9rqgY012795
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 05:53:52 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.228])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7I9rFo1024466
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 05:53:35 -0400
Received: by wr-out-0506.google.com with SMTP id c49so1998123wra.19
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 02:53:15 -0700 (PDT)
Message-ID: <ea4209750808180253g426b3b91m5eebf56876ba722c@mail.gmail.com>
Date: Mon, 18 Aug 2008 11:53:15 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Henri Tuomola" <htuomola@gmail.com>
In-Reply-To: <6f18c5ee0808180153h7d25999bh6c5dba01127aace7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_15493_31636916.1219053195679"
References: <6f18c5ee0808180153h7d25999bh6c5dba01127aace7@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Terratec Cinergy DT XS Diversity new version
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

------=_Part_15493_31636916.1219053195679
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Henry, perhaps you forgot to modify something... I send you a patch for
the current hg version.

Albert

2008/8/18 Henri Tuomola <htuomola@gmail.com>

> Hi,
>
> I just got the Terratec Cinergy DT XS Diversity stick, the newer one that
> is
> mentioned in here:
>
> http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity#Identification
> ,
> with usb id 0ccd:0081. As suggested, I tried to patch the current
> hg-version
> with this patch:
> http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026911.html. However,
> the patch fails, apparently because contents of the dib0700_devices.c have
> changed since the diff was created. I think I figured out the syntax in
> there and made some modifications so that it should be fine. After this I
> ran "make" and then "modprobe dvb_usb_dib0700".
>
> In dmesg I only get this:
> dib0700: loaded with support for 7 different device-types
> usbcore: registered new interface driver dvb_usb_dib0700
>
> Seems that the card isn't detected? Any tips?
>
> I'm running gentoo-sources-2.6.24-r8 with the v4l hg sources.
>
> best regards,
> Henri
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

------=_Part_15493_31636916.1219053195679
Content-Type: text/x-diff; name=Diversity_2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk0wrt7p0
Content-Disposition: attachment; filename=Diversity_2.patch

ZGlmZiAtciBjYzYyNGJmNzQ4OWMgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIw
NzAwX2RldmljZXMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3
MDBfZGV2aWNlcy5jCVR1ZSBBdWcgMDUgMjE6MDA6MTEgMjAwOCArMDMwMAorKysgYi9saW51eC9k
cml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCU1vbiBBdWcgMTggMTE6
NTE6MDIgMjAwOCArMDIwMApAQCAtMTExOCw2ICsxMTE4LDcgQEAgc3RydWN0IHVzYl9kZXZpY2Vf
aWQgZGliMDcwMF91c2JfaWRfdGFibAogCXsgVVNCX0RFVklDRShVU0JfVklEX1RFUlJBVEVDLAlV
U0JfUElEX1RFUlJBVEVDX0NJTkVSR1lfVF9YWFMpIH0sCiAJeyBVU0JfREVWSUNFKFVTQl9WSURf
TEVBRFRFSywgICBVU0JfUElEX1dJTkZBU1RfRFRWX0RPTkdMRV9TVEs3NzAwUF8yKSB9LAogCXsg
VVNCX0RFVklDRShVU0JfVklEX0hBVVBQQVVHRSwgVVNCX1BJRF9IQVVQUEFVR0VfTk9WQV9URF9T
VElDS181MjAwOSkgfSwKKwl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9URVJSQVRFQywgCVVTQl9QSURf
VEVSUkFURUNfQ0lORVJHWV9EVF9YU19ESVZFUlNJVFlfMikgfSwKIAl7IDAgfQkJLyogVGVybWlu
YXRpbmcgZW50cnkgKi8KIH07CiBNT0RVTEVfREVWSUNFX1RBQkxFKHVzYiwgZGliMDcwMF91c2Jf
aWRfdGFibGUpOwpAQCAtMTM3Myw3ICsxMzc0LDcgQEAgc3RydWN0IGR2Yl91c2JfZGV2aWNlX3By
b3BlcnRpZXMgZGliMDcwMAogCQkJfQogCQl9LAogCi0JCS5udW1fZGV2aWNlX2Rlc2NzID0gMywK
KwkJLm51bV9kZXZpY2VfZGVzY3MgPSA0LAogCQkuZGV2aWNlcyA9IHsKIAkJCXsgICAiRGlCY29t
IFNUSzcwNzBQRCByZWZlcmVuY2UgZGVzaWduIiwKIAkJCQl7ICZkaWIwNzAwX3VzYl9pZF90YWJs
ZVsxN10sIE5VTEwgfSwKQEAgLTEzODUsNiArMTM4NiwxMCBAQCBzdHJ1Y3QgZHZiX3VzYl9kZXZp
Y2VfcHJvcGVydGllcyBkaWIwNzAwCiAJCQl9LAogCQkJeyAgICJIYXVwcGF1Z2UgTm92YS1URCBT
dGljayAoNTIwMDkpIiwKIAkJCQl7ICZkaWIwNzAwX3VzYl9pZF90YWJsZVszNV0sIE5VTEwgfSwK
KwkJCQl7IE5VTEwgfSwKKwkJCX0sCisJCQl7ICAgIlRlcnJhdGVjIENpbmVyZ3kgRFQgVVNCIFhT
IERpdmVyc2l0eSIsCisJCQkJeyAmZGliMDcwMF91c2JfaWRfdGFibGVbMzZdLCBOVUxMIH0sCiAJ
CQkJeyBOVUxMIH0sCiAJCQl9CiAJCX0KZGlmZiAtciBjYzYyNGJmNzQ4OWMgbGludXgvZHJpdmVy
cy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLWlkcy5oCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVk
aWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAlUdWUgQXVnIDA1IDIxOjAwOjExIDIwMDggKzAz
MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLWlkcy5oCU1v
biBBdWcgMTggMTE6NTE6MDIgMjAwOCArMDIwMApAQCAtMTQ3LDYgKzE0Nyw3IEBACiAjZGVmaW5l
IFVTQl9QSURfQVZFUk1FRElBX0hZQlJJRF9VTFRSQV9VU0JfTTAzOVJfRFZCVAkweDIwMzkKICNk
ZWZpbmUgVVNCX1BJRF9URUNITk9UUkVORF9DT05ORUNUX1MyNDAwICAgICAgICAgICAgICAgMHgz
MDA2CiAjZGVmaW5lIFVTQl9QSURfVEVSUkFURUNfQ0lORVJHWV9EVF9YU19ESVZFUlNJVFkJMHgw
MDVhCisjZGVmaW5lIFVTQl9QSURfVEVSUkFURUNfQ0lORVJHWV9EVF9YU19ESVZFUlNJVFlfMiAg
ICAgIDB4MDA4MQogI2RlZmluZSBVU0JfUElEX1RFUlJBVEVDX0NJTkVSR1lfSFRfVVNCX1hFCQkw
eDAwNTgKICNkZWZpbmUgVVNCX1BJRF9URVJSQVRFQ19DSU5FUkdZX0hUX0VYUFJFU1MJCTB4MDA2
MAogI2RlZmluZSBVU0JfUElEX1RFUlJBVEVDX0NJTkVSR1lfVF9YWFMJCQkweDAwNzgK
------=_Part_15493_31636916.1219053195679
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_15493_31636916.1219053195679--

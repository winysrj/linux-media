Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31KJx3h017373
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 16:19:59 -0400
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31KJlM6010776
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 16:19:47 -0400
Received: by gv-out-0910.google.com with SMTP id l14so401062gvf.13
	for <video4linux-list@redhat.com>; Tue, 01 Apr 2008 13:19:46 -0700 (PDT)
Message-ID: <37219a840804011319h6fa0d69elbf95b308236e2179@mail.gmail.com>
Date: Tue, 1 Apr 2008 16:19:45 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Ben Caldwell" <benny.caldwell@gmail.com>
In-Reply-To: <1dea8a6d0804010841h34f027e7lb4b5342fe45afbb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_22648_17522917.1207081185691"
References: <33ABD80B75296D43A316BFF5B0B52F5F0EEB1F@SRV-QS-MAIL5.lands.nsw>
	<1dea8a6d0804010841h34f027e7lb4b5342fe45afbb7@mail.gmail.com>
Cc: alan@redhat.com, Nicholas Magers <Nicholas.Magers@lands.nsw.gov.au>,
	LInux DVB <linux-dvb@linuxtv.org>, video4linux-list@redhat.com
Subject: Re: Dvico Dual 4 card not working.
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

------=_Part_22648_17522917.1207081185691
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Apr 1, 2008 at 11:41 AM, Ben Caldwell <benny.caldwell@gmail.com> wrote:
> On Tue, Apr 1, 2008 at 10:31 AM, Nicholas Magers <
>  After much plodding through changesets I have something to report. It seems
>  that the the dvico dual digital 4 card is broken in changesets after
>  d4df22377e83 (11 days ago).
>  It is interesting to note that the next change (the one that breaks it) is
>  "Removes video_dev from tuner-xc3028 config struct" - the dvico dual digital
>  4 has an xc3028.
>
>  So to get it working:
>  *hg update -r d4df22377e83
>  make clean
>  make rminstall
>  make release
>  make
>  make install*
>
>  Then reboot. One other interesting thing I have found is that sometimes
>  after compiling new modules I actually have to turn the PC off then on again
>  (rather than just a reboot) to get everything working properly.
>
>  - Ben


Can you try using the v4l-dvb master branch hg repository on
linuxtv.org again, after applying the attached patch (see below)

It is clear what went wrong on the Dual Digital 4 --

Mauro did some changes recently that use a "magic number" (yuck) to
differentiate between devices and manage multiple instances of the
xc2028 driver on a hybrid design.

He used i2c_adapter->algo_data to generate this "magic number" ,
which, IMHO is a very bad idea, especially since some digital-only
devices do not even define algo_data.  On the other hand,
i2c_adap->algo_data is a reasonable structure to use for the
"video_dev" pointer in the tuner_callback function, *if* it is
defined.

The patch in the link above uses the 'hybrid_tuner_request_state"
method to manage multiple instances of the device driver on a hybrid
design.  This uses a *much* safer method, using the i2c_adapter ID
along with the device i2c address to identify unique instances.  For
the "video_dev" pointer, the patch also uses a safer method:  If the
dvb_adapter device is defined, use fe->dvb->priv, otherwise, fall back
to Mauro's previous method of using i2c_adap->algo_data.

Please note:  This patch is intended for testing purposes only --
there is a remaining issue in this patch, where it doesn't destroy
some memory properly when tuner instances are destroyed.  I'll be
happy to fix that remaining issue after I receive some reports that
the larger issue is actually remedied by this patch.

Please let me know if this fixes the problem, and I'll produce a new
patch afterwards.

Regards,

Mike Krufky

------=_Part_22648_17522917.1207081185691
Content-Type: text/x-diff; name=xc-instance.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_feiwu6720
Content-Disposition: attachment; filename=xc-instance.patch

ZGlmZiAtciAwNzc2ZTQ4MDE5OTEgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby90dW5lci14YzIw
MjguYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3R1bmVyLXhjMjAyOC5jCUZyaSBN
YXIgMjggMTQ6NTI6NDQgMjAwOCAtMDMwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L3R1bmVyLXhjMjAyOC5jCVR1ZSBBcHIgMDEgMTU6NTc6MzggMjAwOCAtMDQwMApAQCAtNTcsNyAr
NTcsNyBAQCBNT0RVTEVfUEFSTV9ERVNDKGZpcm13YXJlX25hbWUsICJGaXJtd2FyCiBNT0RVTEVf
UEFSTV9ERVNDKGZpcm13YXJlX25hbWUsICJGaXJtd2FyZSBmaWxlIG5hbWUuIEFsbG93cyBvdmVy
cmlkaW5nIHRoZSAiCiAJCQkJImRlZmF1bHQgZmlybXdhcmUgbmFtZVxuIik7CiAKLXN0YXRpYyBM
SVNUX0hFQUQoeGMyMDI4X2xpc3QpOworc3RhdGljIExJU1RfSEVBRChoeWJyaWRfdHVuZXJfaW5z
dGFuY2VfbGlzdCk7CiBzdGF0aWMgREVGSU5FX01VVEVYKHhjMjAyOF9saXN0X211dGV4KTsKIAog
Lyogc3RydWN0IGZvciBzdG9yaW5nIGZpcm13YXJlIHRhYmxlICovCkBAIC03OSwxMiArNzksMTEg
QEAgc3RydWN0IGZpcm13YXJlX3Byb3BlcnRpZXMgewogfTsKIAogc3RydWN0IHhjMjAyOF9kYXRh
IHsKLQlzdHJ1Y3QgbGlzdF9oZWFkICAgICAgICB4YzIwMjhfbGlzdDsKKwlzdHJ1Y3QgbGlzdF9o
ZWFkICAgICAgICBoeWJyaWRfdHVuZXJfaW5zdGFuY2VfbGlzdDsKIAlzdHJ1Y3QgdHVuZXJfaTJj
X3Byb3BzICBpMmNfcHJvcHM7CiAJaW50ICAgICAgICAgICAgICAgICAgICAgKCp0dW5lcl9jYWxs
YmFjaykgKHZvaWQgKmRldiwKIAkJCQkJCSAgIGludCBjb21tYW5kLCBpbnQgYXJnKTsKIAl2b2lk
CQkJKnZpZGVvX2RldjsKLQlpbnQJCQljb3VudDsKIAlfX3UzMgkJCWZyZXF1ZW5jeTsKIAogCXN0
cnVjdCBmaXJtd2FyZV9kZXNjcmlwdGlvbiAqZmlybTsKQEAgLTEwOTUsMTkgKzEwOTQsMTIgQEAg
c3RhdGljIGludCB4YzIwMjhfZHZiX3JlbGVhc2Uoc3RydWN0IGR2YgogCiAJbXV0ZXhfbG9jaygm
eGMyMDI4X2xpc3RfbXV0ZXgpOwogCi0JcHJpdi0+Y291bnQtLTsKLQotCWlmICghcHJpdi0+Y291
bnQpIHsKLQkJbGlzdF9kZWwoJnByaXYtPnhjMjAyOF9saXN0KTsKLQotCQlrZnJlZShwcml2LT5j
dHJsLmZuYW1lKTsKLQotCQlmcmVlX2Zpcm13YXJlKHByaXYpOwotCQlrZnJlZShwcml2KTsKLQkJ
ZmUtPnR1bmVyX3ByaXYgPSBOVUxMOwotCX0KKwlpZiAocHJpdikKKwkJaHlicmlkX3R1bmVyX3Jl
bGVhc2Vfc3RhdGUocHJpdik7CiAKIAltdXRleF91bmxvY2soJnhjMjAyOF9saXN0X211dGV4KTsK
KworCWZlLT50dW5lcl9wcml2ID0gTlVMTDsKIAogCXJldHVybiAwOwogfQpAQCAtMTE3OSw3ICsx
MTcxLDcgQEAgc3RydWN0IGR2Yl9mcm9udGVuZCAqeGMyMDI4X2F0dGFjaChzdHJ1YwogCQkJCSAg
IHN0cnVjdCB4YzIwMjhfY29uZmlnICpjZmcpCiB7CiAJc3RydWN0IHhjMjAyOF9kYXRhICpwcml2
OwotCXZvaWQgICAgICAgICAgICAgICAqdmlkZW9fZGV2OworCWludCBpbnN0YW5jZTsKIAogCWlm
IChkZWJ1ZykKIAkJcHJpbnRrKEtFUk5fREVCVUcgInhjMjAyODogWGN2MjAyOC8zMDI4IGluaXQg
Y2FsbGVkIVxuIik7CkBAIC0xMTkyLDQ4ICsxMTg0LDQwIEBAIHN0cnVjdCBkdmJfZnJvbnRlbmQg
KnhjMjAyOF9hdHRhY2goc3RydWMKIAkJcmV0dXJuIE5VTEw7CiAJfQogCi0JdmlkZW9fZGV2ID0g
Y2ZnLT5pMmNfYWRhcC0+YWxnb19kYXRhOwotCi0JaWYgKGRlYnVnKQotCQlwcmludGsoS0VSTl9E
RUJVRyAieGMyMDI4OiB2aWRlb19kZXYgPSVwXG4iLCB2aWRlb19kZXYpOwotCiAJbXV0ZXhfbG9j
aygmeGMyMDI4X2xpc3RfbXV0ZXgpOwogCi0JbGlzdF9mb3JfZWFjaF9lbnRyeShwcml2LCAmeGMy
MDI4X2xpc3QsIHhjMjAyOF9saXN0KSB7Ci0JCWlmICgmcHJpdi0+aTJjX3Byb3BzLmFkYXAtPmRl
diA9PSAmY2ZnLT5pMmNfYWRhcC0+ZGV2KSB7Ci0JCQl2aWRlb19kZXYgPSBOVUxMOwotCQkJaWYg
KGRlYnVnKQotCQkJCXByaW50ayhLRVJOX0RFQlVHICJ4YzIwMjg6IHJldXNpbmcgZGV2aWNlXG4i
KTsKLQotCQkJYnJlYWs7Ci0JCX0KLQl9Ci0KLQlpZiAodmlkZW9fZGV2KSB7Ci0JCXByaXYgPSBr
emFsbG9jKHNpemVvZigqcHJpdiksIEdGUF9LRVJORUwpOwotCQlpZiAocHJpdiA9PSBOVUxMKSB7
Ci0JCQltdXRleF91bmxvY2soJnhjMjAyOF9saXN0X211dGV4KTsKLQkJCXJldHVybiBOVUxMOwot
CQl9Ci0KLQkJcHJpdi0+aTJjX3Byb3BzLmFkZHIgPSBjZmctPmkyY19hZGRyOwotCQlwcml2LT5p
MmNfcHJvcHMuYWRhcCA9IGNmZy0+aTJjX2FkYXA7Ci0JCXByaXYtPmkyY19wcm9wcy5uYW1lID0g
InhjMjAyOCI7Ci0KLQkJcHJpdi0+dmlkZW9fZGV2ID0gdmlkZW9fZGV2OworCWluc3RhbmNlID0g
aHlicmlkX3R1bmVyX3JlcXVlc3Rfc3RhdGUoc3RydWN0IHhjMjAyOF9kYXRhLCBwcml2LAorCQkJ
CQkgICAgICBoeWJyaWRfdHVuZXJfaW5zdGFuY2VfbGlzdCwKKwkJCQkJICAgICAgY2ZnLT5pMmNf
YWRhcCwgY2ZnLT5pMmNfYWRkciwKKwkJCQkJICAgICAgInhjMjAyOCIpOworCXN3aXRjaCAoaW5z
dGFuY2UpIHsKKwljYXNlIDA6CisJCS8qIG1lbW9yeSBhbGxvY2F0aW9uIGZhaWx1cmUgKi8KKwkJ
Z290byBmYWlsOworCQlicmVhazsKKwljYXNlIDE6CisJCS8qIG5ldyB0dW5lciBpbnN0YW5jZSAq
LwogCQlwcml2LT50dW5lcl9jYWxsYmFjayA9IGNmZy0+Y2FsbGJhY2s7CiAJCXByaXYtPmN0cmwu
bWF4X2xlbiA9IDEzOwogCiAJCW11dGV4X2luaXQoJnByaXYtPmxvY2spOwogCi0JCWxpc3RfYWRk
X3RhaWwoJnByaXYtPnhjMjAyOF9saXN0LCAmeGMyMDI4X2xpc3QpOwotCX0KLQotCWZlLT50dW5l
cl9wcml2ID0gcHJpdjsKLQlwcml2LT5jb3VudCsrOwotCi0JaWYgKGRlYnVnKQotCQlwcmludGso
S0VSTl9ERUJVRyAieGMyMDI4OiB1c2FnZSBjb3VudCBpcyAlaVxuIiwgcHJpdi0+Y291bnQpOwor
CQkvKiBhbmFsb2cgc2lkZSAodHVuZXItY29yZSkgdXNlcyBpMmNfYWRhcC0+YWxnb19kYXRhLgor
CQkgKiBkaWdpdGFsIHNpZGUgaXMgbm90IGd1YXJhbnRlZWQgdG8gaGF2ZSBhbGdvX2RhdGEgZGVm
aW5lZC4KKwkJICoKKwkJICogZGlnaXRhbCBzaWRlIHdpbGwgYWx3YXlzIGhhdmUgZmUtPmR2YiBk
ZWZpbmVkLgorCQkgKiBhbmFsb2cgc2lkZSAodHVuZXItY29yZSkgZG9lc24ndCAoeWV0KSBkZWZp
bmUgZmUtPmR2Yi4KKwkJICovCisJCXByaXYtPnZpZGVvX2RldiA9ICgoZmUtPmR2YikgJiYgKGZl
LT5kdmItPnByaXYpKSA/CisJCQkJICAgZmUtPmR2Yi0+cHJpdiA6IGNmZy0+aTJjX2FkYXAtPmFs
Z29fZGF0YTsKKworCQlmZS0+dHVuZXJfcHJpdiA9IHByaXY7CisJCWJyZWFrOworCWNhc2UgMjoK
KwkJLyogZXhpc3RpbmcgdHVuZXIgaW5zdGFuY2UgKi8KKwkJZmUtPnR1bmVyX3ByaXYgPSBwcml2
OworCQlicmVhazsKKwl9CiAKIAltZW1jcHkoJmZlLT5vcHMudHVuZXJfb3BzLCAmeGMyMDI4X2R2
Yl90dW5lcl9vcHMsCiAJICAgICAgIHNpemVvZih4YzIwMjhfZHZiX3R1bmVyX29wcykpOwpAQCAt
MTI0Niw2ICsxMjMwLDExIEBAIHN0cnVjdCBkdmJfZnJvbnRlbmQgKnhjMjAyOF9hdHRhY2goc3Ry
dWMKIAltdXRleF91bmxvY2soJnhjMjAyOF9saXN0X211dGV4KTsKIAogCXJldHVybiBmZTsKK2Zh
aWw6CisJbXV0ZXhfdW5sb2NrKCZ4YzIwMjhfbGlzdF9tdXRleCk7CisKKwl4YzIwMjhfZHZiX3Jl
bGVhc2UoZmUpOworCXJldHVybiBOVUxMOwogfQogCiBFWFBPUlRfU1lNQk9MKHhjMjAyOF9hdHRh
Y2gpOwo=
------=_Part_22648_17522917.1207081185691
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_22648_17522917.1207081185691--

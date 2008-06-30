Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5U53tvO027221
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 01:03:55 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5U53iNU016045
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 01:03:44 -0400
Received: by fg-out-1718.google.com with SMTP id e21so839817fga.7
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 22:03:43 -0700 (PDT)
Message-ID: <30353c3d0806292203p193ff610i866b938271391f81@mail.gmail.com>
Date: Mon, 30 Jun 2008 01:03:43 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <30353c3d0806292009r5556afd6s5d5e271d1c7ff575@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2831_17861832.1214802223686"
References: <30353c3d0806281807p7b78dcd2xe2a91d560ae6df12@mail.gmail.com>
	<200806300315.42610.laurent.pinchart@skynet.be>
	<30353c3d0806292009r5556afd6s5d5e271d1c7ff575@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] videodev: properly reference count video_device
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

------=_Part_2831_17861832.1214802223686
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Jun 29, 2008 at 11:09 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> On Sun, Jun 29, 2008 at 9:15 PM, Laurent Pinchart
> <laurent.pinchart@skynet.be> wrote:
>> Hi David,
>>
>> On Sunday 29 June 2008, David Ellingsworth wrote:
>>> I noticed that the video_device structure wasn't properly being
>>> reference counted. Under certain circumstances,
>>
>> Can you detail those certain circumstances ?
>>
> Sure.
>
> For drivers which have to handle unexpected disconnects, I.E. usb and
> pci drivers, it's possible for a user to physically remove the device
> while it is in use. In the usb/pci disconnect callback, the correct
> thing to do is to unregister the device in order to prevent future
> opens. When video_unregister_device is called in this context, it sets
> video_device[minor number] to NULL and calls device_unregister().
> device_unregister() causes the release callback to be called when the
> sysfs entry is no longer in use. Under most circumstances, the release
> callback occurs right after the call to device_unregister(). This will
> cause a crash in __video_do_ioctl(), called from video_ioctl2, when
> subsequent ioctls are encountered since the return value of
> video_devdata() is NULL
>
> Current drivers do one of two things to avoid this crash. They either
> use a custom ioctl callback and return an error when video_devdata()
> is NULL, or they delay the call to video_unregister_device until the
> final close occurs. The first solution means that if a usb/pci driver
> uses video_devdata() in its ioctl or release callback, it has to check
> that the return is not NULL. The second means the drivers must be
> prepared to handle opens after the pci/usb disconnect callback has
> been called since the video device is still registered.
>
> This patch prevents the video_device struct from being freed under the
> circumstances above, and should not affect the behavior of current
> drivers. The reference count is set to 1 during video_register_device,
> incremented during video_open, and decremented during video_close and
> video_unregister_device. Thus allowing for the following series of
The reference count is decremented in the sysfs release callback not
video_unregister_device.

> calls to occur.
>
> With patch:
> -----------------------------------------------------------
> usb/pci_probe -> video_register_device
> video_open -> usb/pci_open
> usb/pci_disconnect -> video_unregister_device
> video_ioctl2
> video_close -> usb/pci_close
> release_callback
>
> Without patch:
> -----------------------------------------------------------
> usb/pci_probe -> video_register_device
> video_open -> usb/pci_open
> usb/pci_disconnect -> video_unregister_device
> release_callback
> video_ioctl2 (crash)
>
> Without patch (crash avoidance #1)
> ----------------------------------------------------------
> usb/pci_probe -> video_register_device
> video_open -> usb/pci_open
> usb/pci_disconnect -> video_unregister_device
> release_callback
> usb/pci_ioctl (return err, video_devdata() is NULL)
> usb/pci_close (return err, video_devdata() is NULL)
>
> Without patch (crash avoidance #2)
> ----------------------------------------------------------
> usb/pci_probe -> video_register_device
> video_open -> usb/pci_open
> usb/pci_disconnect
> video_ioctl2
> usb/pci_close -> video_unregister_device
> release_callback
>
> Regards,
>
> David Ellingsworth
>
>>> it is possible that
>>> the release callback of the video_device struct is called while the
>>> device is still open thus causing a crash. This patch adds the
>>> necessary reference counting to the video_device struct in order to
>>> avoid freeing the video_device struct while it is still in use.
>>>
>>> Regards,
>>>
>>> David Ellingsworth
>>>
>

[RFC v3] videodev: add ref count to video_device

Moved mutex_[un]lock(&videodev_lock) calls from
video_unregister_device to the sysfs release callback. In v2 a call to
close and then video_unregister_device would have resulted in a
deadlock. The lock is not needed in video_unregister_device, but is
needed in the sysfs callback video_release since it could potentially
call video_free. Patch attached.

Regards,

David Ellingsworth

------=_Part_2831_17861832.1214802223686
Content-Type: text/x-diff;
	name=0001-videodev-add-ref-count-to-video_device.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi2lpnrx0
Content-Disposition: attachment;
	filename=0001-videodev-add-ref-count-to-video_device.patch

RnJvbSA4NDAxMWY5YjI5OTBmZTc5YjM4YTZmYzViOGIzYTVmNWFmZWQ0Mzk5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBNb24sIDMwIEp1biAyMDA4IDAwOjUzOjEyIC0wNDAwClN1YmplY3Q6IFtQ
QVRDSF0gdmlkZW9kZXY6IGFkZCByZWYgY291bnQgdG8gdmlkZW9fZGV2aWNlCgoKU2lnbmVkLW9m
Zi1ieTogRGF2aWQgRWxsaW5nc3dvcnRoIDxkYXZpZEBpZGVudGQuZHluZG5zLm9yZz4KLS0tCiBk
cml2ZXJzL21lZGlhL3ZpZGVvL3ZpZGVvZGV2LmMgfCAgIDc4ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0tLQogaW5jbHVkZS9tZWRpYS92NGwyLWRldi5oICAgICAgIHwgICAg
MyArKwogMiBmaWxlcyBjaGFuZ2VkLCA2NSBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3ZpZGVvZGV2LmMgYi9kcml2ZXJzL21l
ZGlhL3ZpZGVvL3ZpZGVvZGV2LmMKaW5kZXggMGQ1MjgxOS4uYmI2NDU5ZiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9tZWRpYS92aWRlby92aWRlb2Rldi5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8v
dmlkZW9kZXYuYwpAQCAtNDA2LDEwICs0MDYsMjAgQEAgdm9pZCB2aWRlb19kZXZpY2VfcmVsZWFz
ZShzdHJ1Y3QgdmlkZW9fZGV2aWNlICp2ZmQpCiB9CiBFWFBPUlRfU1lNQk9MKHZpZGVvX2Rldmlj
ZV9yZWxlYXNlKTsKIAotc3RhdGljIHZvaWQgdmlkZW9fcmVsZWFzZShzdHJ1Y3QgZGV2aWNlICpj
ZCkKKy8qCisgKglBY3RpdmUgZGV2aWNlcworICovCisKK3N0YXRpYyBzdHJ1Y3QgdmlkZW9fZGV2
aWNlICp2aWRlb19kZXZpY2VbVklERU9fTlVNX0RFVklDRVNdOworc3RhdGljIERFRklORV9NVVRF
WCh2aWRlb2Rldl9sb2NrKTsKKworLyogdmlkZW9kZXZfbG9jayBzaG91bGQgYmUgaGVsZCBiZWZv
cmUgY2FsbGluZyB0aGlzICovCitzdGF0aWMgdm9pZCB2aWRlb19mcmVlKHN0cnVjdCBrcmVmICpr
cmVmKQogewotCXN0cnVjdCB2aWRlb19kZXZpY2UgKnZmZCA9IGNvbnRhaW5lcl9vZihjZCwgc3Ry
dWN0IHZpZGVvX2RldmljZSwKLQkJCQkJCQkJY2xhc3NfZGV2KTsKKwlzdHJ1Y3QgdmlkZW9fZGV2
aWNlICp2ZmQgPQorCQljb250YWluZXJfb2Yoa3JlZiwgc3RydWN0IHZpZGVvX2RldmljZSwga3Jl
Zik7CisKKwl2aWRlb19kZXZpY2VbdmZkLT5taW5vcl0gPSBOVUxMOwogCiAjaWYgMQogCS8qIG5l
ZWRlZCB1bnRpbCBhbGwgZHJpdmVycyBhcmUgZml4ZWQgKi8KQEAgLTQxOSw2ICs0MjksMzEgQEAg
c3RhdGljIHZvaWQgdmlkZW9fcmVsZWFzZShzdHJ1Y3QgZGV2aWNlICpjZCkKIAl2ZmQtPnJlbGVh
c2UodmZkKTsKIH0KIAorc3RhdGljIGlubGluZSB2b2lkIHZpZGVvX2tyZWZfZ2V0KHN0cnVjdCB2
aWRlb19kZXZpY2UgKnZmZCkKK3sKKwlrcmVmX2dldCgmdmZkLT5rcmVmKTsKK30KKworLyogdmlk
ZW9kZXZfbG9jayBzaG91bGQgYmUgaGVsZCBiZWZvcmUgY2FsbGluZyB0aGlzICovCitzdGF0aWMg
aW5saW5lIHZvaWQgdmlkZW9fa3JlZl9wdXQoc3RydWN0IHZpZGVvX2RldmljZSAqdmZkKQorewor
CWtyZWZfcHV0KCZ2ZmQtPmtyZWYsIHZpZGVvX2ZyZWUpOworfQorCisvKgorICogY2FsbGVkIHdp
dGhpbiB0aGUgY29udGV4dCBvZiB2aWRlb191bnJlZ2lzdGVyX2RldmljZSB3aXRoCisgKiB2aWRl
b2Rldl9sb2NrIGhlbGQKKyAqLworc3RhdGljIHZvaWQgdmlkZW9fcmVsZWFzZShzdHJ1Y3QgZGV2
aWNlICpjZCkKK3sKKwlzdHJ1Y3QgdmlkZW9fZGV2aWNlICp2ZmQgPSBjb250YWluZXJfb2YoY2Qs
IHN0cnVjdCB2aWRlb19kZXZpY2UsCisJCQkJCQkJCWNsYXNzX2Rldik7CisKKwltdXRleF9sb2Nr
KCZ2aWRlb2Rldl9sb2NrKTsKKwl2aWRlb19rcmVmX3B1dCh2ZmQpOworCW11dGV4X3VubG9jaygm
dmlkZW9kZXZfbG9jayk7Cit9CisKIHN0YXRpYyBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSB2aWRl
b19kZXZpY2VfYXR0cnNbXSA9IHsKIAlfX0FUVFIobmFtZSwgU19JUlVHTywgc2hvd19uYW1lLCBO
VUxMKSwKIAlfX0FUVFIoaW5kZXgsIFNfSVJVR08sIHNob3dfaW5kZXgsIE5VTEwpLApAQCAtNDMx
LDE5ICs0NjYsMjcgQEAgc3RhdGljIHN0cnVjdCBjbGFzcyB2aWRlb19jbGFzcyA9IHsKIAkuZGV2
X3JlbGVhc2UgPSB2aWRlb19yZWxlYXNlLAogfTsKIAotLyoKLSAqCUFjdGl2ZSBkZXZpY2VzCi0g
Ki8KLQotc3RhdGljIHN0cnVjdCB2aWRlb19kZXZpY2UgKnZpZGVvX2RldmljZVtWSURFT19OVU1f
REVWSUNFU107Ci1zdGF0aWMgREVGSU5FX01VVEVYKHZpZGVvZGV2X2xvY2spOwotCiBzdHJ1Y3Qg
dmlkZW9fZGV2aWNlKiB2aWRlb19kZXZkYXRhKHN0cnVjdCBmaWxlICpmaWxlKQogewogCXJldHVy
biB2aWRlb19kZXZpY2VbaW1pbm9yKGZpbGUtPmZfcGF0aC5kZW50cnktPmRfaW5vZGUpXTsKIH0K
IEVYUE9SVF9TWU1CT0wodmlkZW9fZGV2ZGF0YSk7CiAKK3N0YXRpYyBpbnQgdmlkZW9fY2xvc2Uo
c3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCit7CisJdW5zaWduZWQgaW50
IG1pbm9yID0gaW1pbm9yKGlub2RlKTsKKwlzdHJ1Y3QgdmlkZW9fZGV2aWNlICp2Zmw7CisJaW50
IGVyciA9IDA7CisKKwltdXRleF9sb2NrKCZ2aWRlb2Rldl9sb2NrKTsKKwl2ZmwgPSB2aWRlb19k
ZXZpY2VbbWlub3JdOworCWVyciA9IHZmbC0+Zm9wcy0+cmVsZWFzZShpbm9kZSwgZmlsZSk7CisJ
dmlkZW9fa3JlZl9wdXQodmZsKTsKKwltdXRleF91bmxvY2soJnZpZGVvZGV2X2xvY2spOworCisJ
cmV0dXJuIGVycjsKK30KKwogLyoKICAqCU9wZW4gYSB2aWRlbyBkZXZpY2UgLSBGSVhNRTogT2Jz
b2xldGVkCiAgKi8KQEAgLTQ2OSwxMCArNTEyLDEzIEBAIHN0YXRpYyBpbnQgdmlkZW9fb3Blbihz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAkJfQogCX0KIAlvbGRfZm9w
cyA9IGZpbGUtPmZfb3A7Ci0JZmlsZS0+Zl9vcCA9IGZvcHNfZ2V0KHZmbC0+Zm9wcyk7Ci0JaWYo
ZmlsZS0+Zl9vcC0+b3BlbikKKwlmaWxlLT5mX29wID0gZm9wc19nZXQoJnZmbC0+cHJpdl9mb3Bz
KTsKKwlpZiAoZmlsZS0+Zl9vcC0+b3BlbikgeworCQl2aWRlb19rcmVmX2dldCh2ZmwpOwogCQll
cnIgPSBmaWxlLT5mX29wLT5vcGVuKGlub2RlLGZpbGUpOworCX0KIAlpZiAoZXJyKSB7CisJCXZp
ZGVvX2tyZWZfcHV0KHZmbCk7CiAJCWZvcHNfcHV0KGZpbGUtPmZfb3ApOwogCQlmaWxlLT5mX29w
ID0gZm9wc19nZXQob2xkX2ZvcHMpOwogCX0KQEAgLTIxNjYsNiArMjIxMiw4IEBAIGludCB2aWRl
b19yZWdpc3Rlcl9kZXZpY2VfaW5kZXgoc3RydWN0IHZpZGVvX2RldmljZSAqdmZkLCBpbnQgdHlw
ZSwgaW50IG5yLAogCX0KIAl2aWRlb19kZXZpY2VbaV09dmZkOwogCXZmZC0+bWlub3I9aTsKKwl2
ZmQtPnByaXZfZm9wcyA9ICp2ZmQtPmZvcHM7CisJdmZkLT5wcml2X2ZvcHMucmVsZWFzZSA9IHZp
ZGVvX2Nsb3NlOwogCiAJcmV0ID0gZ2V0X2luZGV4KHZmZCwgaW5kZXgpOwogCWlmIChyZXQgPCAw
KSB7CkBAIC0yMTc4LDYgKzIyMjYsNyBAQCBpbnQgdmlkZW9fcmVnaXN0ZXJfZGV2aWNlX2luZGV4
KHN0cnVjdCB2aWRlb19kZXZpY2UgKnZmZCwgaW50IHR5cGUsIGludCBuciwKIAogCW11dGV4X3Vu
bG9jaygmdmlkZW9kZXZfbG9jayk7CiAJbXV0ZXhfaW5pdCgmdmZkLT5sb2NrKTsKKwlrcmVmX2lu
aXQoJnZmZC0+a3JlZik7CiAKIAkvKiBzeXNmcyBjbGFzcyAqLwogCW1lbXNldCgmdmZkLT5jbGFz
c19kZXYsIDB4MDAsIHNpemVvZih2ZmQtPmNsYXNzX2RldikpOwpAQCAtMjIyMSwxMyArMjI3MCwx
MCBAQCBFWFBPUlRfU1lNQk9MKHZpZGVvX3JlZ2lzdGVyX2RldmljZV9pbmRleCk7CiAKIHZvaWQg
dmlkZW9fdW5yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0IHZpZGVvX2RldmljZSAqdmZkKQogewotCW11
dGV4X2xvY2soJnZpZGVvZGV2X2xvY2spOwotCWlmKHZpZGVvX2RldmljZVt2ZmQtPm1pbm9yXSE9
dmZkKQorCWlmICh2aWRlb19kZXZpY2VbdmZkLT5taW5vcl0gIT0gdmZkKQogCQlwYW5pYygidmlk
ZW9kZXY6IGJhZCB1bnJlZ2lzdGVyIik7CiAKLQl2aWRlb19kZXZpY2VbdmZkLT5taW5vcl09TlVM
TDsKIAlkZXZpY2VfdW5yZWdpc3RlcigmdmZkLT5jbGFzc19kZXYpOwotCW11dGV4X3VubG9jaygm
dmlkZW9kZXZfbG9jayk7CiB9CiBFWFBPUlRfU1lNQk9MKHZpZGVvX3VucmVnaXN0ZXJfZGV2aWNl
KTsKIApkaWZmIC0tZ2l0IGEvaW5jbHVkZS9tZWRpYS92NGwyLWRldi5oIGIvaW5jbHVkZS9tZWRp
YS92NGwyLWRldi5oCmluZGV4IDNjOTM0MTQuLjdkMjZiMjUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
bWVkaWEvdjRsMi1kZXYuaAorKysgYi9pbmNsdWRlL21lZGlhL3Y0bDItZGV2LmgKQEAgLTM0Miw2
ICszNDIsOSBAQCB2b2lkICpwcml2OwogCS8qIGZvciB2aWRlb2Rldi5jIGludGVuYWwgdXNhZ2Ug
LS0gcGxlYXNlIGRvbid0IHRvdWNoICovCiAJaW50IHVzZXJzOyAgICAgICAgICAgICAgICAgICAg
IC8qIHZpZGVvX2V4Y2x1c2l2ZV97b3BlbnxjbG9zZX0gLi4uICovCiAJc3RydWN0IG11dGV4IGxv
Y2s7ICAgICAgICAgICAgIC8qIC4uLiBoZWxwZXIgZnVuY3Rpb24gdXNlcyB0aGVzZSAgICovCisJ
LyogcHJpdmF0ZSBmaWxlIG9wcyBmb3IgcmVsZWFzZSBjYWxsYmFjayAqLworCXN0cnVjdCBmaWxl
X29wZXJhdGlvbnMgcHJpdl9mb3BzOworCXN0cnVjdCBrcmVmIGtyZWY7ICAgICAgICAgICAgICAv
KiBpbnRlcm5hbCByZWZlcmVuY2UgY291bnQgKi8KIH07CiAKIC8qIENsYXNzLWRldiB0byB2aWRl
by1kZXZpY2UgKi8KLS0gCjEuNS41LjEKCg==
------=_Part_2831_17861832.1214802223686
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_2831_17861832.1214802223686--

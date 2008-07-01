Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61KkaSF029894
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 16:46:37 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61KkOTh026671
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 16:46:24 -0400
Received: by rv-out-0506.google.com with SMTP id f6so66257rvb.51
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 13:46:23 -0700 (PDT)
Message-ID: <30353c3d0807011346yccc6ad1yab269d0b47068f15@mail.gmail.com>
Date: Tue, 1 Jul 2008 16:46:23 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: video4linux-list@redhat.com,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_4879_6718920.1214945183627"
Cc: 
Subject: [PATCH] videodev: fix sysfs kobj ref count
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

------=_Part_4879_6718920.1214945183627
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch duplicates the behavior seen by char_dev in videodev.
Please apply.

char_dev handles the kobject reference count as follows:
     1. Initializes it to 1 in device_register.
     2. Increments it in chrdev_open
     3. Decrements it in __fput(see fs/file_table.c) after the
file_operations.release callback
     4. Decrements it in device_unregister

videodev currently handles the kobject reference count as follows:
     1. Initializes it to 1 in device_register.
     2. Decrements it in device_unregister.

With this patch, videodev will handle the kobject reference count as follows:
     1. Initialize it to 1 in device_register.
     2. Increment it in video_open.
     3. Decrement it in video_close.
     4. Decrement it in device_unregister.

This allows the following sequences of events before the kobject ref
count reaches 0 and the sysfs release callback is called.
     1. device_register
     2. video_open
     3. video_close
     4. device_unregister

- and -

     1. device_register
     2. video_open
     3. device_unregister
     4. video_close

Once videodev has been converted to use the char_dev api, video_open
and video_close may be removed. Until then they are needed to mimic
char_dev's behavior and ensure that the sysfs callback occurs at the
appropriate time.

Regards,

David Ellingsworth

------=_Part_4879_6718920.1214945183627
Content-Type: text/x-diff;
 name=0001-videodev-fix-sysfs-kobj-ref-count.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
	filename=0001-videodev-fix-sysfs-kobj-ref-count.patch

RnJvbSAzNTRmNzJkNGVkNTg2MTgxM2IxNTA5ZDQzN2U1NTFjMTlmOGE2YWNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBUdWUsIDEgSnVsIDIwMDggMTY6MDQ6MjYgLTA0MDAKU3ViamVjdDogW1BB
VENIXSB2aWRlb2RldjogZml4IHN5c2ZzIGtvYmogcmVmIGNvdW50CgoKU2lnbmVkLW9mZi1ieTog
RGF2aWQgRWxsaW5nc3dvcnRoIDxkYXZpZEBpZGVudGQuZHluZG5zLm9yZz4KLS0tCiBkcml2ZXJz
L21lZGlhL3ZpZGVvL3ZpZGVvZGV2LmMgfCAgIDUyICsrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0KIGluY2x1ZGUvbWVkaWEvdjRsMi1kZXYuaCAgICAgICB8ICAgIDEgKwog
MiBmaWxlcyBjaGFuZ2VkLCAzNSBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3ZpZGVvZGV2LmMgYi9kcml2ZXJzL21lZGlhL3Zp
ZGVvL3ZpZGVvZGV2LmMKaW5kZXggMGQ1MjgxOS4uMGVmNTFiOCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9tZWRpYS92aWRlby92aWRlb2Rldi5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vdmlkZW9k
ZXYuYwpAQCAtNDA2LDE3ICs0MDYsMjMgQEAgdm9pZCB2aWRlb19kZXZpY2VfcmVsZWFzZShzdHJ1
Y3QgdmlkZW9fZGV2aWNlICp2ZmQpCiB9CiBFWFBPUlRfU1lNQk9MKHZpZGVvX2RldmljZV9yZWxl
YXNlKTsKIAorLyoKKyAqCUFjdGl2ZSBkZXZpY2VzCisgKi8KKworc3RhdGljIHN0cnVjdCB2aWRl
b19kZXZpY2UgKnZpZGVvX2RldmljZVtWSURFT19OVU1fREVWSUNFU107CitzdGF0aWMgREVGSU5F
X01VVEVYKHZpZGVvZGV2X2xvY2spOworCiBzdGF0aWMgdm9pZCB2aWRlb19yZWxlYXNlKHN0cnVj
dCBkZXZpY2UgKmNkKQogewogCXN0cnVjdCB2aWRlb19kZXZpY2UgKnZmZCA9IGNvbnRhaW5lcl9v
ZihjZCwgc3RydWN0IHZpZGVvX2RldmljZSwKIAkJCQkJCQkJY2xhc3NfZGV2KTsKIAotI2lmIDEK
LQkvKiBuZWVkZWQgdW50aWwgYWxsIGRyaXZlcnMgYXJlIGZpeGVkICovCi0JaWYgKCF2ZmQtPnJl
bGVhc2UpCi0JCXJldHVybjsKLSNlbmRpZgotCXZmZC0+cmVsZWFzZSh2ZmQpOworCW11dGV4X2xv
Y2soJnZpZGVvZGV2X2xvY2spOworCWlmICh2ZmQtPnJlbGVhc2UpCisJCXZmZC0+cmVsZWFzZSh2
ZmQpOworCXZpZGVvX2RldmljZVt2ZmQtPm1pbm9yXSA9IE5VTEw7CisJbXV0ZXhfdW5sb2NrKCZ2
aWRlb2Rldl9sb2NrKTsKIH0KIAogc3RhdGljIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlIHZpZGVv
X2RldmljZV9hdHRyc1tdID0gewpAQCAtNDMxLDE5ICs0MzcsMzAgQEAgc3RhdGljIHN0cnVjdCBj
bGFzcyB2aWRlb19jbGFzcyA9IHsKIAkuZGV2X3JlbGVhc2UgPSB2aWRlb19yZWxlYXNlLAogfTsK
IAotLyoKLSAqCUFjdGl2ZSBkZXZpY2VzCi0gKi8KLQotc3RhdGljIHN0cnVjdCB2aWRlb19kZXZp
Y2UgKnZpZGVvX2RldmljZVtWSURFT19OVU1fREVWSUNFU107Ci1zdGF0aWMgREVGSU5FX01VVEVY
KHZpZGVvZGV2X2xvY2spOwotCiBzdHJ1Y3QgdmlkZW9fZGV2aWNlKiB2aWRlb19kZXZkYXRhKHN0
cnVjdCBmaWxlICpmaWxlKQogewogCXJldHVybiB2aWRlb19kZXZpY2VbaW1pbm9yKGZpbGUtPmZf
cGF0aC5kZW50cnktPmRfaW5vZGUpXTsKIH0KIEVYUE9SVF9TWU1CT0wodmlkZW9fZGV2ZGF0YSk7
CiAKK3N0YXRpYyBpbnQgdmlkZW9fY2xvc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZp
bGUgKmZpbGUpCit7CisJdW5zaWduZWQgaW50IG1pbm9yID0gaW1pbm9yKGlub2RlKTsKKwlpbnQg
ZXJyID0gMDsKKwlzdHJ1Y3QgdmlkZW9fZGV2aWNlICp2Zmw7CisKKwltdXRleF9sb2NrKCZ2aWRl
b2Rldl9sb2NrKTsKKwl2ZmwgPSB2aWRlb19kZXZpY2VbbWlub3JdOworCisJaWYgKHZmbC0+Zm9w
cyAmJiB2ZmwtPmZvcHMtPnJlbGVhc2UpCisJCWVyciA9IHZmbC0+Zm9wcy0+cmVsZWFzZShpbm9k
ZSwgZmlsZSk7CisKKwltdXRleF91bmxvY2soJnZpZGVvZGV2X2xvY2spOworCWtvYmplY3RfcHV0
KCZ2ZmwtPmNsYXNzX2Rldi5rb2JqKTsKKworCXJldHVybiBlcnI7Cit9CisKIC8qCiAgKglPcGVu
IGEgdmlkZW8gZGV2aWNlIC0gRklYTUU6IE9ic29sZXRlZAogICovCkBAIC00NjksOCArNDg2LDgg
QEAgc3RhdGljIGludCB2aWRlb19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxl
ICpmaWxlKQogCQl9CiAJfQogCW9sZF9mb3BzID0gZmlsZS0+Zl9vcDsKLQlmaWxlLT5mX29wID0g
Zm9wc19nZXQodmZsLT5mb3BzKTsKLQlpZihmaWxlLT5mX29wLT5vcGVuKQorCWZpbGUtPmZfb3Ag
PSBmb3BzX2dldCgmdmZsLT5wcml2X2ZvcHMpOworCWlmKGZpbGUtPmZfb3AtPm9wZW4gJiYga29i
amVjdF9nZXQoJnZmbC0+Y2xhc3NfZGV2LmtvYmopKQogCQllcnIgPSBmaWxlLT5mX29wLT5vcGVu
KGlub2RlLGZpbGUpOwogCWlmIChlcnIpIHsKIAkJZm9wc19wdXQoZmlsZS0+Zl9vcCk7CkBAIC0y
MTc1LDYgKzIxOTIsOCBAQCBpbnQgdmlkZW9fcmVnaXN0ZXJfZGV2aWNlX2luZGV4KHN0cnVjdCB2
aWRlb19kZXZpY2UgKnZmZCwgaW50IHR5cGUsIGludCBuciwKIAl9CiAKIAl2ZmQtPmluZGV4ID0g
cmV0OworCXZmZC0+cHJpdl9mb3BzID0gKnZmZC0+Zm9wczsKKwl2ZmQtPnByaXZfZm9wcy5yZWxl
YXNlID0gdmlkZW9fY2xvc2U7CiAKIAltdXRleF91bmxvY2soJnZpZGVvZGV2X2xvY2spOwogCW11
dGV4X2luaXQoJnZmZC0+bG9jayk7CkBAIC0yMjIxLDEzICsyMjQwLDEwIEBAIEVYUE9SVF9TWU1C
T0wodmlkZW9fcmVnaXN0ZXJfZGV2aWNlX2luZGV4KTsKIAogdm9pZCB2aWRlb191bnJlZ2lzdGVy
X2RldmljZShzdHJ1Y3QgdmlkZW9fZGV2aWNlICp2ZmQpCiB7Ci0JbXV0ZXhfbG9jaygmdmlkZW9k
ZXZfbG9jayk7CiAJaWYodmlkZW9fZGV2aWNlW3ZmZC0+bWlub3JdIT12ZmQpCiAJCXBhbmljKCJ2
aWRlb2RldjogYmFkIHVucmVnaXN0ZXIiKTsKIAotCXZpZGVvX2RldmljZVt2ZmQtPm1pbm9yXT1O
VUxMOwogCWRldmljZV91bnJlZ2lzdGVyKCZ2ZmQtPmNsYXNzX2Rldik7Ci0JbXV0ZXhfdW5sb2Nr
KCZ2aWRlb2Rldl9sb2NrKTsKIH0KIEVYUE9SVF9TWU1CT0wodmlkZW9fdW5yZWdpc3Rlcl9kZXZp
Y2UpOwogCmRpZmYgLS1naXQgYS9pbmNsdWRlL21lZGlhL3Y0bDItZGV2LmggYi9pbmNsdWRlL21l
ZGlhL3Y0bDItZGV2LmgKaW5kZXggM2M5MzQxNC4uZDRmZTYxNyAxMDA2NDQKLS0tIGEvaW5jbHVk
ZS9tZWRpYS92NGwyLWRldi5oCisrKyBiL2luY2x1ZGUvbWVkaWEvdjRsMi1kZXYuaApAQCAtMzQy
LDYgKzM0Miw3IEBAIHZvaWQgKnByaXY7CiAJLyogZm9yIHZpZGVvZGV2LmMgaW50ZW5hbCB1c2Fn
ZSAtLSBwbGVhc2UgZG9uJ3QgdG91Y2ggKi8KIAlpbnQgdXNlcnM7ICAgICAgICAgICAgICAgICAg
ICAgLyogdmlkZW9fZXhjbHVzaXZlX3tvcGVufGNsb3NlfSAuLi4gKi8KIAlzdHJ1Y3QgbXV0ZXgg
bG9jazsgICAgICAgICAgICAgLyogLi4uIGhlbHBlciBmdW5jdGlvbiB1c2VzIHRoZXNlICAgKi8K
KwlzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHByaXZfZm9wczsgLyogdmlkZW9fY2xvc2UgKi8KIH07
CiAKIC8qIENsYXNzLWRldiB0byB2aWRlby1kZXZpY2UgKi8KLS0gCjEuNS41LjEKCg==
------=_Part_4879_6718920.1214945183627
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_4879_6718920.1214945183627--

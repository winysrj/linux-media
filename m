Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m624Fka4002660
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 00:15:46 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m624FZbj002230
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 00:15:35 -0400
Received: by fg-out-1718.google.com with SMTP id e21so96247fga.7
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 21:15:34 -0700 (PDT)
Message-ID: <30353c3d0807012115i6f53cf2l3bf615e526a3a3c@mail.gmail.com>
Date: Wed, 2 Jul 2008 00:15:34 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <30353c3d0807012026n60815935g82a6746e5ca67b1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2031_8175071.1214972134700"
References: <30353c3d0807011346yccc6ad1yab269d0b47068f15@mail.gmail.com>
	<200807012350.53604.laurent.pinchart@skynet.be>
	<30353c3d0807011528v561d4de8ycb7c3f1d8afc82f9@mail.gmail.com>
	<200807020104.52122.laurent.pinchart@skynet.be>
	<30353c3d0807011649n5b225ef7t11bbf36217427647@mail.gmail.com>
	<30353c3d0807012026n60815935g82a6746e5ca67b1a@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix sysfs kobj ref count
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

------=_Part_2031_8175071.1214972134700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Patch attached. Same as above but with the following format issue fixed:

[snip]
> @@ -469,8 +485,8 @@ static int video_open(struct inode *inode, struct
> file *file)
>                }
>        }
>        old_fops = file->f_op;
> -       file->f_op = fops_get(vfl->fops);
> -       if(file->f_op->open)
> +       file->f_op = fops_get(&vfl->priv_fops);
> +       if(file->f_op->open && kobject_get(&vfl->class_dev.kobj))
             ^^missing space between if and (

>                err = file->f_op->open(inode,file);
>        if (err) {
>                fops_put(file->f_op);

------=_Part_2031_8175071.1214972134700
Content-Type: text/x-diff; name=0001-videodev-fix-kobj-ref-count.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi5f0ojn0
Content-Disposition: attachment;
	filename=0001-videodev-fix-kobj-ref-count.patch

RnJvbSA2NTViY2ViMDlkNGI0ZmQ4YTM1ZTc2OThiNDcyMGE0YWY3NjUwOGU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBXZWQsIDIgSnVsIDIwMDggMDA6MDY6MDMgLTA0MDAKU3ViamVjdDogW1BB
VENIXSB2aWRlb2RldjogZml4IGtvYmogcmVmIGNvdW50CgoKU2lnbmVkLW9mZi1ieTogRGF2aWQg
RWxsaW5nc3dvcnRoIDxkYXZpZEBpZGVudGQuZHluZG5zLm9yZz4KLS0tCiBkcml2ZXJzL21lZGlh
L3ZpZGVvL3ZpZGVvZGV2LmMgfCAgIDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0tLS0KIGluY2x1ZGUvbWVkaWEvdjRsMi1kZXYuaCAgICAgICB8ICAgIDEgKwogMiBmaWxl
cyBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL21lZGlhL3ZpZGVvL3ZpZGVvZGV2LmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3Zp
ZGVvZGV2LmMKaW5kZXggMGQ1MjgxOS4uZTYyNTE2OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRp
YS92aWRlby92aWRlb2Rldi5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vdmlkZW9kZXYuYwpA
QCAtNDA2LDE3ICs0MDYsMjIgQEAgdm9pZCB2aWRlb19kZXZpY2VfcmVsZWFzZShzdHJ1Y3Qgdmlk
ZW9fZGV2aWNlICp2ZmQpCiB9CiBFWFBPUlRfU1lNQk9MKHZpZGVvX2RldmljZV9yZWxlYXNlKTsK
IAorLyoKKyAqCUFjdGl2ZSBkZXZpY2VzCisgKi8KKworc3RhdGljIHN0cnVjdCB2aWRlb19kZXZp
Y2UgKnZpZGVvX2RldmljZVtWSURFT19OVU1fREVWSUNFU107CitzdGF0aWMgREVGSU5FX01VVEVY
KHZpZGVvZGV2X2xvY2spOworCisvKiBtdXN0IGJlIGNhbGxlZCB3aXRoIHZpZGVvZGV2X2xvY2sg
aGVsZCAqLwogc3RhdGljIHZvaWQgdmlkZW9fcmVsZWFzZShzdHJ1Y3QgZGV2aWNlICpjZCkKIHsK
IAlzdHJ1Y3QgdmlkZW9fZGV2aWNlICp2ZmQgPSBjb250YWluZXJfb2YoY2QsIHN0cnVjdCB2aWRl
b19kZXZpY2UsCiAJCQkJCQkJCWNsYXNzX2Rldik7CiAKLSNpZiAxCi0JLyogbmVlZGVkIHVudGls
IGFsbCBkcml2ZXJzIGFyZSBmaXhlZCAqLwotCWlmICghdmZkLT5yZWxlYXNlKQotCQlyZXR1cm47
Ci0jZW5kaWYKLQl2ZmQtPnJlbGVhc2UodmZkKTsKKwlpZiAodmZkLT5yZWxlYXNlKQorCQl2ZmQt
PnJlbGVhc2UodmZkKTsKKwl2aWRlb19kZXZpY2VbdmZkLT5taW5vcl0gPSBOVUxMOwogfQogCiBz
dGF0aWMgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgdmlkZW9fZGV2aWNlX2F0dHJzW10gPSB7CkBA
IC00MzEsMTkgKzQzNiwzMCBAQCBzdGF0aWMgc3RydWN0IGNsYXNzIHZpZGVvX2NsYXNzID0gewog
CS5kZXZfcmVsZWFzZSA9IHZpZGVvX3JlbGVhc2UsCiB9OwogCi0vKgotICoJQWN0aXZlIGRldmlj
ZXMKLSAqLwotCi1zdGF0aWMgc3RydWN0IHZpZGVvX2RldmljZSAqdmlkZW9fZGV2aWNlW1ZJREVP
X05VTV9ERVZJQ0VTXTsKLXN0YXRpYyBERUZJTkVfTVVURVgodmlkZW9kZXZfbG9jayk7Ci0KIHN0
cnVjdCB2aWRlb19kZXZpY2UqIHZpZGVvX2RldmRhdGEoc3RydWN0IGZpbGUgKmZpbGUpCiB7CiAJ
cmV0dXJuIHZpZGVvX2RldmljZVtpbWlub3IoZmlsZS0+Zl9wYXRoLmRlbnRyeS0+ZF9pbm9kZSld
OwogfQogRVhQT1JUX1NZTUJPTCh2aWRlb19kZXZkYXRhKTsKIAorc3RhdGljIGludCB2aWRlb19j
bG9zZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKK3sKKwl1bnNpZ25l
ZCBpbnQgbWlub3IgPSBpbWlub3IoaW5vZGUpOworCWludCBlcnIgPSAwOworCXN0cnVjdCB2aWRl
b19kZXZpY2UgKnZmbDsKKworCXZmbCA9IHZpZGVvX2RldmljZVttaW5vcl07CisKKwlpZiAodmZs
LT5mb3BzICYmIHZmbC0+Zm9wcy0+cmVsZWFzZSkKKwkJZXJyID0gdmZsLT5mb3BzLT5yZWxlYXNl
KGlub2RlLCBmaWxlKTsKKworCW11dGV4X2xvY2soJnZpZGVvZGV2X2xvY2spOworCWtvYmplY3Rf
cHV0KCZ2ZmwtPmNsYXNzX2Rldi5rb2JqKTsKKwltdXRleF91bmxvY2soJnZpZGVvZGV2X2xvY2sp
OworCisJcmV0dXJuIGVycjsKK30KKwogLyoKICAqCU9wZW4gYSB2aWRlbyBkZXZpY2UgLSBGSVhN
RTogT2Jzb2xldGVkCiAgKi8KQEAgLTQ2OSw4ICs0ODUsOCBAQCBzdGF0aWMgaW50IHZpZGVvX29w
ZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCiAJCX0KIAl9CiAJb2xk
X2ZvcHMgPSBmaWxlLT5mX29wOwotCWZpbGUtPmZfb3AgPSBmb3BzX2dldCh2ZmwtPmZvcHMpOwot
CWlmKGZpbGUtPmZfb3AtPm9wZW4pCisJZmlsZS0+Zl9vcCA9IGZvcHNfZ2V0KCZ2ZmwtPnByaXZf
Zm9wcyk7CisJaWYgKGZpbGUtPmZfb3AtPm9wZW4gJiYga29iamVjdF9nZXQoJnZmbC0+Y2xhc3Nf
ZGV2LmtvYmopKQogCQllcnIgPSBmaWxlLT5mX29wLT5vcGVuKGlub2RlLGZpbGUpOwogCWlmIChl
cnIpIHsKIAkJZm9wc19wdXQoZmlsZS0+Zl9vcCk7CkBAIC0yMTc1LDYgKzIxOTEsOCBAQCBpbnQg
dmlkZW9fcmVnaXN0ZXJfZGV2aWNlX2luZGV4KHN0cnVjdCB2aWRlb19kZXZpY2UgKnZmZCwgaW50
IHR5cGUsIGludCBuciwKIAl9CiAKIAl2ZmQtPmluZGV4ID0gcmV0OworCXZmZC0+cHJpdl9mb3Bz
ID0gKnZmZC0+Zm9wczsKKwl2ZmQtPnByaXZfZm9wcy5yZWxlYXNlID0gdmlkZW9fY2xvc2U7CiAK
IAltdXRleF91bmxvY2soJnZpZGVvZGV2X2xvY2spOwogCW11dGV4X2luaXQoJnZmZC0+bG9jayk7
CkBAIC0yMjI1LDcgKzIyNDMsNiBAQCB2b2lkIHZpZGVvX3VucmVnaXN0ZXJfZGV2aWNlKHN0cnVj
dCB2aWRlb19kZXZpY2UgKnZmZCkKIAlpZih2aWRlb19kZXZpY2VbdmZkLT5taW5vcl0hPXZmZCkK
IAkJcGFuaWMoInZpZGVvZGV2OiBiYWQgdW5yZWdpc3RlciIpOwogCi0JdmlkZW9fZGV2aWNlW3Zm
ZC0+bWlub3JdPU5VTEw7CiAJZGV2aWNlX3VucmVnaXN0ZXIoJnZmZC0+Y2xhc3NfZGV2KTsKIAlt
dXRleF91bmxvY2soJnZpZGVvZGV2X2xvY2spOwogfQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9tZWRp
YS92NGwyLWRldi5oIGIvaW5jbHVkZS9tZWRpYS92NGwyLWRldi5oCmluZGV4IDNjOTM0MTQuLmQ0
ZmU2MTcgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbWVkaWEvdjRsMi1kZXYuaAorKysgYi9pbmNsdWRl
L21lZGlhL3Y0bDItZGV2LmgKQEAgLTM0Miw2ICszNDIsNyBAQCB2b2lkICpwcml2OwogCS8qIGZv
ciB2aWRlb2Rldi5jIGludGVuYWwgdXNhZ2UgLS0gcGxlYXNlIGRvbid0IHRvdWNoICovCiAJaW50
IHVzZXJzOyAgICAgICAgICAgICAgICAgICAgIC8qIHZpZGVvX2V4Y2x1c2l2ZV97b3BlbnxjbG9z
ZX0gLi4uICovCiAJc3RydWN0IG11dGV4IGxvY2s7ICAgICAgICAgICAgIC8qIC4uLiBoZWxwZXIg
ZnVuY3Rpb24gdXNlcyB0aGVzZSAgICovCisJc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBwcml2X2Zv
cHM7IC8qIHZpZGVvX2Nsb3NlICovCiB9OwogCiAvKiBDbGFzcy1kZXYgdG8gdmlkZW8tZGV2aWNl
ICovCi0tIAoxLjUuNS4xCgo=
------=_Part_2031_8175071.1214972134700
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_2031_8175071.1214972134700--

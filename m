Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8BGE5f5032479
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 12:14:05 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8BGDwl8022778
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 12:13:58 -0400
Received: by rn-out-0910.google.com with SMTP id k32so315854rnd.7
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 09:13:58 -0700 (PDT)
Message-ID: <fa4052ef0809110913g270b8a2dx3438086a2a9f2ca9@mail.gmail.com>
Date: Thu, 11 Sep 2008 12:13:57 -0400
From: Shane <gnome42@gmail.com>
To: video4linux-list <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_20877_29062122.1221149637950"
Subject: [PATCH] spca561: i2c_read fix
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

------=_Part_20877_29062122.1221149637950
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This makes auto gain functional on my cam.

04fc:0561 Sunplus Technology Co., Ltd Flexcam 100

(patch is also attached in case it gets mangled)

--- a/drivers/media/video/gspca/spca561.c
+++ b/drivers/media/video/gspca/spca561.c
@@ -225,7 +225,7 @@ static int i2c_read(struct gspca_dev *gspca_dev,
__u16 reg, __u8 mode)
        reg_w_val(gspca_dev->dev, 0x8802, (mode | 0x01));
        do {
                reg_r(gspca_dev, 0x8803, 1);
-               if (!gspca_dev->usb_buf)
+               if (!gspca_dev->usb_buf[0])
                        break;
        } while (--retry);
        if (retry == 0)


Shane Shrybman

------=_Part_20877_29062122.1221149637950
Content-Type: plain/text; name=spca561_i2c_read_fix.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkzknumo0
Content-Disposition: attachment; filename=spca561_i2c_read_fix.diff

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vZ3NwY2Evc3BjYTU2MS5jIGIvZHJpdmVy
cy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKaW5kZXggY2ZiYzllYi4uOTVmY2ZjYiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKKysrIGIvZHJpdmVy
cy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKQEAgLTIyNSw3ICsyMjUsNyBAQCBzdGF0aWMg
aW50IGkyY19yZWFkKHN0cnVjdCBnc3BjYV9kZXYgKmdzcGNhX2RldiwgX191MTYgcmVnLCBfX3U4
IG1vZGUpCiAJcmVnX3dfdmFsKGdzcGNhX2Rldi0+ZGV2LCAweDg4MDIsIChtb2RlIHwgMHgwMSkp
OwogCWRvIHsKIAkJcmVnX3IoZ3NwY2FfZGV2LCAweDg4MDMsIDEpOwotCQlpZiAoIWdzcGNhX2Rl
di0+dXNiX2J1ZikKKwkJaWYgKCFnc3BjYV9kZXYtPnVzYl9idWZbMF0pCiAJCQlicmVhazsKIAl9
IHdoaWxlICgtLXJldHJ5KTsKIAlpZiAocmV0cnkgPT0gMCkK
------=_Part_20877_29062122.1221149637950
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_20877_29062122.1221149637950--

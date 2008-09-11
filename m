Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8BGEA7s032523
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 12:14:11 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8BGE5K9022892
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 12:14:05 -0400
Received: by yw-out-2324.google.com with SMTP id 5so144698ywb.81
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 09:14:05 -0700 (PDT)
Message-ID: <fa4052ef0809110914x521b3a6cta32f907d1782cc30@mail.gmail.com>
Date: Thu, 11 Sep 2008 12:14:04 -0400
From: Shane <gnome42@gmail.com>
To: video4linux-list <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_20880_16683477.1221149644933"
Subject: [PATCH] spca561: add USB_DIR_OUT to reg_w_val()
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

------=_Part_20880_16683477.1221149644933
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Looks like USB_DIR_OUT was missing in reg_w_val(...)

--- a/drivers/media/video/gspca/spca561.c
+++ b/drivers/media/video/gspca/spca561.c
@@ -152,7 +152,7 @@ static void reg_w_val(struct usb_device *dev,
__u16 index, __u8 value)

        ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
                              0,                /* request */
-                             USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+                             USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
                              value, index, NULL, 0, 500);
        PDEBUG(D_USBO, "reg write: 0x%02x:0x%02x", index, value);
        if (ret < 0)


Shane Shrybman

------=_Part_20880_16683477.1221149644933
Content-Type: plain/text; name=spca561_add_USB_DIR_OUT_to_reg_w_val.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkzkqgrt0
Content-Disposition: attachment;
	filename=spca561_add_USB_DIR_OUT_to_reg_w_val.diff

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vZ3NwY2Evc3BjYTU2MS5jIGIvZHJpdmVy
cy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKaW5kZXggOTVmY2ZjYi4uYWQ0OTkzOSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKKysrIGIvZHJpdmVy
cy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKQEAgLTE1Miw3ICsxNTIsNyBAQCBzdGF0aWMg
dm9pZCByZWdfd192YWwoc3RydWN0IHVzYl9kZXZpY2UgKmRldiwgX191MTYgaW5kZXgsIF9fdTgg
dmFsdWUpCiAKIAlyZXQgPSB1c2JfY29udHJvbF9tc2coZGV2LCB1c2Jfc25kY3RybHBpcGUoZGV2
LCAwKSwKIAkJCSAgICAgIDAsCQkvKiByZXF1ZXN0ICovCi0JCQkgICAgICBVU0JfVFlQRV9WRU5E
T1IgfCBVU0JfUkVDSVBfREVWSUNFLAorCQkJICAgICAgVVNCX0RJUl9PVVQgfCBVU0JfVFlQRV9W
RU5ET1IgfCBVU0JfUkVDSVBfREVWSUNFLAogCQkJICAgICAgdmFsdWUsIGluZGV4LCBOVUxMLCAw
LCA1MDApOwogCVBERUJVRyhEX1VTQk8sICJyZWcgd3JpdGU6IDB4JTAyeDoweCUwMngiLCBpbmRl
eCwgdmFsdWUpOwogCWlmIChyZXQgPCAwKQo=
------=_Part_20880_16683477.1221149644933
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_20880_16683477.1221149644933--

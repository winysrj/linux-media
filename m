Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EJDV3f002935
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 15:13:31 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6EJDKVv019078
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 15:13:21 -0400
Received: by fk-out-0910.google.com with SMTP id e30so3285875fke.3
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 12:13:20 -0700 (PDT)
Message-ID: <30353c3d0807141213o5f2a160ag7b83063abf0cd0f6@mail.gmail.com>
Date: Mon, 14 Jul 2008 15:13:20 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_21182_25602362.1216062800108"
Cc: 
Subject: [PATCH] mdtv: remove obsolete Makefile entry
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

------=_Part_21182_25602362.1216062800108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Mauro,

I believe this was left over from the move drivers/media/mdtv to
drivers/media/dvb/siano patch.

Regards,

David Ellingsworth

[PATCH] mdtv: remove obsolete Makefile entry


Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index ec2102b..09a829d 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -6,4 +6,3 @@ obj-y += common/ video/

 obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb/
-obj-$(CONFIG_MDTV_ADAPTERS)  += mdtv/
\ No newline at end of file
-- 
1.5.6

------=_Part_21182_25602362.1216062800108
Content-Type: text/x-diff; name=0001-mdtv-remove-obsolete-Makefile-entry.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fingcwm30
Content-Disposition: attachment;
	filename=0001-mdtv-remove-obsolete-Makefile-entry.patch

RnJvbSA5NjE0MTZmMTdhYTU4YzQ4YTFhNDBmMjcwODVmMzAyM2E4YTk5ZDYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBFbGxpbmdzd29ydGggPGRhdmlkQGlkZW50ZC5keW5k
bnMub3JnPgpEYXRlOiBNb24sIDE0IEp1bCAyMDA4IDE1OjA2OjE5IC0wNDAwClN1YmplY3Q6IFtQ
QVRDSF0gbWR0djogcmVtb3ZlIG9ic29sZXRlIE1ha2VmaWxlIGVudHJ5CgoKU2lnbmVkLW9mZi1i
eTogRGF2aWQgRWxsaW5nc3dvcnRoIDxkYXZpZEBpZGVudGQuZHluZG5zLm9yZz4KLS0tCiBkcml2
ZXJzL21lZGlhL01ha2VmaWxlIHwgICAgMSAtCiAxIGZpbGVzIGNoYW5nZWQsIDAgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL01ha2VmaWxl
IGIvZHJpdmVycy9tZWRpYS9NYWtlZmlsZQppbmRleCBlYzIxMDJiLi4wOWE4MjlkIDEwMDY0NAot
LS0gYS9kcml2ZXJzL21lZGlhL01ha2VmaWxlCisrKyBiL2RyaXZlcnMvbWVkaWEvTWFrZWZpbGUK
QEAgLTYsNCArNiwzIEBAIG9iai15ICs9IGNvbW1vbi8gdmlkZW8vCiAKIG9iai0kKENPTkZJR19W
SURFT19ERVYpICs9IHJhZGlvLwogb2JqLSQoQ09ORklHX0RWQl9DT1JFKSAgKz0gZHZiLwotb2Jq
LSQoQ09ORklHX01EVFZfQURBUFRFUlMpICArPSBtZHR2LwpcIE5vIG5ld2xpbmUgYXQgZW5kIG9m
IGZpbGUKLS0gCjEuNS42Cgo=
------=_Part_21182_25602362.1216062800108
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_21182_25602362.1216062800108--

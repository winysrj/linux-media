Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8BGEJdb032683
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 12:14:20 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8BGE907022959
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 12:14:09 -0400
Received: by yx-out-2324.google.com with SMTP id 31so146750yxl.81
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 09:14:09 -0700 (PDT)
Message-ID: <fa4052ef0809110914s2a67f90n55ad014ff2857950@mail.gmail.com>
Date: Thu, 11 Sep 2008 12:14:09 -0400
From: Shane <gnome42@gmail.com>
To: video4linux-list <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_20882_9459528.1221149649521"
Subject: [PATCH] spca561: while balance -> white balance typo
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

------=_Part_20882_9459528.1221149649521
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--- a/drivers/media/video/gspca/spca561.c
+++ b/drivers/media/video/gspca/spca561.c
@@ -1064,7 +1064,7 @@ static struct ctrl sd_ctrls_12a[] = {
            {
                .id = V4L2_CID_DO_WHITE_BALANCE,
                .type = V4L2_CTRL_TYPE_INTEGER,
-               .name = "While Balance",
+               .name = "White Balance",
                .minimum = WHITE_MIN,
                .maximum = WHITE_MAX,
                .step = 1,


Shane Shrybman

------=_Part_20882_9459528.1221149649521
Content-Type: plain/text; name=spca561_while_balance_typo.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkzkulzm0
Content-Disposition: attachment; filename=spca561_while_balance_typo.diff

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vZ3NwY2Evc3BjYTU2MS5jIGIvZHJpdmVy
cy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKaW5kZXggYWQ0OTkzOS4uYzBhOTAzMCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKKysrIGIvZHJpdmVy
cy9tZWRpYS92aWRlby9nc3BjYS9zcGNhNTYxLmMKQEAgLTEwNjQsNyArMTA2NCw3IEBAIHN0YXRp
YyBzdHJ1Y3QgY3RybCBzZF9jdHJsc18xMmFbXSA9IHsKIAkgICAgewogCQkuaWQgPSBWNEwyX0NJ
RF9ET19XSElURV9CQUxBTkNFLAogCQkudHlwZSA9IFY0TDJfQ1RSTF9UWVBFX0lOVEVHRVIsCi0J
CS5uYW1lID0gIldoaWxlIEJhbGFuY2UiLAorCQkubmFtZSA9ICJXaGl0ZSBCYWxhbmNlIiwKIAkJ
Lm1pbmltdW0gPSBXSElURV9NSU4sCiAJCS5tYXhpbXVtID0gV0hJVEVfTUFYLAogCQkuc3RlcCA9
IDEsCg==
------=_Part_20882_9459528.1221149649521
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_20882_9459528.1221149649521--

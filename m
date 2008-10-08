Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m98FiALl001812
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 11:44:11 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m98FhNQa008847
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 11:43:24 -0400
Received: by gxk8 with SMTP id 8so8272682gxk.3
	for <video4linux-list@redhat.com>; Wed, 08 Oct 2008 08:43:23 -0700 (PDT)
Message-ID: <208cbae30810080843v49e35a66k8ecd3641caa82b5f@mail.gmail.com>
Date: Wed, 8 Oct 2008 19:43:23 +0400
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: tobias.lorenz@gmx.net
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_78554_1615424.1223480603272"
Cc: video4linux-list@redhat.com
Subject: [PATCH] radio-si470x: correct module name in radio/Kconfig
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

------=_Part_78554_1615424.1223480603272
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello, Tobias and video4linux-list.
Well, it's very simple patch - just replace module name in Kconfig.

Please, apply it carefully. It's unsafe to apply it to mainstream
kernel (may be i'm wrong) because of different end of Kconfig-file.
It's safe to apply it to development Mercurial repository on linuxtv.org.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

-- 
Best regards, Klimov Alexey

------=_Part_78554_1615424.1223480603272
Content-Type: application/octet-stream;
	name=radio-si470x-fix-module-name-Kconfig.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm24niwu0
Content-Disposition: attachment;
	filename=radio-si470x-fix-module-name-Kconfig.patch

ZGlmZiAtciA1ZWNkZWFhYTUxNzEgbGludXgvZHJpdmVycy9tZWRpYS9yYWRpby9LY29uZmlnCi0t
LSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvcmFkaW8vS2NvbmZpZwlNb24gT2N0IDA2IDExOjA3OjQ4
IDIwMDggLTA0MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9yYWRpby9LY29uZmlnCVR1ZSBP
Y3QgMDcgMTg6NTA6NDMgMjAwOCArMDQwMApAQCAtMzU5LDcgKzM1OSw3IEBACiAJICBjb21wdXRl
cidzIFVTQiBwb3J0LgogCiAJICBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBj
aG9vc2UgTSBoZXJlOiB0aGUKLQkgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCByYWRpby1zaWxhYnMu
CisJICBtb2R1bGUgd2lsbCBiZSBjYWxsZWQgcmFkaW8tc2k0NzB4LgogCiBjb25maWcgVVNCX01S
ODAwCiAJdHJpc3RhdGUgIkF2ZXJNZWRpYSBNUiA4MDAgVVNCIEZNIHJhZGlvIHN1cHBvcnQiCg==

------=_Part_78554_1615424.1223480603272
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_78554_1615424.1223480603272--

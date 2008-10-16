Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GIkZFj024887
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 14:46:35 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9GIkXxC007654
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 14:46:34 -0400
Received: by ey-out-2122.google.com with SMTP id 4so53053eyf.39
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 11:46:33 -0700 (PDT)
Message-ID: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
Date: Thu, 16 Oct 2008 22:46:33 +0400
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_103306_20239226.1224182793204"
Cc: 
Subject: [patch] radio-mr800: remove warn- and err- messages
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

------=_Part_103306_20239226.1224182793204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello, all

radio-mr800: remove warn and err messages

Patch removes warn() and err()-statements in radio/radio-mr800.c,
because of removing this macros from USB-subsystem.

-- 
Best regards, Klimov Alexey

------=_Part_103306_20239226.1224182793204
Content-Type: application/octet-stream;
	name=radio-mr800-remove-warn-and-err.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmaszvbb0
Content-Disposition: attachment; filename=radio-mr800-remove-warn-and-err.patch

ZGlmZiAtciAyNzA3MjNhNzMyMDcgbGludXgvZHJpdmVycy9tZWRpYS9yYWRpby9yYWRpby1tcjgw
MC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvcmFkaW8vcmFkaW8tbXI4MDAuYwlUdWUgT2N0
IDE0IDIwOjQ2OjUyIDIwMDggKzA0MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9yYWRpby9y
YWRpby1tcjgwMC5jCVR1ZSBPY3QgMTQgMjE6MjI6MTUgMjAwOCArMDQwMApAQCAtMzYyLDcgKzM2
Miw3IEBACiAKIAlyYWRpby0+Y3VyZnJlcSA9IGYtPmZyZXF1ZW5jeTsKIAlpZiAoYW1yYWRpb19z
ZXRmcmVxKHJhZGlvLCByYWRpby0+Y3VyZnJlcSkgPCAwKQotCQl3YXJuKCJTZXQgZnJlcXVlbmN5
IGZhaWxlZCIpOworCQlwcmludGsoS0VSTl9XQVJOSU5HIEtCVUlMRF9NT0ROQU1FICI6IFNldCBm
cmVxdWVuY3kgZmFpbGVkXG4iKTsKIAlyZXR1cm4gMDsKIH0KIApAQCAtNDE3LDEyICs0MTcsMTQg
QEAKIAljYXNlIFY0TDJfQ0lEX0FVRElPX01VVEU6CiAJCWlmIChjdHJsLT52YWx1ZSkgewogCQkJ
aWYgKGFtcmFkaW9fc3RvcChyYWRpbykgPCAwKSB7Ci0JCQkJd2FybigiYW1yYWRpb19zdG9wKCkg
ZmFpbGVkIik7CisJCQkJcHJpbnRrKEtFUk5fV0FSTklORyBLQlVJTERfTU9ETkFNRQorCQkJCQkJ
IjogYW1yYWRpb19zdG9wKCkgZmFpbGVkXG4iKTsKIAkJCQlyZXR1cm4gLTE7CiAJCQl9CiAJCX0g
ZWxzZSB7CiAJCQlpZiAoYW1yYWRpb19zdGFydChyYWRpbykgPCAwKSB7Ci0JCQkJd2FybigiYW1y
YWRpb19zdGFydCgpIGZhaWxlZCIpOworCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgS0JVSUxEX01P
RE5BTUUKKwkJCQkJCSI6IGFtcmFkaW9fc3RhcnQoKSBmYWlsZWRcbiIpOwogCQkJCXJldHVybiAt
MTsKIAkJCX0KIAkJfQpAQCAtNDc2LDEyICs0NzgsMTMgQEAKIAlyYWRpby0+bXV0ZWQgPSAxOwog
CiAJaWYgKGFtcmFkaW9fc3RhcnQocmFkaW8pIDwgMCkgewotCQl3YXJuKCJSYWRpbyBkaWQgbm90
IHN0YXJ0IHVwIHByb3Blcmx5Iik7CisJCXByaW50ayhLRVJOX1dBUk5JTkcgS0JVSUxEX01PRE5B
TUUKKwkJCQkJIjogUmFkaW8gZGlkIG5vdCBzdGFydCB1cCBwcm9wZXJseVxuIik7CiAJCXJhZGlv
LT51c2VycyA9IDA7CiAJCXJldHVybiAtRUlPOwogCX0KIAlpZiAoYW1yYWRpb19zZXRmcmVxKHJh
ZGlvLCByYWRpby0+Y3VyZnJlcSkgPCAwKQotCQl3YXJuKCJTZXQgZnJlcXVlbmN5IGZhaWxlZCIp
OworCQlwcmludGsoS0VSTl9XQVJOSU5HIEtCVUlMRF9NT0ROQU1FICI6IFNldCBmcmVxdWVuY3kg
ZmFpbGVkXG4iKTsKIAlyZXR1cm4gMDsKIH0KIApAQCAtNTA2LDcgKzUwOSw3IEBACiAJc3RydWN0
IGFtcmFkaW9fZGV2aWNlICpyYWRpbyA9IHVzYl9nZXRfaW50ZmRhdGEoaW50Zik7CiAKIAlpZiAo
YW1yYWRpb19zdG9wKHJhZGlvKSA8IDApCi0JCXdhcm4oImFtcmFkaW9fc3RvcCgpIGZhaWxlZCIp
OworCQlwcmludGsoS0VSTl9XQVJOSU5HIEtCVUlMRF9NT0ROQU1FICI6IGFtcmFkaW9fc3RvcCgp
IGZhaWxlZFxuIik7CiAKIAlwcmludGsoS0VSTl9JTkZPIEtCVUlMRF9NT0ROQU1FICI6IEdvaW5n
IGludG8gc3VzcGVuZC4uXG4iKTsKIApAQCAtNTE5LDcgKzUyMiw4IEBACiAJc3RydWN0IGFtcmFk
aW9fZGV2aWNlICpyYWRpbyA9IHVzYl9nZXRfaW50ZmRhdGEoaW50Zik7CiAKIAlpZiAoYW1yYWRp
b19zdGFydChyYWRpbykgPCAwKQotCQl3YXJuKCJhbXJhZGlvX3N0YXJ0KCkgZmFpbGVkIik7CisJ
CXByaW50ayhLRVJOX1dBUk5JTkcgS0JVSUxEX01PRE5BTUUKKwkJCQkJCSI6IGFtcmFkaW9fc3Rh
cnQoKSBmYWlsZWRcbiIpOwogCiAJcHJpbnRrKEtFUk5fSU5GTyBLQlVJTERfTU9ETkFNRSAiOiBD
b21pbmcgb3V0IG9mIHN1c3BlbmQuLlxuIik7CiAKQEAgLTYwMCw3ICs2MDQsOCBAQAogCiAJdmlk
ZW9fc2V0X2RydmRhdGEocmFkaW8tPnZpZGVvZGV2LCByYWRpbyk7CiAJaWYgKHZpZGVvX3JlZ2lz
dGVyX2RldmljZShyYWRpby0+dmlkZW9kZXYsIFZGTF9UWVBFX1JBRElPLCByYWRpb19ucikpIHsK
LQkJd2FybigiQ291bGQgbm90IHJlZ2lzdGVyIHZpZGVvIGRldmljZSIpOworCQlwcmludGsoS0VS
Tl9XQVJOSU5HIEtCVUlMRF9NT0ROQU1FCisJCQkJCSI6IENvdWxkIG5vdCByZWdpc3RlciB2aWRl
byBkZXZpY2VcbiIpOwogCQl2aWRlb19kZXZpY2VfcmVsZWFzZShyYWRpby0+dmlkZW9kZXYpOwog
CQlrZnJlZShyYWRpby0+YnVmZmVyKTsKIAkJa2ZyZWUocmFkaW8pOwpAQCAtNjE4LDcgKzYyMyw4
IEBACiAJcHJpbnRrKEtFUk5fSU5GTyBLQlVJTERfTU9ETkFNRSAiOiAiCiAJCQlEUklWRVJfVkVS
U0lPTiAiICIgRFJJVkVSX0RFU0MgIlxuIik7CiAJaWYgKHJldHZhbCkKLQkJZXJyKCJ1c2JfcmVn
aXN0ZXIgZmFpbGVkLiBFcnJvciBudW1iZXIgJWQiLCByZXR2YWwpOworCQlwcmludGsoS0VSTl9F
UlIgS0JVSUxEX01PRE5BTUUKKwkJCSI6IHVzYl9yZWdpc3RlciBmYWlsZWQuIEVycm9yIG51bWJl
ciAlZFxuIiwgcmV0dmFsKTsKIAlyZXR1cm4gcmV0dmFsOwogfQogCg==
------=_Part_103306_20239226.1224182793204
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_103306_20239226.1224182793204--

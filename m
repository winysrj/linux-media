Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:49653 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaHQJPL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Aug 2014 05:15:11 -0400
Received: by mail-qg0-f47.google.com with SMTP id i50so3643134qgf.34
        for <linux-media@vger.kernel.org>; Sun, 17 Aug 2014 02:15:10 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Aug 2014 19:15:10 +1000
Message-ID: <CAOriPh+ACHxUb5pyNWV3H3JVPoWcKQaZitL5E+KWzZTphURgJA@mail.gmail.com>
Subject: Updated dvb-t/au-Melbourne scan table
From: Paul Freeman <pfcomptech@gmail.com>
To: linux-media@vger.kernel.org
Cc: Peter Urbanec <git.dtv-scan-tables@urbanec.net>,
	Olliver Schinagl <oliver@schinagl.nl>
Content-Type: multipart/mixed; boundary=047d7bdc8d5ef1c3b10500cfb0b8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--047d7bdc8d5ef1c3b10500cfb0b8
Content-Type: text/plain; charset=UTF-8

Attached is a diff patch file to update dvb-t/au-Melbourne for the new
transmission frequency for SBS which came into effect in early 2014 as
well as adding channel 31, a community channel.

Could this please be considered for patching the existing file?

Regards

Paul

--047d7bdc8d5ef1c3b10500cfb0b8
Content-Type: text/plain; charset=US-ASCII; name="scan_au-Melbourne.diff.txt"
Content-Disposition: attachment; filename="scan_au-Melbourne.diff.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hyy5ouuk0

LS0tIGEvZHZiLXQvYXUtTWVsYm91cm5lCTIwMTQtMDgtMTcgMTg6NDA6MjUuODM5MTczNDUyICsx
MDAwCisrKyBiL2R2Yi10L2F1LU1lbGJvdXJuZQkyMDE0LTA4LTE3IDE4OjUwOjE2Ljc1MDUyMDI1
NiArMTAwMApAQCAtMSwxMiArMSwyMyBAQAotIyBBdXN0cmFsaWEgLyBNZWxib3VybmUgKE10IERh
bmRlbm9uZyB0cmFuc21pdHRlcnMpCi0jIFQgZnJlcSBidyBmZWNfaGkgZmVjX2xvIG1vZCB0cmFu
c21pc3Npb24tbW9kZSBndWFyZC1pbnRlcnZhbCBoaWVyYXJjaHkKLSMgQUJDCi1UIDIyNjUwMDAw
MCA3TUh6IDMvNCBOT05FIFFBTTY0IDhrIDEvMTYgTk9ORQotIyBTZXZlbgotVCAxNzc1MDAwMDAg
N01IeiAzLzQgTk9ORSBRQU02NCA4ayAxLzE2IE5PTkUKLSMgTmluZQotVCAxOTE2MjUwMDAgN01I
eiAzLzQgTk9ORSBRQU02NCA4ayAxLzE2IE5PTkUKLSMgVGVuCi1UIDIxOTUwMDAwMCA3TUh6IDMv
NCBOT05FIFFBTTY0IDhrIDEvMTYgTk9ORQotIyBTQlMKLVQgNTM2NjI1MDAwIDdNSHogMi8zIE5P
TkUgUUFNNjQgOGsgMS84IE5PTkUKKyMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KKyMgZmlsZSBhdXRv
bWF0aWNhbGx5IGdlbmVyYXRlZCBieSB3X3NjYW4KKyMgKGh0dHA6Ly93aXJiZWwuaHRwYy1mb3J1
bS5kZS93X3NjYW4vaW5kZXgyLmh0bWwpCisjISA8d19zY2FuPiAyMDEzMDMzMSAxIDAgVEVSUkVT
VFJJQUwgQVUgPC93X3NjYW4+CisjLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCisjIGxvY2F0aW9uIGFu
ZCBwcm92aWRlcjogQXVzdHJhbGlhIC8gTWVsYm91cm5lIChNdCBEYW5kZW5vbmcgdHJhbnNtaXR0
ZXJzKQorIyBkYXRlICh5eXl5LW1tLWRkKSAgICA6IDIwMTQtMDgtMTcKKyMgcHJvdmlkZWQgYnkg
KG9wdCkgICAgOiA8eW91ciBuYW1lIG9yIGVtYWlsIGhlcmU+CisjCisjIFRbMl0gW3BscF9pZF0g
W3N5c3RlbV9pZF0gPGZyZXE+IDxidz4gPGZlY19oaT4gPGZlY19sbz4gPG1vZD4gPHRtPiA8Z3Vh
cmQ+IDxoaT4gWyMgY29tbWVudF0KKyMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KKyMgU2V2ZW4gTmV0
d29yaworVCAxNzc1MDAwMDAgN01IeiBBVVRPIEFVVE8gUUFNNjQgOGsgMS8xNiBOT05FCisjIFNC
UyBNZWxib3VybmUKK1QgMTg0NTAwMDAwIDdNSHogQVVUTyBBVVRPIFFBTTY0IDhrIDEvOCBOT05F
CisjIE5pbmUgTmV0d29yayBBdXN0cmFsaWEKK1QgMTkxNjI1MDAwIDdNSHogQVVUTyBBVVRPIFFB
TTY0IDhrIDEvMTYgTk9ORQorIyBOZXR3b3JrIFRFTgorVCAyMTk1MDAwMDAgN01IeiBBVVRPIEFV
VE8gUUFNNjQgOGsgMS8xNiBOT05FCisjIEFCQyBNZWxib3VybmUKK1QgMjI2NTAwMDAwIDdNSHog
QVVUTyBBVVRPIFFBTTY0IDhrIDEvMTYgTk9ORQorIyBDMzEKK1QgNTU3NjI1MDAwIDdNSHogQVVU
TyBBVVRPIFFQU0sgOGsgMS8xNiBOT05FCg==
--047d7bdc8d5ef1c3b10500cfb0b8--

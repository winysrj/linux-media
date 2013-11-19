Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:33230 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053Ab3KSN2a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 08:28:30 -0500
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C8FA7116
	for <linux-media@vger.kernel.org>; Tue, 19 Nov 2013 13:27:56 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas2.st.com [10.75.90.16])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id ECD3B50DB
	for <linux-media@vger.kernel.org>; Tue, 19 Nov 2013 13:15:02 +0000 (GMT)
From: Alain VOLMAT <alain.volmat@st.com>
To: LMML <linux-media@vger.kernel.org>
Date: Tue, 19 Nov 2013 14:28:27 +0100
Subject: [PATCH] [v4l-utils] Fix configure.ac --disable-v4l-utils option
Message-ID: <E27519AE45311C49887BE8C438E68FAA013CA68BC8E0@SAFEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CldoZW4gdXNpbmcgQUNfQVJHX0VOQUJMRSB3aXRoIGEgc3RyaW5nIGNvbnRhaW5pbmcgLSBpbiBp
dCwgdGhlIHZhcmlhYmxlIGNyZWF0ZWQgd2lsbCBjb250YWlucyBhIF8gaW5zdGVhZCBvZiB0aGUg
LS4KVGh1cyBmb3IgQUNfQVJHX0VOQUJMRSh2NGwtdXRpbHMgLi4uLCB0aGUgdmFyaWFibGUgZW5h
YmxlX3Y0bF91dGlscyBtdXN0IGJlIGNoZWNrZWQuCgpTaWduZWQtb2ZmLWJ5OiBBbGFpbiBWb2xt
YXQgPGFsYWluLnZvbG1hdEBzdC5jb20+Ci0tLQogY29uZmlndXJlLmFjIHwgMiArLQogMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvY29u
ZmlndXJlLmFjIGIvY29uZmlndXJlLmFjCmluZGV4IGM5YWYxZmQuLjQwODBkMWUgMTAwNjQ0Ci0t
LSBhL2NvbmZpZ3VyZS5hYworKysgYi9jb25maWd1cmUuYWMKQEAgLTI0OSw3ICsyNDksNyBAQCBB
Q19BUkdfRU5BQkxFKHF2NGwyLAogCiBBTV9DT05ESVRJT05BTChbV0lUSF9MSUJEVkJWNV0sIFt0
ZXN0IHgkZW5hYmxlX2xpYmR2YnY1ID0geHllc10pCiBBTV9DT05ESVRJT05BTChbV0lUSF9MSUJW
NExdLCBbdGVzdCB4JGVuYWJsZV9saWJ2NGwgIT0geG5vXSkKLUFNX0NPTkRJVElPTkFMKFtXSVRI
X1Y0TFVUSUxTXSwgW3Rlc3QgeCRlbmFibGVfdjRsdXRpbHMgIT0geG5vXSkKK0FNX0NPTkRJVElP
TkFMKFtXSVRIX1Y0TFVUSUxTXSwgW3Rlc3QgeCRlbmFibGVfdjRsX3V0aWxzICE9ICJ4bm8iXSkK
IEFNX0NPTkRJVElPTkFMKFtXSVRIX1FWNEwyXSwgW3Rlc3QgJHtxdF9wa2djb25maWd9ID0gdHJ1
ZSAtYSB4JGVuYWJsZV9xdjRsMiAhPSB4bm9dKQogQU1fQ09ORElUSU9OQUwoW1dJVEhfVjRMX1BM
VUdJTlNdLCBbdGVzdCB4JGVuYWJsZV9saWJ2NGwgIT0geG5vIC1hIHgkZW5hYmxlX3NoYXJlZCAh
PSB4bm9dKQogQU1fQ09ORElUSU9OQUwoW1dJVEhfVjRMX1dSQVBQRVJTXSwgW3Rlc3QgeCRlbmFi
bGVfbGlidjRsICE9IHhubyAtYSB4JGVuYWJsZV9zaGFyZWQgIT0geG5vXSkKLS0gCjEuOC4xLjQK
Cg==

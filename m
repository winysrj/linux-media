Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13841 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaE1IG5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 04:06:57 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N69007W7YJICZ70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 May 2014 09:06:54 +0100 (BST)
From: Joaquin Anton Guirao <j.guirao@samsung.com>
To: linux-media@vger.kernel.org
Cc: Michal Godek <m.godek@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH] dvb-apps : libdvben50221 : fix size of "close_session_response"
Date: Wed, 28 May 2014 10:06:57 +0200
Message-id: <00a001cf7a4b$cbfc28f0$63f47ad0$%guirao@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: base64
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VGhlIGV4cGVjdGVkIGRhdGEgbGVuZ2h0IG9mIHRoZSBzZXNzaW9uIGxheWVyIG1lc3NhZ2UNCiJj
bG9zZV9zZXNzaW9uX3Jlc3BvbnNlIiBzaG91bGQgYmUgMyBieXRlcyBhbmQgbm90IDQuIFRoaXMg
aXMgZGVmaW5lZCBpbg0KQ0VORUxFQyBzcGVjaWZpY2F0aW9uIEVOIDUwMjIxIChTZWN0aW9uIDcu
Mi42LjYgQ2xvc2UgU2Vzc2lvbiBSZXNwb25zZSwNClRhYmxlIDExOiBDbG9zZSBTZXNzaW9uIFJl
c3BvbnNlIGNvZGluZykNCg0KU2lnbmVkLW9mLWJ5OiBKb2FxdWluIEFudG9uIEd1aXJhbyA8ai5n
dWlyYW9Ac2Ftc3VuZy5jb20+DQoNCg0KDQpkaWZmIC1yIDNkNDNiMjgwMjk4YyBsaWIvbGliZHZi
ZW41MDIyMS9lbjUwMjIxX3Nlc3Npb24uYw0KLS0tIGEvbGliL2xpYmR2YmVuNTAyMjEvZW41MDIy
MV9zZXNzaW9uLmOgoKCgoKAgRnJpIE1hciAyMSAyMDoyNjozNiAyMDE0DQorMDEwMA0KKysrIGIv
bGliL2xpYmR2YmVuNTAyMjEvZW41MDIyMV9zZXNzaW9uLmOgoKCgoKAgV2VkIE1heSAyOCAwOTo0
MDoxNSAyMDE0DQorMDIwMA0KQEAgLTcxNSwxMyArNzE1LDEzIEBADQqgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIHVpbnQ4X3QgY29ubmVjdGlvbl9p
ZCkNCqB7DQqgoKCgoKCgIC8vIGNoZWNrDQotoKCgoKCgIGlmIChkYXRhX2xlbmd0aCA8IDUpIHsN
CiugoKCgoKAgaWYgKGRhdGFfbGVuZ3RoIDwgNCkgew0KoKCgoKCgoKCgoKCgoKCgIHByaW50KExP
R19MRVZFTCwgRVJST1IsIDEsDQqgoKCgoKCgoKCgoKCgoKCgoKCgoKAgIlJlY2VpdmVkIGRhdGEg
d2l0aCBpbnZhbGlkIGxlbmd0aCBmcm9tIG1vZHVsZSBvbiBzbG90DQolMDJ4XG4iLA0KoKCgoKCg
oKCgoKCgoKCgoKCgoKCgIHNsb3RfaWQpOw0KoKCgoKCgoKCgoKCgoKCgIHJldHVybjsNCqCgoKCg
oKAgfQ0KLaCgoKCgoCBpZiAoZGF0YVswXSAhPSA0KSB7DQoroKCgoKCgIGlmIChkYXRhWzBdICE9
IDMpIHsNCqCgoKCgoKCgoKCgoKCgoCBwcmludChMT0dfTEVWRUwsIEVSUk9SLCAxLA0KoKCgoKCg
oKCgoKCgoKCgoKCgoKCgICJSZWNlaXZlZCBkYXRhIHdpdGggaW52YWxpZCBsZW5ndGggZnJvbSBt
b2R1bGUgb24gc2xvdA0KJTAyeFxuIiwNCqCgoKCgoKCgoKCgoKCgoKCgoKCgoCBzbG90X2lkKTsN
Cg==


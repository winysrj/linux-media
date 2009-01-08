Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0847aaR011990
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 23:07:36 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0847Kmj001695
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 23:07:20 -0500
Received: by rv-out-0506.google.com with SMTP id f6so9355513rvb.51
	for <video4linux-list@redhat.com>; Wed, 07 Jan 2009 20:07:20 -0800 (PST)
Message-ID: <2ac79fa40901072007m1f2edferacbc6e1da19bfeac@mail.gmail.com>
Date: Thu, 8 Jan 2009 11:07:20 +0700
From: "=?UTF-8?Q?Nam_Ph=E1=BA=A1m_Th=C3=A0nh?=" <phamthanhnam.ptn@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_202467_28986201.1231387640324"
Cc: 
Subject: [PATCH] pwc: add support for webcam snapshot button
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

------=_Part_202467_28986201.1231387640324
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Disposition: inline

SGkgYWxsLApJIHJlYWQgc29tZXdoZXJlIHRoYXQgb2ZmaWNpYWwgc3VwcG9ydCBmb3IgcHdjIGRy
aXZlciBoYXMgYmVlbiBzdG9wcGVkIDooClRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0IGZvciBQaGls
aXBzIHdlYmNhbSBzbmFwc2hvdCBidXR0b24gYXMgYW4gZXZlbnQgaW5wdXQKZGV2aWNlLCBmb3Ig
Y29uc2lzdGVuY3kgd2l0aCBvdGhlciB3ZWJjYW0gZHJpdmVycyAodXZjLCBxdWlja2NhbSBtZXNz
ZW5nZXIsCmtvbmljYXdjLi4uKQpUZXN0ZWQgd2l0aCBpbnB1dC11dGlscyAoaHR0cDovL2RsLmJ5
dGVzZXgub3JnL2N2cy1zbmFwc2hvdHMvKSBmb3IgTG9naXRlY2gKUXVpY2tDYW0gTm90ZWJvb2sg
UHJvICgwNDZkOjA4YjEpIGV0IExvZ2l0ZWNoIFF1aWNrQ2FtIFBybyA0MDAwICgwNDZkOjA4YjIp
LgpUaGlzIHBhdGNoIGRvZXNuJ3QgdG91Y2ggb3RoZXIgZmVhdHVyZXMsIHNvIGl0IGlzIHZlcnkg
bGlrZWx5IHRoYXQgaXQgd29uJ3QKYnJlYWsgYW55dGhpbmcuClJldHVybiB0byBteSBwcmV2aW91
cyBxdWVzdGlvbiAiSG93IHRvIHVzZSB3ZWJjYW0gc25hcHNob3QgYnV0dG9uPyIuIE5vb25lCmFu
c3dlcmVkLiBJIHRoaW5rIHRoYXQgc3VwcG9ydCBmb3IgaXQgaGFzIGFscmVhZHkgZXhpc3RlZCBp
biBkcml2ZXIsIGJ1dCBhdAp0aGUgcHJlc2VudCwgdGhlcmUgaXNuJ3QgYW55IGFwcGxpY2F0aW9u
IHdoaWNoIGV4cGxvaXRlZCB0aGlzIGZlYXR1cmUgeWV0LgotLSAKUGjhuqFtIFRow6BuaCBOYW0K
------=_Part_202467_28986201.1231387640324
Content-Type: application/zip; name=pwc-snapshot-button.patch.zip
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpowc6sv0
Content-Disposition: attachment; filename=pwc-snapshot-button.patch.zip

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
ZUlVeAAAUEsFBgAAAAABAAEAVAAAAEQHAAAAAA==
------=_Part_202467_28986201.1231387640324
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_202467_28986201.1231387640324--

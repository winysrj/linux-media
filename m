Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:31713 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab0LLSqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 13:46:23 -0500
Date: Sun, 12 Dec 2010 13:46:33 -0500
Subject: Re: [RFC/PATCH 03/19] cx18: Use the control framework.
Message-ID: <dpputt4i632ox8ldodidq3jk.1292179593754@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

SGkgSGFucywKCkl0IGxvb2tzIGxpa2UgaXQgc2hvdWxkLiAgSSdtIGxvb2tpbmcgYXQgdGhpbmdz
IG9uIG15IHBob25lICB3aGlsZSBvdXQgYW5kIGFib3V0IC0gbm90IHRoZSBiZXN0IGVudmlyb25t
ZW50IGZvciBjb2RlIHJldmlldy4KCllvdSBqdXN0IG5lZWQgdG8gZW5zdXJlIGRlZmF1bHQgdm9s
IGlzID49IDAgYW5kIDw9IDY1NTM1IHdoaWNoIG1heSBub3QgYmUgdGhlIGNhc2UgaWYgcmVnIDhk
NCBoYXMgYSB2YWx1ZSBuZWFyIDAuIAoKVHdvIG90aGVyIHRvcGljcyB3aGlsZSBJJ20gaGVyZToK
CjEuIFdoeSBzZXQgdGhlIHZvbCBzdGVwIHRvIDY1NSwgd2hlbiB0aGUgdm9sdW1lIHdpbGwgYWN0
YXVsbHkgc3RlcCBhdCBpbmNyZW1lbnRzIG9mIDUxMj8KCjIuIFdoeSBzaG91bGQgZmFpbHVyZSB0
byBpbml0aWFsaXplIGEgZGF0YSBzdHJ1Y3R1cmUgZm9yIHVzZXIgY29udHJvbHMgbWVhbiBmYWls
dXJlIHRvIGluaXQgb3RoZXJ3aXNlIHdvcmtpbmcgaGFyZHdhcmU/ICBXZSBuZXZlciBsZXQgdXNl
ciBjb250cm9sIGluaXQgY2F1c2Ugc3ViZGV2IGRyaXZlciBwcm9iZSBmYWlsdXJlIGJlZm9yZSwg
c28gd2h5IG5vdz8gIEknZCBwcmVmZXIgYSB3b3JraW5nIGRldmljZSB3aXRob3V0IHVzZXIgY29u
dHJvbHMgaW4gY2FzZSBvZiB1c2VyIGNvbnRyb2wgaW5pdCBmYWlsdXJlLgoKUmVnYXJkcywKQW5k
eQoKSGFucyBWZXJrdWlsIDxodmVya3VpbEB4czRhbGwubmw+IHdyb3RlOgoKPk9uIFN1bmRheSwg
RGVjZW1iZXIgMTIsIDIwMTAgMTk6MDk6MzYgQW5keSBXYWxscyB3cm90ZToKPj4gSGFucywKPj4g
Cj4+IFRoaXMgaGFzIGF0IGxlYXN0IHRoZSBzYW1lIHR3byBwcm9ibGVtcyB0aGUgY2hhbmdlIGZv
ciBjeDI1ODQwIGhhZDoKPj4gCj4+IDEuIFZvbHVtZSBjb250cm9sIGluaXQgc2hvdWxkIHVzZSA2
NTUzNSBub3QgNjUzMzUKPj4gCj4+IDIuIFlvdSBjYW5ub3QgdHJ1c3QgcmVnIDB4OGQ0IHRvIGhh
dmUgYSB2YWx1ZSBpbiBpdCBmb3IgdGhlIGRlZmF1bHQgdm9sdW1lIHRoYXQgd29uJ3QgZ2l2ZSBh
biBFUkFOR0UgZXJyb3Igd2hlbiB5b3UgZ28gdG8gaW5pdCB0aGUgdm9sdW1lIGNvbnRyb2wuICBT
dWJkZXYgcHJvYmUgd2lsbCBmYWlsLiBTZWUgbXkgcHJldmlvdXMgY3gyNTg0MCBwYXRjaGVzIHNl
bnQgdG8gdGhlIGxpc3QsIGF3YWl0aW5nIGFjdGlvbi4KPj4gCj4+IChUaGUgY3gyNTg0MCBjb2Rl
IHRoYXQgdHJ1c3RzIHRoZSB2b2x1bWUgcmVnaXN0ZXIgdG8gYmUgaW4gcmFuZ2UgaXMgYWxyZWFk
eSBpbiAyLjYuMzYgYW5kIGJyZWFrcyBJUiBhbmQgYW5hbG9nIGZvciBDWDIzODg1LzcvOCBjaGlw
cy4pCj4+IAo+PiBJJ2xsIGdpdmUgdGhpcyB3aG9sZSBwYXRjaCBhIGhhcmRlciBsb29rIGxhdGVy
IHRoaXMgZXZlbmluZyBpZiBJIGNhbi4KPj4gCj4+IFJlZ2FyZHMsCj4+IEFuZHkKPj4gCj4KPldv
dWxkIHRoZSBwYXRjaCBiZWxvdyBmaXggdGhlc2UgaXNzdWVzPyBJdCBjb21waWxlcywgYnV0IEkg
ZGlkbid0IHRlc3QgaXQuCj4KPlJlZ2FyZHMsCj4KPglIYW5zCj4KPmRpZmYgLS1naXQgYS9kcml2
ZXJzL21lZGlhL3ZpZGVvL2N4MTgvY3gxOC1hdi1jb3JlLmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVv
L2N4MTgvY3gxOC1hdi1jb3JlLmMKPmluZGV4IGUxZjU4ZjEuLjczYjZmNGQgMTAwNjQ0Cj4tLS0g
YS9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MTgvY3gxOC1hdi1jb3JlLmMKPisrKyBiL2RyaXZlcnMv
bWVkaWEvdmlkZW8vY3gxOC9jeDE4LWF2LWNvcmUuYwo+QEAgLTI0OCw4ICsyNDgsMjIgQEAgc3Rh
dGljIHZvaWQgY3gxOF9hdl9pbml0aWFsaXplKHN0cnVjdCB2NGwyX3N1YmRldiAqc2QpCj4gLyog
ICAgICAJQ3hEZXZXclJlZyhDWEFERUNfU1JDX0NPTUJfQ0ZHLCAweDY2MjgwMjFGKTsgKi8KPiAv
KiAgICB9ICovCj4gCWN4MThfYXZfd3JpdGU0KGN4LCBDWEFERUNfU1JDX0NPTUJfQ0ZHLCAweDY2
MjgwMjFGKTsKPi0JZGVmYXVsdF92b2x1bWUgPSAyMjggLSBjeDE4X2F2X3JlYWQoY3gsIDB4OGQ0
KTsKPi0JZGVmYXVsdF92b2x1bWUgPSAoKGRlZmF1bHRfdm9sdW1lIC8gMikgKyAyMykgPDwgOTsK
PisJZGVmYXVsdF92b2x1bWUgPSBjeDE4X2F2X3JlYWQoY3gsIDB4OGQ0KTsKPisJLyoKPisJICog
RW5mb3JjZSB0aGUgbGVnYWN5IHZvbHVtZSBzY2FsZSBtYXBwaW5nIGxpbWl0cyB0byBhdm9pZCAt
RVJBTkdFCj4rCSAqIGVycm9ycyB3aGVuIGluaXRpYWxpemluZyB0aGUgdm9sdW1lIGNvbnRyb2wK
PisJICovCj4rCWlmIChkZWZhdWx0X3ZvbHVtZSA+IDIyOCkgewo+KwkJLyogQm90dG9tIG91dCBh
dCAtOTYgZEIsIHY0bDIgdm9sIHJhbmdlIDB4MmUwMC0weDJmZmYgKi8KPisJCWRlZmF1bHRfdm9s
dW1lID0gMjI4Owo+KwkJY3gxOF9hdl93cml0ZShjeCwgMHg4ZDQsIDIyOCk7Cj4rCX0KPisJZWxz
ZSBpZiAoZGVmYXVsdF92b2x1bWUgPCAyMCkgewo+KwkJLyogVG9wIG91dCBhdCArIDggZEIsIHY0
bDIgdm9sIHJhbmdlIDB4ZmUwMC0weGZmZmYgKi8KPisJCWRlZmF1bHRfdm9sdW1lID0gMjA7Cj4r
CQljeDE4X2F2X3dyaXRlKGN4LCAweDhkNCwgMjApOwo+Kwl9Cj4rCWRlZmF1bHRfdm9sdW1lID0g
KCgoMjI4IC0gZGVmYXVsdF92b2x1bWUpID4+IDEpICsgMjMpIDw8IDk7Cj4gCXN0YXRlLT52b2x1
bWUtPmN1ci52YWwgPSBzdGF0ZS0+dm9sdW1lLT5kZWZhdWx0X3ZhbHVlID0gZGVmYXVsdF92b2x1
bWU7Cj4gCXY0bDJfY3RybF9oYW5kbGVyX3NldHVwKCZzdGF0ZS0+aGRsKTsKPiB9Cj5AQCAtMTM1
OSw3ICsxMzczLDcgQEAgaW50IGN4MThfYXZfcHJvYmUoc3RydWN0IGN4MTggKmN4KQo+IAo+IAlz
dGF0ZS0+dm9sdW1lID0gdjRsMl9jdHJsX25ld19zdGQoJnN0YXRlLT5oZGwsCj4gCQkJJmN4MThf
YXZfYXVkaW9fY3RybF9vcHMsIFY0TDJfQ0lEX0FVRElPX1ZPTFVNRSwKPi0JCQkwLCA2NTMzNSwg
NjU1MzUgLyAxMDAsIDApOwo+KwkJCTAsIDY1NTM1LCA2NTUzNSAvIDEwMCwgMCk7Cj4gCXY0bDJf
Y3RybF9uZXdfc3RkKCZzdGF0ZS0+aGRsLAo+IAkJCSZjeDE4X2F2X2F1ZGlvX2N0cmxfb3BzLCBW
NEwyX0NJRF9BVURJT19NVVRFLAo+IAkJCTAsIDEsIDEsIDApOwo+Cj4tLSAKPkhhbnMgVmVya3Vp
bCAtIHZpZGVvNGxpbnV4IGRldmVsb3BlciAtIHNwb25zb3JlZCBieSBDaXNjbwo+LS0KPlRvIHVu
c3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICJ1bnN1YnNjcmliZSBsaW51
eC1tZWRpYSIgaW4KPnRoZSBib2R5IG9mIGEgbWVzc2FnZSB0byBtYWpvcmRvbW9Admdlci5rZXJu
ZWwub3JnCj5Nb3JlIG1ham9yZG9tbyBpbmZvIGF0ICBodHRwOi8vdmdlci5rZXJuZWwub3JnL21h
am9yZG9tby1pbmZvLmh0bWwK


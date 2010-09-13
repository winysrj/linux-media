Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43842 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab0IMRlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 13:41:01 -0400
Date: Mon, 13 Sep 2010 13:40:56 -0400
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc
 driver
Message-ID: <j8j55cs3ngu17v1ql2qrw72r.1284399656070@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: Andy Walls <awalls@md.metrocast.net>,
	Thomas Kaiser <linux-dvb@kaiser-linux.li>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

RnVydGhlciBpbnZlc3RpZ2F0aW9uIHJldmVhbHMgdGhhdCB0aGUgVHJhdmVsZXIgaXMgbGlrZWx5
IGEgVVZDIGJhc2VkIHdlYmNhbSBtaWNyb3Njb3BlLiAgQXZlb3RlayBwcm92aWRlcyBjb250cm9s
bGVyIGNoaXBzIHRvIGNhbWVyYSBtYW51ZmFjdHVyZXJzIGFuZCBoYXMgYSBnZW5lcmljIFVWQyBk
cml2ZXIgZG93bmxvYWQgYXZhaWxhYmxlIGZvciBXaW5kb3dzLgoKSSBub3RpY2UgVHJhdmVsZXIg
VVNBIGRvZXMgbm90IHNlbGwgdGhlaXIgbWljcm9zY29wZSBpbiB0aGUgVVMuICBJIGJlbGlldmUg
TWF0dGVsbCwgSW5jLiBvd25zIHNvbWUgYXNwZWN0cyBvZiB0aGUgbWVjaGFuaWNhbCBkZXNpZ24g
KHNpbmNlIHRoZSBzdGlja2VyIG9uIHRoZSBib3R0b20gb2YgbXkgUVgzIGluZGljYXRlcyBpdCB3
YXMgbWFkZSBieSBNYXR0ZWxsKS4KClJlZ2FyZHMsCkFuZHkKCkFuZHkgV2FsbHMgPGF3YWxsc0Bt
ZC5tZXRyb2Nhc3QubmV0PiB3cm90ZToKCj5UaGUgY3BpYTIgZHJpdmVyIGRvZXNuJ3Qga25vdyBh
Ym91dCB0aG9zZSB1c2IgaWRzLgo+Cj5UaGUgVHJhdmVsZXIgbWljcm9zY29wZXMgbG9vayBtZWNo
YW5pY2FsbHkgc2ltaWxhciB0byB0aGUgUVgzIGFuZCBRWDUsIGJ1dCB0aGUgcGl4ZWwgcmVzb2x1
dGlvbiBpcyBoaWdoZXIgdGhhbiB0aGUgUVgzLgo+VGhlIFFYNSBoYXMgdGhlIHNhbWUgcHhpZWwg
cmVzb2x1dGlvbiBhcyB0aGUgVHJhdmVsZXIgTW9kIDEsIGJ1dCB0aGUgTW9kIDIgc3VwcG9ydCBh
IGhpZ2hlciByZXNvbHV0aW9uLgo+Cj5HaXZlbiBhbGwgdGhhdCwgSSdtIG5vdCBzdXJlIHdlIGNv
dWxkIHVzZSB5b3VyIHVuaXQgZm9yIHJlZ3Jlc3Npb24gdGVzdGluZyBvZiBjaGFuZ2VzIHRvIHRo
ZSBjcGlhMiBkcml2ZXIuICBJdCBtYXkgYmUgcG9zc2libGUgdG8gc3VwcG9ydCB0aGUgVHJhdnZl
bGVyIHVuZGVyIGxpbnV4IGV2ZW50dWFsbHksIGJ1dCBhdCBhIG1pbmltdW0geW91J2xsIG5lZWQg
dG8gcHJvdmlkZSBpbmZvcm1hdGlvbiBvbiB0aGUgY2hpcHMgdXNlZCBpbiB0aGUgdW5pdC4KPgo+
VGhhbmtzIGZvciB0aGUgb2ZmZXIgb2YgaGVscC4KPgo+UmVnYXJkcywKPkFuZHkKPgo+Cj5UaG9t
YXMgS2Fpc2VyIDxsaW51eC1kdmJAa2Fpc2VyLWxpbnV4LmxpPiB3cm90ZToKPgo+Pk9uIDA5LzEz
LzIwMTAgMDM6MzAgUE0sIEFuZHkgV2FsbHMgd3JvdGU6Cj4+PiBPbiBNb24sIDIwMTAtMDktMTMg
YXQgMDg6MjcgLTAzMDAsIE1hdXJvIENhcnZhbGhvIENoZWhhYiB3cm90ZToKPj4+PiBFbSAxMi0w
OS0yMDEwIDE4OjI4LCBBbmR5IFdhbGxzIGVzY3JldmV1Ogo+Pj4+PiBPbiBTdW4sIDIwMTAtMDkt
MTIgYXQgMTc6MTIgLTA0MDAsIEFuZHkgV2FsbHMgd3JvdGU6Cj4+Pj4+PiBPbiBTdW4sIDIwMTAt
MDktMTIgYXQgMjI6MjYgKzAyMDAsIEhhbnMgVmVya3VpbCB3cm90ZToKPj4+Pj4+Cj4+Pj4+Pj4g
QW5kIG90aGVyIG5ld3Mgb24gdGhlIFY0TDEgZnJvbnQ6Cj4+Pj4+Pgo+Pj4+Pj4+IEknbSB3YWl0
aW5nIGZvciB0ZXN0IHJlc3VsdHMgb24gdGhlIGNwaWEyIGRyaXZlci4gSWYgaXQgd29ya3MsIHRo
ZW4gdGhlIFY0TDEKPj4+Pj4+PiBzdXBwb3J0IGNhbiBiZSByZW1vdmVkIGZyb20gdGhhdCBkcml2
ZXIgYXMgd2VsbC4KPj4+Pj4+Cj4+Pj4+PiBGWUksIHRoYXQgd2lsbCBicmVhayB0aGlzIDIwMDUg
dmludGFnZSBwaWVjZSBvZiBWNEwxIHNvZnR3YXJlIHBlb3BsZSBtYXkKPj4+Pj4+IHN0aWxsIGJl
IHVzaW5nIGZvciB0aGUgUVg1IG1pY3Jvc2NvcGU6Cj4+Pj4+Cj4+Pj4+IFNvcnJ5LCB0aGF0IGlz
IG9mIGNvdXJzZSwgaWYgdGhlcmUgaXMgbm8gVjRMMSBjb21wYXQgbGF5ZXIgc3RpbGwgaW4KPj4+
Pj4gcGxhY2UuCj4+Pj4+Cj4+Pj4+IEJUVywgcXg1dmlldyB1c2VzIGEgcHJpdmF0ZSBpb2N0bCgp
IHRvIGNoYW5nZSB0aGUgbGlnaHRzIG9uIGEgUVg1IGFuZAo+Pj4+PiBub3QgdGhlIFY0TDIgY29u
dHJvbC4KPj4+Pgo+Pj4+IFRoZSBiZXR0ZXIgd291bGQgYmUgdG8gcG9ydCBxeDV2aWV3IHRvIHVz
ZSBsaWJ2NGwgYW5kIGltcGxlbWVudCB0aGUgbmV3Cj4+Pj4gaWxsdW1pbmF0b3IgY3RybCBvbiB0
aGUgZHJpdmVyIGFuZCBvbiB0aGUgdXNlcnNwYXNlIGFwcC4gRG8geW91IGhhdmUKPj4+PiBoYXJk
d2FyZSBmb3IgdGVzdGluZyB0aGlzPwo+Pj4KPj4+IE5vLiAgSSBkaWQgY2hlY2sgQW1hem9uLmNv
bSBhbmQgZUJheSBhbmQgc2F3IGEgUVg1IGZvciBhYm91dCBVUyQ3NSBhZnRlcgo+Pj4gc2hpcHBp
bmcgY29zdHM6Cj4+Pgo+Pj4gaHR0cDovL2NnaS5lYmF5LmNvbS93cy9lQmF5SVNBUEkuZGxsP1Zp
ZXdJdGVtJml0ZW09MzgwMjYyNDA2OTg5JnJ2cl9pZD0xMzkxNDczNTk5NTQmY3JscD0xXzI2MzYw
Ml8yNjM2MjImVUE9TCpGJTNGJkdVSUQ9MGIzYjUzNzQxMmIwYTBlMjAzZTYzMDA2ZmY5YmVjYjAm
aXRlbWlkPTM4MDI2MjQwNjk4OSZmZjQ9MjYzNjAyXzI2MzYyMgo+Pj4KPj4+IEknbSBub3Qgc3Vy
ZSBpZiBJIHdhbnQgdG8gYnV5IG9uZSBhdCB0aGF0IHByaWNlLCBzaW5jZSBJIGFscmVhZHkgaGF2
ZSBhCj4+PiBRWDMuCj4+Pgo+Pj4gUmVnYXJkcywKPj4+IEFuZHkKPj4+Cj4+PiAtLQo+Pj4gVG8g
dW5zdWJzY3JpYmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vic2NyaWJlIGxp
bnV4LW1lZGlhIiBpbgo+Pj4gdGhlIGJvZHkgb2YgYSBtZXNzYWdlIHRvIG1ham9yZG9tb0B2Z2Vy
Lmtlcm5lbC5vcmcKPj4+IE1vcmUgbWFqb3Jkb21vIGluZm8gYXQgIGh0dHA6Ly92Z2VyLmtlcm5l
bC5vcmcvbWFqb3Jkb21vLWluZm8uaHRtbAo+Pgo+PkhlbGxvIEFuZHksIE1hdXJvCj4+Cj4+SSBv
d24gYSBVU0IgTWljcm9zY29wZSB3aGljaCBsb29rcyBxdWl0ZSB0aGUgc2FtZSBhcyB0aGUgb25l
IGluIHlvdXIgCj4+bGluaywgYnV0IEkgZG9uJ3Qga25vdyBpZiBpdCBpcyBzaW1pbGFyIHRvIHRo
ZSBRWDMgb3IgUVg1Lgo+Pkl0IGlzIGNhbGxlZCAiVHJhdmVsZXIgVVNCLU1pa3Jvc2tvcCIgYW5k
IG1vZGVsIG51bWJlciBpcyAiU1UgMTA3MSIuCj4+T25lIG9mIHRoaXMgdHdvOgo+Pmh0dHA6Ly93
d3cudHJhdmVsZXItc2VydmljZS5kZS9jbXMvaW5kZXgucGhwP2lkPXRyYXZlbGVyLW9wdGlzY2hl
LWdlcmFldGUtZGUKPj4KPj5VU0IgSUQ6IDE4NzE6MDFiMCBBdmVvIFRlY2hub2xvZ3kgQ29ycC4K
Pj4KPj5JdCBpcyBub3Qgd29ya2luZyBpbiBVYnVudHUgMTAuMDQsIGtlcm5lbCBBTUQ2NCAyLjYu
MzItMjQtZ2VuZXJpYy4KPj4KPj5JZiBpdCBpcyBhIFFYNSwgSSBjYW4gaGVscCB0ZXN0aW5nLgo+
Pgo+PlJlZ2FyZHMsCj4+VGhvbWFzCj4+Cj4+Cg==


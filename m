Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:34584 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759623Ab2EKQCC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 12:02:02 -0400
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Chao Xie <cxie4@marvell.com>, Angela Wan <jwan@marvell.com>,
	Kassey Lee <kassey1216@gmail.com>,
	Albert <bluebellice@gmail.com>
Date: Fri, 11 May 2012 09:02:26 -0700
Subject: marvell-ccic: lacks of some features
Message-ID: <477F20668A386D41ADCC57781B1F7043083A57BA08@SC-VEXCH1.marvell.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGksIEpvbmF0aGFuICYgR3Vlbm5hZGkNCg0KV2UgdXNlZCB0aGUgbWFydmVsbC1jY2ljIGNvZGUg
YW5kIGZvdW5kIGl0IGxhY2tzIG9mIHNvbWUgZmVhdHVyZXMsIGJ1dCBvdXIgTWFydmVsbCBDYW1l
cmEgZHJpdmVyIChtdl9jYW1lcmEuYykgd2hpY2ggYmFzZWQgb24gc29jX2NhbWVyYSBjYW4gc3Vw
cG9ydCBhbGwgdGhlc2UgZmVhdHVyZXM6DQoNCjEuIG1hcnZlbGwtY2NpYyBvbmx5IHN1cHBvcnQg
TU1QMiAoUFhBNjg4KSwgaXQgY2Fu4oCZdCBzdXBwb3J0IG90aGVyIE1hcnZlbGwgU09DIGNoaXBz
DQpPdXIgbXZfY2FtZXJhIGNhbiBzdXBwb3J0IHN1Y2ggYXMgTU1QMyAoUFhBMjEyOCksIFREIChQ
WEE5MTAvOTIwKSBhbmQgc28gb24gYmVzaWRlcyBNTVAyDQoNCjIuIG1hcnZlbGwtY2NpYyBvbmx5
IHN1cHBvcnQgcGFyYWxsZWwgKERWUCkgbW9kZSwgY2Fu4oCZdCBzdXBwb3J0IE1JUEkgbW9kZQ0K
T3VyIG12X2NhbWVyYSBjYW4gc3VwcG9ydCBib3RoIERWUCBtb2RlIGFuZCBNSVBJIG1vZGUsIE1J
UEkgaW50ZXJmYWNlIGlzIHRoZSB0cmVuZCBvZiBjdXJyZW50IGNhbWVyYSBzZW5zb3JzIHdpdGgg
aGlnaCByZXNvbHV0aW9uDQoNCjMuIG1hcnZlbGwtY2NpYyBvbmx5IHN1cHBvcnQgY2NpYzEgY29u
dHJvbGxlciwgY2Fu4oCZdCBzdXBwb3J0IGNjaWMyIG9yIGR1YWwgY2NpYyBjb250cm9sbGVycw0K
QXMgeW91IGtub3duLCBib3RoIE1NUDIgYW5kIE1NUDMgaGF2ZSAyIGNjaWMgY29udHJvbGxlcnMs
IGNjaWMyIGlzIGRpZmZlcmVudCB3aXRoIGNjaWMxDQpTb21ldGltZXMgd2UgbmVlZCB1c2UgYm90
aCAyIGNjaWMgY29udHJvbGxlcnMgZm9yIGNvbm5lY3RpbmcgMiBjYW1lcmEgc2Vuc29ycw0KQWN0
dWFsbHksIHdlIGhhdmUgdXNlZCAyIGNjaWMgY29udHJvbGxlcnMnIGNhc2VzIGluIG91ciBwbGF0
Zm9ybXMNCk91ciBtdl9jYW1lcmEgY2FuIHN1cHBvcnQgdGhlc2UgY2FzZXM6IG9ubHkgdXNlIGNj
aWMxLCBvbmx5IHVzZSBjY2ljMiBhbmQgdXNlIGNjaWMxICsgY2NpYzINCg0KNC4gbWFydmVsbC1j
Y2ljIG9ubHkgc3VwcG9ydCBjYW1lcmEgc2Vuc29yIE9WNzY3MA0KSXQncyBhbiBvbGQgYW5kIGxv
dyByZXNvbHV0aW9uIHBhcmFsbGVsIHNlbnNvciwgYW5kIHNlbnNvciBpbmZvIGFsc28gaXMgaGFy
ZCBjb2RlDQpCdXQgaXQgbG9vb2tzIHdlIHNob3VsZCBiZXR0ZXIgc2VwYXJhdGUgY29udHJvbGxl
ciBhbmQgc2Vuc29yIGluIGRyaXZlciwgY29udHJvbGxlciBkb2Vzbid0IGNhcmUgc2Vuc29yIHR5
cGUgd2hpY2ggd2lsbCBjb21tdW5pY2F0ZSB3aXRoDQpPdXIgbXZfY2FtZXJhIGNhbiBzdXBwb3J0
IGFueSBjYW1lcmEgc2Vuc29yIHdoaWNoIGJhc2VkIG9uIHN1YmRldiBzdHJ1Y3R1cmUNCg0KNS4g
bWFydmVsbC1jY2ljIG9ubHkgc3VwcG9ydCBZVVlWIGZvcm1hdCB3aGljaCBpcyBwYWNrZWQgZm9y
bWF0IGJlc2lkZXMgUkdCNDQ0IGFuZCBSR0I1NjUsIGl0IGNhbuKAmXQgc3VwcG9ydCBwbGFuYXIg
Zm9ybWF0cw0KT3VyIG12X2NhbWVyYSBjYW4gc3VwcG9ydCBib3RoIHBhY2tlZCBmb3JtYXQgYW5k
IHBsYW5hciBmb3JtYXRzIHN1Y2ggYXMgWVVWNDIwIGFuZCBZVVY0MjJQDQoNCjYuIG1hcnZlbGwt
Y2NpYyBkaWRuJ3Qgc3VwcG9ydCBKUEVHIGZvcm1hdCBmb3Igc3RpbGwgY2FwdHVyZSBtb2RlDQpP
dXIgbXZfY2FtZXJhIGNhbiBzdXBwb3J0IEpQRUcgZGlyZWN0bHkgZm9yIHN0aWxsIGNhcHR1cmUs
IG1vc3QgaGlnaCByZXNvbHV0aW9uIGNhbWVyYSBzZW5zb3IgY2FuIG91dHB1dCBKUEVHIGZvcm1h
dCBkaXJlY3RseQ0KDQo3LiBtYXJ2ZWxsLWNjaWMgY2Fu4oCZdCBzdXBwb3J0IGR1YWwgY2FtZXJh
IHNlbnNvcnMgb3IgbXVsdGkgY2FtZXJhIHNlbnNvcnMgY2FzZXMNCkN1cnJlbnQgbW9zdCBwbGF0
Zm9ybXMgY2FuIHN1cHBvcnQgZHVhbCBjYW1lcmEgc2Vuc29yIGNhc2UsIGluY2x1ZGUgZnJvbnQt
ZmFjaW5nIHNlbnNvciBhbmQgcmVhci1mYWNpbmcgc2Vuc29yDQpFdmVuIHNvbWUgaGlnaCBlbmQg
cGxhdGZvcm1zIGNhbiBzdXBwb3J0IDNEIG1vZGUgcmVjb3JkOyBpdCBuZWVkIHN1cHBvcnQgMisx
IGNhbWVyYSBzZW5zb3JzDQpPdXIgbXZfY2FtZXJhIGNhbiBzdXBwb3J0IHRoZXNlIGNhc2VzOg0K
ZHVhbCBjYW1lcmEgc2Vuc29yIGNvbm5lY3QgdG8gY2NpYzEgb3IgY2NpYzINCm9uZSBjYW1lcmEg
c2Vuc29yIGNvbm5lY3QgdG8gY2NpYzEgYW5kIHRoZSBvdGhlciBjYW1lcmEgc2Vuc29yIGNvbm5l
Y3QgdG8gY2NpYzINCmR1YWwgY2FtZXJhIHNlbnNvciBjb25uZWN0IHRvIGNjaWMxIGFuZCBvbmUg
Y2FtZXJhIHNlbnNvciBjb25uZWN0IHRvIGNjaWMyDQoNCjguIG1hcnZlbGwtY2NpYyBjYW7igJl0
IHN1cHBvcnQgZXh0ZXJuYWwgSVNQICsgcmF3IGNhbWVyYSBzZW5zb3IgbW9kZQ0KQXMgeW91IGtu
b3duLCBtb3JlIGFuZCBtb3JlIGNhbWVyYSBzZW5zb3JzIHdpdGggaGlnaCByZXNvbHV0aW9uIGFy
ZSByYXcgY2FtZXJhIHNlbnNvcnMgYnV0IG5vdCBzbWFydCBzZW5zb3JzDQpJdCBuZWVkcyBleHRl
cm5hbCBJU1AgKEltYWdlIFNpZ25hbCBQcm9jZXNzb3IpIHRvIGdlbmVyYXRlIHRoZSBkZXNpcmVk
IGZvcm1hdHMgYW5kIHJlc29sdXRpb25zIHdpdGggc29tZSBhZHZhbmNlZCBmZWF0dXJlcyBiYXNl
ZCBvbiB0aGUgcmF3IGRhdGEgZnJvbSBzZW5zb3INCk91ciBtdl9jYW1lcmEgY2FuIHN1cHBvcnQg
Ym90aCBzbWFydCBjYW1lcmEgc2Vuc29ycyBhbmQgZXh0ZXJuYWwgSVNQICsgcmF3IGNhbWVyYSBz
ZW5zb3JzDQoNCjkuIG1hcnZlbGwtY2NpYyBzdGlsbCB1c2VkIG9ic29sZXRlIG1ldGhvZCB0byBz
dG9wIGNjaWMgRE1BDQpUaGlzIG1ldGhvZCBzaG91bGQgYmUgaW5oZXJpdHRlZCBmcm9tIG9sZCBj
YWZlLWNjaWMgZHJpdmVyLCBpdCB1c2UgQ0YgZmxhZyB3aGljaCBpcyB0cmlnZ2VkIGJ5IFNPRg0K
VGhpcyBtZXRob2QgaXMgaW5lZmZpY2llbnQsIHdlIG11c3Qgd2FpdCBhdCBsZWFzdCAxNTBtcyBm
b3Igc3RvcCBjY2ljIERNQSBhbmQgaXQgYWxzbyBjYW4gcmVzdWx0IGluIG1hbnkgaXNzdWVzIGR1
cmluZyB0aG91c2FuZHMgcmVzb2x1dGlvbnMgb3IgZm9ybWF0cyBzd2l0Y2ggc3RyZXNzIHRlc3QN
CkFjdHVhbGx5IG91ciBjY2ljIGNhbiBoYW5kbGUgaXQgaWYgd2UgdXNlIHRoZSByaWdodCBzdG9w
IHNlcXVlbmNlIGJ5IGNvbmZpZyBzb21lIGNjaWMgcmVnaXN0ZXJzDQpPdXIgbXZfY2FtZXJhIGhh
ZCBhcHBsaWVkIHRoZSBuZXcgYW5kIHJpZ2h0IHN0b3AgbWV0aG9kIGFuZCBpdCBhbHNvIHBhc3Nl
ZCB0aGUgdGhvdXNhbmRzIHJlc29sdXRpb25zIG9yIGZvcm1hdHMgc3dpdGNoIHN0cmVzcyB0ZXN0
DQoNCg0KVGhhbmtzDQpBbGJlcnQgV2FuZw0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZy
b206IEd1ZW5uYWRpIExpYWtob3ZldHNraSBbbWFpbHRvOmcubGlha2hvdmV0c2tpQGdteC5kZV0g
DQpTZW50OiBNb25kYXksIDA5IEFwcmlsLCAyMDEyIDIwOjExDQpUbzogQWxiZXJ0DQpDYzogSm9u
YXRoYW4gQ29yYmV0OyBMaW51eCBNZWRpYSBNYWlsaW5nIExpc3Q7IE1hdXJvIENhcnZhbGhvIENo
ZWhhYjsgQWxiZXJ0IFdhbmc7IENoYW8gWGllOyBLYXNzZXkgTGVlDQpTdWJqZWN0OiBSZTogW1BB
VENIIDIvN10gbWFydmVsbC1jYW06IFJlbW92ZSBicm9rZW4gIm93bmVyIiBsb2dpYw0KDQpIaSBB
bGJlcnQNCg0KT24gTW9uLCA5IEFwciAyMDEyLCBBbGJlcnQgd3JvdGU6DQoNCj4gSGksIEpvbmF0
aGFuICYgR3Vlbm5hZGkNCj4gDQo+IEknbSBBbGJlcnQgV2FuZyBmcm9tIE1hcnZlbGwsIG5pY2Ug
dG8gbWVldCB5b3UhDQoNCk5pY2UgdG8gbWVldCB5b3UgdG9vLg0KDQo+IFdlIGZvdW5kIHRoZXJl
IGlzIGEgc29jIGNhbWVyYSBmcmFtZXdvcmsgaW4gb3BlbiBzb3VyY2UsIGFuZCB3ZSBtYWRlIGEg
DQo+IE1hcnZlbGwgY2FtZXJhIGRyaXZlciB3aGljaCBiYXNlZCBvbiBTb2MgY2FtZXJhIGZyYW1l
d29yayArIHZpZGVvYnVmMi4NCj4gQW5kIG5vdyBpdCBjYW4gc2VydmUgc2V2ZXJhbCBNYXJ2ZWxs
IFNPQyBjaGlwcywgc3VjaCBhcyBNTVAyIChQWEE2ODgpLCANCj4gTU1QMw0KPiAoUFhBMjEyOCkg
YW5kIFREIChQWEE5MTApIHdoaWNoIGhhcyBzYW1lIENDSUMgSVAuDQo+IA0KPiBCdXQgaXQgbG9v
a3MgSm9uYXRoYW4gaGFkIHdyaXRlIGEgTWFydmVsbCBjY2ljIGNhbWVyYSBkcml2ZXIgYmFzZWQg
b24gDQo+IGNhZsOpLWNjaWMgKyB2aWRlb2J1ZjIgZm9yIE1NUDIgb24gT0xQQyBpbiBvcGVuIHNv
dXJjZS4NCj4gDQo+IFNvIGRvIHlvdSB0aGluayBpdMKScyBzdGlsbCBPSyB0byBwdXNoIG91ciBN
YXJ2ZWxsIGNhbWVyYSBkcml2ZXIgdG8gDQo+IG9wZW4gc291cmNlPw0KDQpBIGNvbGxlYWd1ZSBv
ZiB5b3VycyAtIEthc3NleSBMZWUgLSBoYXMgYmVlbiB3b3JraW5nIG9uIHRoaXMgZHJpdmVyOg0K
DQpodHRwOi8vdGhyZWFkLmdtYW5lLm9yZy9nbWFuZS5saW51eC5kcml2ZXJzLnZpZGVvLWlucHV0
LWluZnJhc3RydWN0dXJlLzMzNzc1DQoNCmFuZCBpdCBoYXMgYmVlbiBhZ3JlZWQsIHRoYXQgdGhl
IGNhbWVyYSBkcml2ZXIgZm9yIFBYQTkxMCBhbmQgb3RoZXIgU29DcywgbWVudGlvbmVkIGFib3Zl
IHNob3VsZCByZS11c2UgdGhlIHNhbWUgY29kZS1iYXNlLCBhcyB0aGUgY2FmZV9jY2ljIGRyaXZl
ciBmcm9tIEpvbi4gT25lIG9mIG9ic3RhY2xlcyBoYXMgYmVlbiwgdGhhdCB0aGUgY2FmZSBkcml2
ZXIgZGlkbid0IHVzZSBhIHN0YW5kYXJkIHZpZGVvYnVmIHNjaGVtZSwgaW1wbGVtZW50aW5nIG9u
ZSBvZiBpdHMgb3duLiBOb3cgdGhpcyBoYXMgYmVlbiBmaXhlZCB0b28sIHRoZSBkcml2ZXIgaGFz
IGFsc28gYmVlbiBicm9rZW4gZG93biBpbiBwYXJ0cyB0byBzaW1wbGlmeSBzdWNoIGNvZGUgcmUt
dXNlLiBBbGwgdGhpcyBzcGVha3MgaW4gZmF2b3VyIG9mIGltcGxlbWVudGluZyB5b3VyIGRyaXZl
ciBieSB1c2luZyBjb21tb24gcGFydHMgb2YgdGhlIG1hcnZlbGwtY2NpYyBkcml2ZXIuIFRoaXMg
aXMgYWxzbyB3aGF0IEthc3NleSBoYXMgYWdyZWVkIHRvLiBXaGV0aGVyIG9yIG5vdCB5b3VyIG5l
dyBkcml2ZXIgd2lsbCBiZSBhbHNvIHVzaW5nIHRoZSBzb2MtY2FtZXJhIGZyYW1ld29yayBpcyB5
b3VyIGRlY2lzaW9uLCBJIHRoaW5rLCBib3RoIHdheXMgYXJlIHBvc3NpYmxlLiANClBsZWFzZSwg
dHJ5IHRvIHJlLXVzZSB0aGUgbWFydmVsbC1jY2ljIGNvZGUgYW5kIHJlcG9ydCBhbnkgcHJvYmxl
bXMuDQoNClRoYW5rcw0KR3Vlbm5hZGkNCg0KPiBMb29raW5nIGZvciB5b3VyIGNvbW1lbnRzIQ0K
PiBUaGFua3MgYSBsb3QgaW4gYWR2YW5jZSENCj4gDQo+IFRoYW5rcw0KPiBBbGJlcnQgV2FuZw0K
PiBPbiBTYXQsIE1hciAxNywgMjAxMiBhdCA3OjE0IEFNLCBKb25hdGhhbiBDb3JiZXQgPGNvcmJl
dEBsd24ubmV0PiB3cm90ZToNCj4gDQo+ID4gVGhlIG1hcnZlbGwgY2FtIGRyaXZlciByZXRhaW5l
ZCBqdXN0IGVub3VnaCBvZiB0aGUgb3duZXItdHJhY2tpbmcgDQo+ID4gbG9naWMgZnJvbSBjYWZl
X2NjaWMgdG8gYmUgYnJva2VuOyBpdCBjb3VsZCwgY29uY2VpdmFibHksIGNhdXNlIHRoZSANCj4g
PiBkcml2ZXIgdG8gcmVsZWFzZSBETUEgbWVtb3J5IHdoaWxlIHRoZSBjb250cm9sbGVyIGlzIHN0
aWxsIGFjdGl2ZS4gIA0KPiA+IFNpbXBseSByZW1vdmUgdGhlIHJlbWFpbmluZyBwaWVjZXMgYW5k
IGVuc3VyZSB0aGF0IHRoZSBjb250cm9sbGVyIGlzIA0KPiA+IHN0b3BwZWQgYmVmb3JlIHdlIGZy
ZWUgdGhpbmdzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogSm9uYXRoYW4gQ29yYmV0IDxjb3Ji
ZXRAbHduLm5ldD4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9tZWRpYS92aWRlby9tYXJ2ZWxsLWNj
aWMvbWNhbS1jb3JlLmMgfCAgICA1ICstLS0tDQo+ID4gIGRyaXZlcnMvbWVkaWEvdmlkZW8vbWFy
dmVsbC1jY2ljL21jYW0tY29yZS5oIHwgICAgMSAtDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDUgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZWRpYS92aWRlby9tYXJ2ZWxsLWNjaWMvbWNhbS1jb3JlLmMNCj4gPiBiL2RyaXZlcnMvbWVk
aWEvdmlkZW8vbWFydmVsbC1jY2ljL21jYW0tY29yZS5jDQo+ID4gaW5kZXggMzVjZDg5ZC4uYjI2
MTE4MiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL21hcnZlbGwtY2NpYy9t
Y2FtLWNvcmUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vbWFydmVsbC1jY2ljL21j
YW0tY29yZS5jDQo+ID4gQEAgLTE1NjQsMTEgKzE1NjQsOCBAQCBzdGF0aWMgaW50IG1jYW1fdjRs
X3JlbGVhc2Uoc3RydWN0IGZpbGUgKmZpbHApDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICBz
aW5nbGVzLCBkZWxpdmVyZWQpOw0KPiA+ICAgICAgICBtdXRleF9sb2NrKCZjYW0tPnNfbXV0ZXgp
Ow0KPiA+ICAgICAgICAoY2FtLT51c2VycyktLTsNCj4gPiAtICAgICAgIGlmIChmaWxwID09IGNh
bS0+b3duZXIpIHsNCj4gPiAtICAgICAgICAgICAgICAgbWNhbV9jdGxyX3N0b3BfZG1hKGNhbSk7
DQo+ID4gLSAgICAgICAgICAgICAgIGNhbS0+b3duZXIgPSBOVUxMOw0KPiA+IC0gICAgICAgfQ0K
PiA+ICAgICAgICBpZiAoY2FtLT51c2VycyA9PSAwKSB7DQo+ID4gKyAgICAgICAgICAgICAgIG1j
YW1fY3Rscl9zdG9wX2RtYShjYW0pOw0KPiA+ICAgICAgICAgICAgICAgIG1jYW1fY2xlYW51cF92
YjIoY2FtKTsNCj4gPiAgICAgICAgICAgICAgICBtY2FtX2N0bHJfcG93ZXJfZG93bihjYW0pOw0K
PiA+ICAgICAgICAgICAgICAgIGlmIChjYW0tPmJ1ZmZlcl9tb2RlID09IEJfdm1hbGxvYyAmJiAN
Cj4gPiBhbGxvY19idWZzX2F0X3JlYWQpIGRpZmYgLS1naXQgDQo+ID4gYS9kcml2ZXJzL21lZGlh
L3ZpZGVvL21hcnZlbGwtY2NpYy9tY2FtLWNvcmUuaA0KPiA+IGIvZHJpdmVycy9tZWRpYS92aWRl
by9tYXJ2ZWxsLWNjaWMvbWNhbS1jb3JlLmgNCj4gPiBpbmRleCA5MTcyMDBlLi5iZDZhY2JhIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vbWFydmVsbC1jY2ljL21jYW0tY29y
ZS5oDQo+ID4gKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9tYXJ2ZWxsLWNjaWMvbWNhbS1jb3Jl
LmgNCj4gPiBAQCAtMTA3LDcgKzEwNyw2IEBAIHN0cnVjdCBtY2FtX2NhbWVyYSB7DQo+ID4gICAg
ICAgIGVudW0gbWNhbV9zdGF0ZSBzdGF0ZTsNCj4gPiAgICAgICAgdW5zaWduZWQgbG9uZyBmbGFn
czsgICAgICAgICAgICAvKiBCdWZmZXIgc3RhdHVzLCBtYWlubHkgKGRldl9sb2NrKQ0KPiA+ICov
DQo+ID4gICAgICAgIGludCB1c2VyczsgICAgICAgICAgICAgICAgICAgICAgLyogSG93IG1hbnkg
b3BlbiBGRHMgKi8NCj4gPiAtICAgICAgIHN0cnVjdCBmaWxlICpvd25lcjsgICAgICAgICAgICAg
LyogV2hvIGhhcyBkYXRhIGFjY2VzcyAodjRsMikgKi8NCj4gPg0KPiA+ICAgICAgICAvKg0KPiA+
ICAgICAgICAgKiBTdWJzeXN0ZW0gc3RydWN0dXJlcy4NCj4gPiAtLQ0KPiA+IDEuNy45LjMNCj4g
Pg0KPiA+IC0tDQo+ID4gVG8gdW5zdWJzY3JpYmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxp
bmUgInVuc3Vic2NyaWJlIA0KPiA+IGxpbnV4LW1lZGlhIiBpbiB0aGUgYm9keSBvZiBhIG1lc3Nh
Z2UgdG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZyANCj4gPiBNb3JlIG1ham9yZG9tbyBpbmZv
IGF0ICBodHRwOi8vdmdlci5rZXJuZWwub3JnL21ham9yZG9tby1pbmZvLmh0bWwNCj4gPg0KPiAN
Cg0KLS0tDQpHdWVubmFkaSBMaWFraG92ZXRza2ksIFBoLkQuDQpGcmVlbGFuY2UgT3Blbi1Tb3Vy
Y2UgU29mdHdhcmUgRGV2ZWxvcGVyIGh0dHA6Ly93d3cub3Blbi10ZWNobm9sb2d5LmRlLw0K

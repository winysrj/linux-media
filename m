Return-path: <mchehab@pedra>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36837 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553Ab1BPC5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 21:57:34 -0500
From: Qing Xu <qingx@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>,
	"manjunath.hadli@ti.com" <manjunath.hadli@ti.com>,
	Kassey Li <ygli@marvell.com>, Angela Wan <jwan@marvell.com>
Date: Tue, 15 Feb 2011 18:55:40 -0800
Subject: RE: [RFD] frame-size switching: preview / single-shot use-case
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D014042CB8F7@SC-VEXCH2.marvell.com>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange> 
Content-Language: en-US
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

QWRkIEthc3NleSBhbmQgQW5nZWxhIGluIHRoZSBsb29wLiBUaGFua3MhDQoNCi1RaW5nDQoNCi0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBRaW5nIFh1DQpTZW50OiAyMDExxOoy1MIx
NsjVIDEwOjUxDQpUbzogJ0d1ZW5uYWRpIExpYWtob3ZldHNraSc7IExpbnV4IE1lZGlhIE1haWxp
bmcgTGlzdA0KQ2M6IEhhbnMgVmVya3VpbDsgTmVpbCBKb2huc29uOyBSb2JlcnQgSmFyem1pazsg
VXdlIFRhZXViZXJ0OyBLYXJpY2hlcmksIE11cmFsaWRoYXJhbjsgRWluby1WaWxsZSBUYWx2YWxh
DQpTdWJqZWN0OiBSRTogW1JGRF0gZnJhbWUtc2l6ZSBzd2l0Y2hpbmc6IHByZXZpZXcgLyBzaW5n
bGUtc2hvdCB1c2UtY2FzZQ0KDQpIaSwNCg0KSSBoYXZlIGEgcXVlc3Rpb24gdGhhdCB3aHkgd2Ug
bXVzdCBjaGVjayAiaWNmLT52Yl92aWRxLmJ1ZnNbMF0iIGluDQpzX2ZtdF92aWRfY2FwKCk/IFRo
ZSBhcHBsaWNhdGlvbiBtYWlubHkgY2FsbGluZyBzZXF1ZW5jZSBhdCBzd2l0Y2hpbmcNCmZtdCBj
b3VsZCBiZSBsaWtlIHRoaXM6DQpzdHJlYW1vZmYNCnNfZm10X3ZpZF9jYXANCnJlcXVlc3RfYnVm
DQpxYnVmLi4ucWJ1Zg0Kc3RyZWFtb24NCnFidWYvZHFidWYNCi4uLg0KVGhlIGFwcGxpY2F0aW9u
IHNob3VsZCBhbHNvIGF3YXJlIHRoYXQgdGhleSBhcmUgc3dpdGNoaW5nIHRoZSBmbXQsDQpzbyB0
aGV5IHNob3VsZCByZWxlYXNlIHRoZWlyIGJ1ZmZlcihwZXIgaW4gdXNycHRyIG1ldGhvZCksIGFu
ZCByZS1jYWxsDQpyZXF1ZXN0LWJ1Zi9xYnVmLCBzbyBiYXNlZCBvbiB0aGlzIGFzc3VtcHRpb24s
IGhvdyBhYm91dCB3ZSBjaGVjayAiYnVmc1swXSINCmluIHJlcXVlc3RfYnVmIG9yIHFidWYgYWNj
b3JkaW5nIHRvIHRoZSBuZXcgZm10LCBpZiB3ZSBmaW5kIHRoZSBidWZmZXINCnNpemUgaXMgbm90
IGNvcnJlY3QsIHRoZW4gaW5kaWNhdGUgZXJyb3IgaW4gcmVxdWVzdF9idWYgb3IgcWJ1Zi4NCkhv
d2V2ZXIsaW4gc19mbXRfdmlkX2NhcCwNCndlIG9ubHkgbmVlZCB0byBjaGVjayB3aGV0aGVyIHN0
cmVhbWluZyBpcyBvbi9vZmYsIGlmIGl0IGlzIHN0aWxsIG9uLA0KdGhhdCBtZWFucyBIVyByZXNv
dXJjZSBpcyBub3QgYXZhaWxhYmxlIG9yIElPL2J1ZmZlciBpcyBpbiBwcm9ncmVzcywgdGhlbg0K
d2UgcmVqZWN0IHNfZm10LiBXaGF0IGRvIHlvdSB0aGluaz8NCg0KRm9yIHRoZSBpZGVhIDMsICh3
aGF0IGlzIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gaWRlYSAxIGFuZCAzPykNCmluIG91ciByZWFs
IHVzYWdlIGNhc2VzIG9mIGNhbWVyYShvdXIgcHJvZHVjdCBpcyBhIHBob25lKSwNCndlIHdpbGwg
c2V0IG1hbnkgZm9ybWF0cywgc3VjaCBhczoNCnByZXZpZXdAVkdBLCBwaG90b3NANU0vM00vUVZH
QS9RQ0lGLi4uLCB2aWRlb0AxMDgwcC83MjBwL1ZHQS9RVkdBLCBpZiB3ZQ0KbWFpbnRhaW4gZWFj
aCBxdWV1ZSBmb3IgZWFjaCBmbXQsIGl0IHNlZW1zIHRoYXQgdGhlcmUgYXJlIHRvbyBtYW55IHF1
ZXVlcywNCmFuZCwgaW4gdGhpcyB3YXksIHRoZSBhcHBsaWNhdGlvbiBuZWVkIHRvIGJlIGNoYW5n
ZWQsIGl0IHNob3VsZCBxdWl0ZSBhd2FyZSBvZiBWSURJT0NfQlVGUV9TRUxFQ1QgcXVldWUtaWQg
Zm9yIGVhY2ggZm10LCB0aGVuIGl0IGNvdWxkIGFsbG9jYXRlL3JlbGVhc2UNCnRoZSByZXF1aXJl
ZCBidWZmZXIgcXVldWUgYnkgbmV3IGlvY3RsLiBJcyBteSB1bmRlcnN0YW5kaW5nIGNvcnJlY3Q/
DQoNClRoYW5rcyENCi1RaW5nDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBH
dWVubmFkaSBMaWFraG92ZXRza2kgW21haWx0bzpnLmxpYWtob3ZldHNraUBnbXguZGVdDQpTZW50
OiAyMDExxOoy1MIxNsjVIDE6MzQNClRvOiBMaW51eCBNZWRpYSBNYWlsaW5nIExpc3QNCkNjOiBR
aW5nIFh1OyBIYW5zIFZlcmt1aWw7IE5laWwgSm9obnNvbjsgUm9iZXJ0IEphcnptaWs7IFV3ZSBU
YWV1YmVydDsgS2FyaWNoZXJpLCBNdXJhbGlkaGFyYW47IEVpbm8tVmlsbGUgVGFsdmFsYQ0KU3Vi
amVjdDogW1JGRF0gZnJhbWUtc2l6ZSBzd2l0Y2hpbmc6IHByZXZpZXcgLyBzaW5nbGUtc2hvdCB1
c2UtY2FzZQ0KDQpIaQ0KDQpUaGlzIHRvcGljIGhhcyBiZWVuIHNsaWdodGx5IGRpc2N1c3NlZCBz
ZXZlcmFsIHRpbWVzIFsxXSBiZWZvcmUsIGJ1dCB0aGVyZQ0KaGFzIGJlZW4gbm8gY29uY2x1c2lv
biwgbm9yIEknbSBhd2FyZSBvZiBhbnkgaW1wbGVtZW50YXRpb24sIHN1aXRhYmx5DQpyZXNvbHZp
bmcgdGhpcyBwcm9ibGVtLiBJJ3ZlIGFkZGVkIHRvIENDIGFsbCBpbnZvbHZlZCBpbiBlYXJsaWVy
DQpkaXNjdXNzaW9ucywgdGhhdCBJIG1hbmFnZWQgdG8gZmluZC4NCg0KV2hhdCBzZWVtcyBhIHR5
cGljYWwgdXNlLWNhc2UgdG8gbWUgaXMgYSBzeXN0ZW0gd2l0aCBhIHZld2ZpbmRlciBvciBhDQpk
aXNwbGF5LCBwcm92aWRpbmcgYSBsaXZlIHByZXZpZXcgb2YgdGhlIHZpZGVvIGRhdGEgZnJvbSBh
IHNvdXJjZSwgbGlrZSBhDQpjYW1lcmEsIHdpdGggYSByZWxhdGl2ZWx5IGxvdyByZXNvbHV0aW9u
LCBhbmQgYSBwb3NzaWJpbGl0eSB0byB0YWtlDQpoaWdoLXJlc29sdXRpb24gc3RpbGwgcGhvdG9z
IHdpdGggYSB2ZXJ5IHNob3J0IGRlbGF5Lg0KDQpDdXJyZW50bHkgdGhpcyBpcyBwcmV0dHkgZGlm
ZmljdWx0IHRvIHJlYWxpc2UsIGUuZy4sIHdpdGggc29jLWNhbWVyYQ0KZHJpdmVycyB5b3UgaGF2
ZSB0byBmcmVlIHRoZSB2aWRlb2J1ZigyKSBxdWV1ZSwgYnkgZWl0aGVyIGNsb3NpbmcgYW5kDQpy
ZS1vcGVuaW5nIHRoZSBpbnRlcmZhY2UsIG9yIGJ5IGlzc3VpbmcgYW4gaW9jdGwoVklESU9DX1JF
UUJVRlMsDQpjb3VudD0wKSBpZiB5b3VyIGRyaXZlciBpcyBhbHJlYWR5IHVzaW5nIHZpZGVvYnVm
MiBhbmQgaWYgdGhpcyBpcyByZWFsbHkNCndvcmtpbmc7KSwgY29uZmlndXJlIHdpdGggYSBkaWZm
ZXJlbnQgcmVzb2x1dGlvbiBhbmQgcmUtYWxsb2NhdGUNCnZpZGVvYnVmZmVycyAob3IgdXNlIGRp
ZmZlcmVudCBidWZmZXJzLCBhbGxvY2F0ZWQgcGVyIFVTRVJQVFIpLiBBbm90aGVyDQpwb3NzaWJp
bGl0eSB3b3VsZCBiZSB0byBhbGxvY2F0ZSBhbmQgdXNlIGJ1ZmZlcnMgbGFyZ2UgZW5vdWdoIGZv
ciBzdGlsbA0KcGhvdG9zLCBhbHNvIGZvciB0aGUgcHJldmlldywgd2hpY2ggd291bGQgYmUgd2Fz
dGVmdWwsIGJlY2F1c2Ugb25lIGNhbg0Kd2VsbCBuZWVkIG1hbnkgbW9yZSBwcmV2aWV3IHRoYW4g
c3RpbGwtc2hvdCBidWZmZXJzLg0KDQpTbywgaXQgc2VlbXMgdG8gbWUsIHdlIGNvdWxkIGxpdmUg
d2l0aCBhIGJldHRlciBzb2x1dGlvbi4NCg0KMS4gV2UgY291bGQgdXNlIHNlcGFyYXRlIGlucHV0
cyBmb3IgZGlmZmVyZW50IGNhcHR1cmUgbW9kZXMgYW5kIHN1cHBvcnQNCnBlci1pbnB1dCB2aWRl
b2J1ZiBxdWV1ZXMuIEFkdmFudGFnZTogbm8gQVBJIGNoYW5nZXMgcmVxdWlyZWQuDQpEaXNhZHZh
bnRhZ2VzOiBjb25mdXNpbmcsIGVzcGVjaWFsbHksIGlmIGEgZHJpdmVyIGFscmVhZHkgZXhwb3J0
cyBtdWx0aXBsZQ0KaW5wdXRzLiBUaGUgZHJpdmVyIGRvZXMgbm90IGtub3csIHdoZXRoZXIgdGhp
cyBtb2RlIGlzIHJlcXVpcmVkIG9yIG5vdCwNCmFsd2F5cyBleHBvcnRpbmcgMiBpbnB1dHMgZm9y
IHRoaXMgcHVycG9zZSBkb2Vzbid0IHNlZW0gbGlrZSBhIGdvb2QgaWRlYS4NCkV2ZW50dWFsbHks
IHRoZSB1c2VyIG1pZ2h0IHdhbnQgbm90IDIsIGJ1dCAzIG9yIG1vcmUgb2Ygc3VjaCB2aWRlb2J1
Zg0KcXVldWVzLg0KDQoyLiBVc2UgZGlmZmVyZW50IElPIG1ldGhvZHMsIGUuZy4sIG1tYXAoKSBm
b3IgcHJldmlldyBhbmQgcmVhZCgpIGZvciBzdGlsbA0Kc2hvdHMuIEknbSBqdXN0IG1lbnRpb25p
bmcgdGhpcyBwb3NzaWJpbGl0eSBoZXJlLCBiZWNhdXNlIGl0IG9jY3VycmVkIGluDQpvbmUgb2Yg
cHJldmlvdXMgdGhyZWFkcywgYnV0IEkgZG9uJ3QgcmVhbGx5IGxpa2UgaXQgZWl0aGVyLiBXaGF0
IGlmIHlvdQ0Kd2FudCB0byB1c2UgdGhlIHNhbWUgSU8gbWV0aG9kIGZvciBhbGw/IEV0Yy4NCg0K
My4gTm90IGxpa2luZyBlaXRoZXIgb2YgdGhlIGFib3ZlLCBpdCBzZWVtcyB3ZSBuZWVkIHlldCBh
IG5ldyBBUEkgZm9yDQp0aGlzLi4uIEhvdyBhYm91dCBleHRlbmRpbmcgVklESU9DX1JFUUJVRlMg
d2l0aCBhIHZpZGVvYnVmIHF1ZXVlIGluZGV4LA0KdGh1cyB1c2luZyB1cCBvbmUgb2YgdGhlIHJl
bWFpbmluZyB0d28gMzItYml0IHJlc2VydmVkIGZpZWxkcz8gVGhlbiB3ZQ0KbmVlZCBvbmUgbW9y
ZSBpb2N0bCgpIGxpa2UgVklESU9DX0JVRlFfU0VMRUNUIHRvIHN3aXRjaCBmcm9tIG9uZSBxdWV1
ZSB0bw0KYW5vdGhlciwgYWZ0ZXIgd2hpY2ggc2V0dGluZyBmcmFtZSBmb3JtYXQgYW5kIHF1ZXVp
bmcgYW5kIGRlcXVldWluZw0KYnVmZmVycyB3aWxsIGFmZmVjdCB0aGlzIGN1cnJlbnRseSBzZWxl
Y3RlZCBxdWV1ZS4gV2UgY291bGQgYWxzbyBrZWVwDQpSRVFCVUZTIGFzIGlzIGFuZCByZXF1aXJl
IEJVRlFfU0VMRUNUIHRvIGJlIGNhbGxlZCBiZWZvcmUgaXQgZm9yIGFueSBxdWV1ZQ0KZXhjZXB0
IHRoZSBkZWZhdWx0IDAuDQoNClllcywgSSBrbm93LCB0aGF0IHNvbWUgdmlkZW8gc2Vuc29ycyBo
YXZlIGEgZG91YmxlIHJlZ2lzdGVyIHNldCBmb3IgdGhpcw0KZHVhbC1mb3JtYXQgb3BlcmF0aW9u
LCBzbywgZm9yIHRoZW0gaXQgaXMgbmF0dXJhbCB0byBzdXBwb3J0IHR3byBxdWV1ZXMsDQphbmQg
ZHJpdmVycyBhcmUgY2VydGFpbmx5IG1vc3Qgd2VsY29tZSB0byB1c2UgdGhpcyBmZWF0dXJlIGZv
ciwgc2F5LCB0aGUNCmZpcnN0IHR3byBxdWV1ZXMuIE9uIG90aGVyIHNlbnNvcnMgYW5kIGZvciBh
bnkgZnVydGhlciBxdWV1ZXMgc3dpdGNoaW5nDQp3aWxsIGhhdmUgdG8gYmUgZG9uZSBpbiBzb2Z0
d2FyZS4NCg0KSWRlYXM/IENvbW1lbnRzPw0KDQpUaGFua3MNCkd1ZW5uYWRpDQotLS0NCkd1ZW5u
YWRpIExpYWtob3ZldHNraSwgUGguRC4NCkZyZWVsYW5jZSBPcGVuLVNvdXJjZSBTb2Z0d2FyZSBE
ZXZlbG9wZXINCmh0dHA6Ly93d3cub3Blbi10ZWNobm9sb2d5LmRlLw0K

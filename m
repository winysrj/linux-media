Return-path: <linux-media-owner@vger.kernel.org>
Received: from [103.7.28.223] ([103.7.28.223]:50360 "EHLO smtpbg64.qq.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753886AbeFKCLA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 22:11:00 -0400
From: "=?ISO-8859-1?B?SmFjb2IgQ2hlbg==?=" <jacob-chen@iotwrt.com>
To: "=?ISO-8859-1?B?RXplcXVpZWwgR2FyY2lh?=" <ezequiel@collabora.com>,
        "=?ISO-8859-1?B?bGludXgtbWVkaWE=?=" <linux-media@vger.kernel.org>
Cc: "=?ISO-8859-1?B?aGVpa28=?=" <heiko@sntech.de>,
        "=?ISO-8859-1?B?TWF1cm8gQ2FydmFsaG8gQ2hlaGFi?=" <mchehab@kernel.org>,
        "=?ISO-8859-1?B?bGludXgtcm9ja2NoaXA=?="
        <linux-rockchip@lists.infradead.org>,
        "=?ISO-8859-1?B?amFjb2JjaGVuMTEw?=" <jacobchen110@gmail.com>,
        "=?ISO-8859-1?B?aGFucy52ZXJrdWls?=" <hans.verkuil@cisco.com>
Subject: Re:  [PATCH 0/2] rockchip/rga: A fix and a cleanup
Mime-Version: 1.0
Content-Type: text/plain;
        charset="ISO-8859-1"
Content-Transfer-Encoding: base64
Date: Mon, 11 Jun 2018 10:02:42 +0800
Message-ID: <tencent_7145303C52804A69C5DCA429C5EBE474240A@qq.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgRXplcXVpZWwsCgo+IENjaW5nIEphY29iIGF0IHRoZSByaWdodCBhZGRyZXNzLkNjaW5n
IEphY29iIGF0IHRoZSByaWdodCBhZGRyZXNzLgo+IAo+IFBlcmhhcHMgd2Ugc2hvdWxkIGZp
eCB0aGUgTUFJTlRBSU5FUlMgZmlsZS4KPiAKPiBPbiBGcmksIDIwMTgtMDYtMDEgYXQgMTY6
NDkgLTAzMDAsIEV6ZXF1aWVsIEdhcmNpYSB3cm90ZToKPiA+IERlY2lkZWQgdG8gdGVzdCB2
NGwydHJhbnNmb3JtIGZpbHRlcnMgYW5kIGZvdW5kIHRoZXNlIHR3bwo+ID4gaXNzdWVzLgo+
ID4gCj4gPiBXaXRob3V0IHRoZSBmaXJzdCBjb21taXQsIHN0YXJ0X3N0cmVhbWluZyBmYWls
cy4gVGhlIHNlY29uZAo+ID4gY29tbWl0IGlzIGp1c3QgYSBjbGVhbnVwLCByZW1vdmluZyBh
IHNlZW1pbmdseSByZWR1bmRhbnQKPiA+IG9wZXJhdGlvbi4KPiA+IAo+ID4gVGVzdGVkIG9u
IFJLMzI4OCBSYWR4YSBSb2NrMiB3aXRoIHRoZXNlIGtpbmQgb2YgcGlwZWxpbmVzOgo+ID4g
Cj4gPiBnc3QtbGF1bmNoLTEuMCB2aWRlb3Rlc3RzcmMgISB2aWRlby94LQo+ID4gcmF3LHdp
ZHRoPTY0MCxoZWlnaHQ9NDgwLGZyYW1lcmF0ZT0zMC8xLGZvcm1hdD1SR0IgIQo+ID4gdjRs
MnZpZGVvMGNvbnZlcnQgISB2aWRlby94LQo+ID4gcmF3LHdpZHRoPTE5MjAsaGVpZ2h0PTEw
ODAsZnJhbWVyYXRlPTMwLzEsZm9ybWF0PU5WMTYgISBmYWtlc2luawo+ID4gCj4gPiBnc3Qt
bGF1bmNoLTEuMCB2NGwyc3JjIGRldmljZT0vZGV2L3ZpZGVvMSAhIHZpZGVvL3gtCj4gPiBy
YXcsd2lkdGg9NjQwLGhlaWdodD00ODAsZnJhbWVyYXRlPTMwLzEsZm9ybWF0PVJHQiAhCj4g
PiB2NGwydmlkZW8wY29udmVydCAhIHZpZGVvL3gtCj4gPiByYXcsd2lkdGg9MTkyMCxoZWln
aHQ9MTA4MCxmcmFtZXJhdGU9MzAvMSxmb3JtYXQ9TlYxNiAhIGttc3NpbmsKPiA+IAo+ID4g
RXplcXVpZWwgR2FyY2lhICgyKToKPiA+ICAgcm9ja2NoaXAvcmdhOiBGaXggYnJva2VuIC5z
dGFydF9zdHJlYW1pbmcKPiA+ICAgcm9ja2NoaXAvcmdhOiBSZW1vdmUgdW5yZXF1aXJlZCB3
YWl0IGluIC5qb2JfYWJvcnQKPiA+IAo+ID4gIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vcm9j
a2NoaXAvcmdhL3JnYS1idWYuYyB8IDQ0ICsrKysrKysrKy0tLS0tLQo+ID4gLS0tLQo+ID4g
IGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vcm9ja2NoaXAvcmdhL3JnYS5jICAgICB8IDEzICst
LS0tLQo+ID4gIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vcm9ja2NoaXAvcmdhL3JnYS5oICAg
ICB8ICAyIC0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDM2IGRl
bGV0aW9ucygtKQo+ID4gCgpUbyBib3RoIHBhdGNoZXMsClJldmlld2VkLWJ5OiBKYWNvYiBD
aGVuPGphY29iLWNoZW5AaW90d3J0LmNvbT4KCkl0IHNlZW1zIHRoZSBjdXJyZW50IGpvYl9h
Ym9ydCB3aWxsIGFsc28gY2F1c2UgdW5uZWNlc3Nhcnkgd2FpdCB3aGVuIHVzaW5nIG11bHRp
LWluc3RhbmNlLg==

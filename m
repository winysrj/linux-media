Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1Jh3QY-0001h1-TV
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 15:55:03 +0200
Received: from [10.10.43.100] (e180066254.adsl.alicedsl.de [85.180.66.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 6A86A44195
	for <linux-dvb@linuxtv.org>; Wed,  2 Apr 2008 15:54:55 +0200 (CEST)
Message-ID: <47F3902E.6060002@okg-computer.de>
Date: Wed, 02 Apr 2008 15:54:54 +0200
From: =?UTF-8?B?SmVucyBLcmVoYmllbC1HcsOkdGhlcg==?= <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <JQH8LK$96D0E7F415C0B19866A44914B01BB54A@libero.it>
	<4720EEC9.7040004@gmail.com>
In-Reply-To: <4720EEC9.7040004@gmail.com>
Subject: [linux-dvb] Problems compiling hacked szap.c
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

SGkhCgpJIGhhdmUgcHJvYmxlbXMgY29tcGlsaW5nIHN6YXAuYyBmb3IgbXVsdGlwcm90by4gSSB1
c2Uga2VybmVsIDIuNi4yNApJIGZvbGxvd2VkIHRoZSBpbnN0cnVjdGlvbnMgb2YgTWFudSBwb3N0
ZWQgdG8gdGhlIGxpc3QgYSBmZXcgbW9udGhzIGFnbzoKCj4gTWFrZSBzdXJlIHlvdSBoYXZlIHRo
ZSB1cGRhdGVkIGhlYWRlcnMgKGZyb250ZW5kLmgsIHZlcnNpb24uaCBpbiB5b3VyIGluY2x1ZGUg
cGF0aCkKPiAoWW91IG5lZWQgdGhlIHNhbWUgaGVhZGVycyBmcm9tIHRoZSBtdWx0aXByb3RvIHRy
ZWUpCj4KPiB3Z2V0IGh0dHA6Ly9hYnJhaGFtLm1hbnUuZ29vZ2xlcGFnZXMuY29tL3N6YXAuYwo+
IGNvcHkgbG5iLmMgYW5kIGxuYi5oIGZyb20gZHZiLWFwcHMgdG8gdGhlIHNhbWUgZm9sZGVyIHdo
ZXJlIHlvdSBkb3dubG9hZGVkIHN6YXAuYwo+Cj4gY2MgLWMgbG5iLmMKPiBjYyAtYyBzemFwLmMK
PiBjYyAtbyBzemFwIHN6YXAubyBsbmIubwo+Cj4gVGhhdCdzIGl0Cj4KPiBNYW51CgpidXQgaXQg
d29uJ3Qgd29yay4KCkkgZ2V0IHRoZSBmb2xsb3dpbmcgZXJyb3I6CgpkZXY6L3Vzci9zcmMvc3ph
cCMgY2MgLWMgc3phcC5jCnN6YXAuYzogSW4gZnVuY3Rpb24g4oCYemFwX3Rv4oCZOgpzemFwLmM6
MzY4OiBlcnJvcjog4oCYc3RydWN0IGR2YmZlX2luZm/igJkgaGFzIG5vIG1lbWJlciBuYW1lZCDi
gJhkZWxpdmVyeeKAmQpzemFwLmM6MzcyOiBlcnJvcjog4oCYc3RydWN0IGR2YmZlX2luZm/igJkg
aGFzIG5vIG1lbWJlciBuYW1lZCDigJhkZWxpdmVyeeKAmQpzemFwLmM6Mzc2OiBlcnJvcjog4oCY
c3RydWN0IGR2YmZlX2luZm/igJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhkZWxpdmVyeeKAmQpz
emFwLmM6NDAxOiBlcnJvcjog4oCYc3RydWN0IGR2YmZlX2luZm/igJkgaGFzIG5vIG1lbWJlciBu
YW1lZCDigJhkZWxpdmVyeeKAmQpzemFwLmM6NDEyOiBlcnJvcjog4oCYc3RydWN0IGR2YmZlX2lu
Zm/igJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhkZWxpdmVyeeKAmQpkZXY6L3Vzci9zcmMvc3ph
cCMKCmxuYi5jIGNvbXBpbGVzIHdpdGhvdXQgZXJyb3IuCgpJIGhhdmUgY29tcGlsZWQgc3phcCB1
bmRlciBvbGRlciBrZXJuZWwgd2l0aG91dCBlcnJvciwgYnV0IHdoZW4gSSB1c2UgCnRoaXMgY29t
cGlsZWQgc3phcCBub3cgKHVuZGVyIDIuNi4yNCkgSSBnZXQgdGhlIGZvbGxvd2luZyBlcnJvcjoK
CmRldjp+IyBzemFwIFByb1NpZWJlbgpyZWFkaW5nIGNoYW5uZWxzIGZyb20gZmlsZSAnL3Jvb3Qv
LnN6YXAvY2hhbm5lbHMuY29uZicKemFwcGluZyB0byAyMDggJ1Byb1NpZWJlbic6CnNhdCAwLCBm
cmVxdWVuY3kgPSAxMjU0NCBNSHogSCwgc3ltYm9scmF0ZSAyMjAwMDAwMCwgdnBpZCA9IDB4MDFm
ZiwgYXBpZCAKPSAweDAyMDAgc2lkID0gMHg0NDVkClF1ZXJ5aW5nIGluZm8gLi4gRGVsaXZlcnkg
c3lzdGVtPURWQi1TCnVzaW5nICcvZGV2L2R2Yi9hZGFwdGVyMC9mcm9udGVuZDAnIGFuZCAnL2Rl
di9kdmIvYWRhcHRlcjAvZGVtdXgwJwppb2N0bCBEVkJGRV9HRVRfSU5GTyBmYWlsZWQ6IE9wZXJh
dGlvbiBub3Qgc3VwcG9ydGVkCmRldjp+IwoKSSd2ZSBzdWNjZXNzZnVsbHkgY29tcGlsZWQgbXVs
dGlwcm90byBkcml2ZXJzIHdpdGggdGhlIGNvbXBhdC5oIHBhdGNoIApmw7xyIDIuNi4yNCBrZXJu
ZWwuIFRoZSBtb2R1bGVzIGxvYWQgd2l0aG91dCBlcnJvcnMsIGJ1dCBJIGNhbiBub3Qgc3phcCAK
dG8gYW55IGNoYW5uZWwuCgpDYW4geW91IGhlbHAgbWU/PwoKVGhhbmtzLAogIEplbnMKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmxpbnV4LWR2YiBtYWls
aW5nIGxpc3QKbGludXgtZHZiQGxpbnV4dHYub3JnCmh0dHA6Ly93d3cubGludXh0di5vcmcvY2dp
LWJpbi9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWR2Yg==

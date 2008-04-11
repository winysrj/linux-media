Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JkSGC-0003BV-O0
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 01:02:25 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Nick Andrew <nick-linuxtv@nick-andrew.net>
In-Reply-To: <20080411164608.GB28897@tull.net>
References: <200803292240.25719.janne-dvb@grunau.be>
	<37219a840804080818x729fd503ka3ba048c46169bcb@mail.gmail.com>
	<200804090022.40805@orion.escape-edv.de>
	<200804091121.22092.janne-dvb@grunau.be>
	<37219a840804090744l2fe7eacbncabd7a2ccf7979b@mail.gmail.com>
	<20080409232544.GA31564@tull.net> <20080409234452.GB31564@tull.net>
	<1207788941.3380.7.camel@pc08.localdom.local>
	<20080411164608.GB28897@tull.net>
Date: Sat, 12 Apr 2008 01:02:02 +0200
Message-Id: <1207954922.6271.35.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option	to	choose
	dvb adapter numbers, second try
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

QW0gU2Ftc3RhZywgZGVuIDEyLjA0LjIwMDgsIDAyOjQ2ICsxMDAwIHNjaHJpZWIgTmljayBBbmRy
ZXc6Cj4gT24gVGh1LCBBcHIgMTAsIDIwMDggYXQgMDI6NTU6NDFBTSArMDIwMCwgaGVybWFubiBw
aXR0b24gd3JvdGU6Cj4gPiBJdCBpcyB0b3RhbGx5IHVuaW50ZXJlc3RpbmcgYW5kIGZ1bGx5IE9U
IEkgdGhpbmsuCj4gCj4gU29ycnkgSGVybWFubiwgSSdsbCB0cnkgdG8gc3RpY2sgdG8gdGhlIHRv
cGljIGluIGZ1dHVyZS4KPiAKPiBOaWNrLgoKSGkgTmljaywKCnNlZW1zIGl0IGlzIG15IHR1cm4g
bm93LCBwbGVhc2UgZXhjdXNlIQoKVGhlIGFib3ZlIHJhbnQgd2FzIG5vdCBtZWFudCBzdWNoIHNl
cmlvdXNseSBhbmQgSSB0aG91Z2h0IHRoYXQgd2UgY2FuCmxpdmUgd2l0aCBzb21lICJQaWRnaW4g
RW5nbGlzaCA7KSIuCgpZb3UgYW5kIGV2ZXJ5b25lIGhhcyBvZiBjb3Vyc2UgYWxsIGFuZCBhbnkg
cmlnaHRzIHRvIHJpc2Ugc3VjaCBxdWVzdGlvbnMKYW5kIEknbSBub3QgYWdhaW5zdCBmaXhlcyBh
bmQgcGF0Y2hlcyBhdCBhbGwuIFdlIGV2ZW4gbXVzdCB0aGFuayBuYXRpdmUKc3BlYWtlcnMgdG8g
Y2FyZSBmb3IgaXQuCgpJbiBmYWN0LCBpdCBpcyByZWFsbHkgb2Z0ZW4gdmVyeSBpbnRlcmVzdGlu
ZyB0byBmb2xsb3cgaGlzdG9yeSwgYXMgaXQgaXMKcHJlc2VydmVkIGluIHRoZSBkaWZmZXJlbnQg
bGFuZ3VhZ2VzLiBXZSBoYWQgYSBuaWNlIGNhc2UgcHJldmlvdXNseSB3aXRoCm9sZCBTRUNBTSBM
wrQgaW4gRnJhbmNlLgoKV2UganVzdCBzaG91bGQga2VlcCBpdCBvbiBhIGxldmVsLCBzaW1pbGFy
IGxpa2Ugd2hpdGVzcGFjZSBjbGVhbnVwcyBvcgp3aGF0IHdlIGhhdmUgY3VycmVudGx5IHdpdGgg
Y2hlY2twYXRjaC5wbCBvbiBvbGRlciBjb2RlLCB3aGljaCBfd2FzCnJldmlld2VkXywgYW5kIHN0
YXkgcmVsYXhlZC4KClRvIGJlIGhvbmVzdCwgSSBzdGlsbCBleHBlY3RlZCBNYW51IHRvIE5BQ0sg
dGhpcywgYXMgdXN1YWwsIGFsc28KcHJldmlvdXNseSBmb3IgYXNzb2NpYXRpbmcgdGhlIFBDSSBi
cmlkZ2VzIGFuZCBpMmMgbWFzdGVycyB3aXRoIHRoZQpmcm9udGVuZHMuCgpJZiB0aGUgYXJndW1l
bnRzIGFyZSBnb29kLCBJIHN0aWxsIGRvIGFjY2VwdCB0aGVtLgoKQ2hlZXJzLApIZXJtYW5uCgoK
CgoKCgoKCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
bGludXgtZHZiIG1haWxpbmcgbGlzdApsaW51eC1kdmJAbGludXh0di5vcmcKaHR0cDovL3d3dy5s
aW51eHR2Lm9yZy9jZ2ktYmluL21haWxtYW4vbGlzdGluZm8vbGludXgtZHZi

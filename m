Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1LJSJ6-0003LJ-BR
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 13:42:17 +0100
Date: Sun, 4 Jan 2009 14:42:06 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20090104111429.1f828fc8@bk.ru>
Message-ID: <Pine.LNX.4.64.0901041435090.1668@shogun.pilppa.org>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com> <20090104111429.1f828fc8@bk.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463809533-1839908902-1231072926=:1668"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463809533-1839908902-1231072926=:1668
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

> http://mercurial.intuxication.org/hg/s2-liplianin (yesterday Igor synchronized it with current v4l-dvb)
> +
> http://hg.kewl.org/dvb2010/ - new dvb scaner
>
> for me everything is working without any problem with my hvr4000. Also patched vdr 170 works well with s2api

Can you test whether channel switching works for you with
following
- vdr-1.7.2
- vdr-1.7.2-h264-syncearly-framespersec-audioindexer-fielddetection-speedup.diff
- vdr172_v4ldvb_2g_modulation_support.patch (attached)
- streamdev plugin

I can only watch those channels that I have previously tuned with szap or 
szap2 or vdr.1.6.0? If it works for you, what other cards than hvr-4000 
you have simultaneously connected and does the hvr-4000 be 
/dev/dvb/adapter0 or 1? (for me it's adapter1)


---1463809533-1839908902-1231072926=:1668
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=vdr172_v4ldvb_2g_modulation_support.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0901041442060.1668@shogun.pilppa.org>
Content-Description: 
Content-Disposition: attachment; filename=vdr172_v4ldvb_2g_modulation_support.patch

ZGlmZiAtLWdpdCBhL2R2YmRldmljZS5jIGIvZHZiZGV2aWNlLmMNCmluZGV4
IGUwYjA1YTEuLjA4ZGM2M2YgMTAwNjQ0DQotLS0gYS9kdmJkZXZpY2UuYw0K
KysrIGIvZHZiZGV2aWNlLmMNCkBAIC0zMiw3ICszMiw3IEBADQogLy8gdW5w
YXRjaGVkIGRyaXZlci4gSG93ZXZlciwgd2l0aCBhbiB1bnBhdGNoZWQgZHJp
dmVyIGl0IHdpbGwgbm90IHN1cHBvcnQNCiAvLyBEVkItUzIgaGFyZHdhcmUu
IElmIHlvdSBoYXZlIERWQi1TMiBoYXJkd2FyZSB5b3UgbmVlZCB0byBlaXRo
ZXIgcGF0Y2gNCiAvLyB0aGUgZHJpdmVyIG9yIG1vZGlmeSB0aGUgbGluZSB0
aGF0IHVzZXMgdGhpcyBtYWNybyBpbiBjRHZiRGV2aWNlOjpjRHZiRGV2aWNl
KCkuDQotI2RlZmluZSBGRV9DQU5fMk5EX0dFTl9NT0RVTEFUSU9OIDB4MTAw
MDAwMDANCisjZGVmaW5lIEZFX0NBTl8yR19NT0RVTEFUSU9OIDB4MTAwMDAw
MDANCiANCiAjZGVmaW5lIERPX1JFQ19BTkRfUExBWV9PTl9QUklNQVJZX0RF
VklDRSAxDQogI2RlZmluZSBET19NVUxUSVBMRV9SRUNPUkRJTkdTIDENCkBA
IC00OTEsNyArNDkxLDcgQEAgY0R2YkRldmljZTo6Y0R2YkRldmljZShpbnQg
bikNCiAgIGlmIChmZF9mcm9udGVuZCA+PSAwKSB7DQogICAgICBpZiAoaW9j
dGwoZmRfZnJvbnRlbmQsIEZFX0dFVF9JTkZPLCAmZnJvbnRlbmRJbmZvKSA+
PSAwKSB7DQogICAgICAgICBzd2l0Y2ggKGZyb250ZW5kSW5mby50eXBlKSB7
DQotICAgICAgICAgIGNhc2UgRkVfUVBTSzogZnJvbnRlbmRUeXBlID0gKGZy
b250ZW5kSW5mby5jYXBzICYgRkVfQ0FOXzJORF9HRU5fTU9EVUxBVElPTikg
PyBTWVNfRFZCUzIgOiBTWVNfRFZCUzsgYnJlYWs7DQorICAgICAgICAgIGNh
c2UgRkVfUVBTSzogZnJvbnRlbmRUeXBlID0gKGZyb250ZW5kSW5mby5jYXBz
ICYgRkVfQ0FOXzJHX01PRFVMQVRJT04pID8gU1lTX0RWQlMyIDogU1lTX0RW
QlM7IGJyZWFrOw0KICAgICAgICAgICBjYXNlIEZFX09GRE06IGZyb250ZW5k
VHlwZSA9IFNZU19EVkJUOyBicmVhazsNCiAgICAgICAgICAgY2FzZSBGRV9R
QU06ICBmcm9udGVuZFR5cGUgPSBTWVNfRFZCQ19BTk5FWF9BQzsgYnJlYWs7
DQogICAgICAgICAgIGNhc2UgRkVfQVRTQzogZnJvbnRlbmRUeXBlID0gU1lT
X0FUU0M7IGJyZWFrOw0KQEAgLTUwNSw2ICs1MDUsNyBAQCBjRHZiRGV2aWNl
OjpjRHZiRGV2aWNlKGludCBuKQ0KICAgICAgICAgaWYgKGZyb250ZW5kVHlw
ZSA9PSBTWVNfRFZCUzIpDQogICAgICAgICAgICBudW1Qcm92aWRlZFN5c3Rl
bXMrKzsNCiAgICAgICAgIGlzeXNsb2coImRldmljZSAlZCBwcm92aWRlcyAl
cyAoXCIlc1wiKSIsIENhcmRJbmRleCgpICsgMSwgRGVsaXZlcnlTeXN0ZW1z
W2Zyb250ZW5kVHlwZV0sIGZyb250ZW5kSW5mby5uYW1lKTsNCisJcHJpbnRm
KCJkZXZpY2UgJWQgcHJvdmlkZXMgJXMgKFwiJXNcIilcbiIsIENhcmRJbmRl
eCgpICsgMSwgRGVsaXZlcnlTeXN0ZW1zW2Zyb250ZW5kVHlwZV0sIGZyb250
ZW5kSW5mby5uYW1lKTsNCiAgICAgICAgIGR2YlR1bmVyID0gbmV3IGNEdmJU
dW5lcihmZF9mcm9udGVuZCwgQ2FyZEluZGV4KCksIGZyb250ZW5kVHlwZSk7
DQogICAgICAgICB9DQogICAgICB9DQo=

---1463809533-1839908902-1231072926=:1668
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---1463809533-1839908902-1231072926=:1668--

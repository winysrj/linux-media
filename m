Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp28.orange.fr ([80.12.242.99])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@bercot.org>) id 1Kjgek-0003B1-4o
	for linux-dvb@linuxtv.org; Sat, 27 Sep 2008 22:44:46 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2803.orange.fr (SMTP Server) with ESMTP id 94DC78000097
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 22:44:12 +0200 (CEST)
Received: from mail.bercot.org (LRouen-151-71-134-185.w193-253.abo.wanadoo.fr
	[193.253.252.185])
	by mwinf2803.orange.fr (SMTP Server) with ESMTP id 7B8278000083
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 22:44:12 +0200 (CEST)
Received: from david.huperie (localhost [127.0.0.1])
	by mail.bercot.org (Postfix) with ESMTP id 597033C05A
	for <linux-dvb@linuxtv.org>; Sat, 27 Sep 2008 22:54:24 +0200 (CEST)
Date: Sat, 27 Sep 2008 22:44:11 +0200
From: David BERCOT <linux-dvb@bercot.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080927224411.003bd002@david.huperie>
In-Reply-To: <d9def9db0809271339w70e64903o6a2026840cce5f6f@mail.gmail.com>
References: <20080927201547.2fbde736@david.huperie>
	<d9def9db0809271230p561c022aoa2a32c8806688f68@mail.gmail.com>
	<20080927221314.1313010c@david.huperie>
	<d9def9db0809271339w70e64903o6a2026840cce5f6f@mail.gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] How installing em28xx ?
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

TGUgU2F0LCAyNyBTZXAgMjAwOCAyMjozOTowOSArMDIwMCwKIk1hcmt1cyBSZWNoYmVyZ2VyIiA8
bXJlY2hiZXJnZXJAZ21haWwuY29tPiBhIMOpY3JpdCA6Cj4gPj4gT24gU2F0LCBTZXAgMjcsIDIw
MDggYXQgODoxNSBQTSwgRGF2aWQgQkVSQ09UCj4gPj4gPGxpbnV4LWR2YkBiZXJjb3Qub3JnPiB3
cm90ZToKPiA+PiA+IEhpLAo+ID4+ID4KPiA+PiA+IEkgdXNlZCBlbTI4eHggZm9yIHRoZSBwYXN0
LCBidXQgbm93LCBpdCBzZWVtcyB0byBiZSBtb3JlCj4gPj4gPiBjb21wbGljYXRlZC4uLiBJbiBo
dHRwOi8vbWNlbnRyYWwuZGUvaGcgSSBmb3VuZCBlbTI4eHgtbmV3IChidXQgSQo+ID4+ID4gaGF2
ZSBtYW55IGVycm9ycyA6IFsuLi5dCj4gPj4gPiAnZHZiX25ldF9yZWxlYXNlJyAvb3B0L2VtMjh4
eC1uZXcvZW0yODgwLWR2Yi5jOjk3NjogZXJyZXVyOgo+ID4+ID4gaW1wbGljaXQgZGVjbGFyYXRp
b24gb2YgZnVuY3Rpb24KPiA+PiA+ICdkdmJfdW5yZWdpc3Rlcl9mcm9udGVuZCcgL29wdC9lbTI4
eHgtbmV3L2VtMjg4MC1kdmIuYzo5Nzc6Cj4gPj4gPiBlcnJldXI6IGltcGxpY2l0IGRlY2xhcmF0
aW9uIG9mIGZ1bmN0aW9uCj4gPj4gPiAnZHZiX2Zyb250ZW5kX2RldGFjaCcgL29wdC9lbTI4eHgt
bmV3L2VtMjg4MC1kdmIuYzo5ODE6IGVycmV1cjoKPiA+PiA+IGltcGxpY2l0IGRlY2xhcmF0aW9u
IG9mIGZ1bmN0aW9uCj4gPj4gPiAnZHZiX2RteF9yZWxlYXNlJyAvb3B0L2VtMjh4eC1uZXcvZW0y
ODgwLWR2Yi5jOjk4MzogZXJyZXVyOgo+ID4+ID4gaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVu
Y3Rpb24gJ2R2Yl91bnJlZ2lzdGVyX2FkYXB0ZXInCj4gPj4gPiBbLi4uXSkgYW5kIHRoZSAib2xk
IiB2NGwtZHZiLWtlcm5lbCAmIHY0bC1kdmItZXhwZXJpbWVudGFsCj4gPj4gPiBkb2Vzbid0IHdv
cmsgYW55IG1vcmUgc2luY2UgMi42LjI2IGtlcm5lbC4KPiA+PiA+IEkgc2hvdWxkIHVzZSBtdWx0
aXByb3RvLCBidXQgaXQgc2VlbXMgaGVhdnksIG5vID8KPiA+PiA+Cj4gPj4gPiBEbyB5b3UgaGF2
ZSBhbnkgc3VnZ2VzdGlvbiA/Cj4gPj4KPiA+PiBkbyB5b3UgaGF2ZSBhIGN1c3RvbSBrZXJuZWw/
IG9yIGEgZGVmYXVsdCBkaXN0cmlidXRpb24gLSBhbmQgd2hpY2gKPiA+PiBvbmU/Cj4gPgo+ID4g
Tm8sIGl0IGlzIGEgY2xhc3NpY2FsIGtlcm5lbCA6IDIuNi4yNi0xLTY4NiBvbiBEZWJpYW4gU2lk
Lgo+ID4gU2hvdWxkIEkgcHV0IGFsbCB0aGUgZXJyb3JzID8KPiAKPiA+PiA+ICdkdmJfdW5yZWdp
c3Rlcl9mcm9udGVuZCcgL29wdC9lbTI4eHgtbmV3L2VtMjg4MC1kdmIuYzo5Nzc6Cj4gPj4gPiBl
cnJldXI6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uCj4gCj4gdGhpcyBtZWFucyBp
dCBjYW5ub3QgZmluZCBzb21lIGhlYWRlcnMsIHlvdSBuZWVkIHRvIGluc3RhbGwgdGhlIGZ1bGwK
PiBrZXJuZWwgc291cmNlcyBmb3IgeW91ciBpbnN0YWxsZWQKPiBrZXJuZWwgYmVmb3JlIGNvbXBp
bGluZyB0aGUgZHJpdmVyLgoKUmVhbGx5ID8gS2VybmVsIGhlYWRlcnMgKGluIG15IGNhc2UgOiBs
aW51eC1oZWFkZXJzLTIuNi4yNi0xLTY4NikgYXJlCm5vdCBzdWZmaWNpZW50ID8gV2hlbiBJJ3Zl
IGluc3RhbGxlZCBlbTI4eHggKHdpdGggdjRsLWR2Yi1leHBlcmltZW50YWwpCmEgZmV3IG1vbnRo
cyBhZ28sIGl0IHdhcyBvayBvbmx5IHdpdGggdGhlIGhlYWRlcnMuLi4KCk9LLiBJJ2xsIHRyeSB3
aXRoIHRoZSBjb21wbGV0ZSBzb3VyY2UgKGV2ZW4gaWYgSSBkb24ndCB1bmRlcnN0YW5kCndoeSA7
LSkpKQoKVGhhbmsgeW91IHZlcnkgbXVjaC4KCkRhdmlkLgoKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmxpbnV4LWR2YiBtYWlsaW5nIGxpc3QKbGludXgt
ZHZiQGxpbnV4dHYub3JnCmh0dHA6Ly93d3cubGludXh0di5vcmcvY2dpLWJpbi9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LWR2Yg==

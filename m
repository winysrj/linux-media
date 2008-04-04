Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.voila.fr ([193.252.22.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abdouniang@voila.fr>) id 1JhlMK-0001ZA-0K
	for linux-dvb@linuxtv.org; Fri, 04 Apr 2008 14:49:32 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf4013.voila.fr (SMTP Server) with ESMTP id 6339570000A0
	for <linux-dvb@linuxtv.org>; Fri,  4 Apr 2008 14:48:58 +0200 (CEST)
Received: from wwinf4620 (wwinf4620 [10.232.13.44])
	by mwinf4013.voila.fr (SMTP Server) with ESMTP id 60A6B700008B
	for <linux-dvb@linuxtv.org>; Fri,  4 Apr 2008 14:48:58 +0200 (CEST)
From: Abdou NIANG <abdouniang@voila.fr>
To: linux-dvb@linuxtv.org
Message-ID: <26772022.3060661207313338389.JavaMail.www@wwinf4620>
MIME-Version: 1.0
Date: Fri,  4 Apr 2008 14:48:58 +0200 (CEST)
Subject: Re: [linux-dvb] Can't record transport stream -
	Error:	cx8802_start_dma() Failed. Unsupported value in .mpeg
	(0x00000001) -- [FIXED]
Reply-To: abdouniang@voila.fr
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

SGkgTmljbwoKVGhhbmtzIGZvciB5b3VyIGFkdmljZSBpdCB3b3Jrcy4KCkkga25vdyB0aGlzIG9w
dGlvbiBvZiBkdmJzdHJlYW0gYnV0IHdoZW4gaSB0ZXN0IHRoZSBjb21tYW5kICJkdmJzdHJlYW0g
ODE5MiAtbyA+IHRlc3QudHMiIHdpdGggYW4gb2xkIGtlcm5lbCBFeGFtcGxlOiBNYW5kcml2YSAy
MDA2IG9yIDIwMDcgd2l0aCBrZXJuZWwgMi42LjEyIGl0IHdvcmtzIGkgZG9uJ3QgaGF2ZSB0byBw
cmVjaXNlIHRoZSBmcmVxdWVuY3kgZm9yIG15IG91dHB1dCBmaWxlIHdoZW4gdGhlIGZyZXF1ZW5j
eSBpcyBhbHJlYWR5IHR1bmVkIGZvciBleGFtcGxlIHdpdGgga2FmZmVpbmUuCgoKCj4gTWVzc2Fn
ZSBkdSAwMy8wNC8wOCDDoCAxMGgwNAo+IERlIDogIk5pY28gU2FiYmkiIDxOaWNvbGEuU2FiYmlA
cG9zdGUuaXQ+Cj4gQSA6IGxpbnV4LWR2YkBsaW51eHR2Lm9yZwo+IENvcGllIMOgIDogCj4gT2Jq
ZXQgOiBSZTogW2xpbnV4LWR2Yl0gQ2FuJ3QgcmVjb3JkIHRyYW5zcG9ydCBzdHJlYW0gLSBFcnJv
cjoJY3g4ODAyX3N0YXJ0X2RtYSgpIEZhaWxlZC4gVW5zdXBwb3J0ZWQgdmFsdWUgaW4gLm1wZWcg
KDB4MDAwMDAwMDEpCj4gCj4gT24gV2VkbmVzZGF5IDAyIEFwcmlsIDIwMDggMjI6MjM6MzEgQWJk
b3UgTklBTkcgd3JvdGU6Cj4gCj4gPiBCdXQgd2hlbiBpIHRyeSB0byByZWNvcmQgYW4gZW50aXJl
IFRyYW5zcG9ydCBTdHJlYW0gd2l0aCBkdmJzdHJlYW0KPiA+IGxpa2UgdGhpczoKPiA+Cj4gPiAk
IGR2YnN0cmVhbSA4MTkyIC1vID4gdGVzdC50cwo+ID4KPiA+IE15IG91dHB1dCBmaWxlICJ0ZXN0
LnRzIiBpcyBhbHdheXMgZW1wdHkuIFdoZW4gaSB0cnkgdG8gc2VlCj4gPiBrZXJuZWwncyBtZXNz
YWdlcyBpJ3ZlOgo+IAo+IAo+IGR2YnN0cmVhbSAgLWYgRlJFUSAtYncgQlcgICAtbyA4MTkyID4g
dGVzdC50cwo+IAo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCj4gbGludXgtZHZiIG1haWxpbmcgbGlzdAo+IGxpbnV4LWR2YkBsaW51eHR2Lm9yZwo+IGh0
dHA6Ly93d3cubGludXh0di5vcmcvY2dpLWJpbi9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWR2Ygo+
IAo+IAoKCkVsIEhhZGppIEFiZG91IE5JQU5HCjUgUnVlIFNhaW50IEphY3F1ZXMKNTcyNDAgTklM
VkFOR0UKMDMuODIuNTMuNjkuODUKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpsaW51eC1kdmIgbWFpbGluZyBsaXN0CmxpbnV4LWR2YkBsaW51eHR2Lm9y
ZwpodHRwOi8vd3d3LmxpbnV4dHYub3JnL2NnaS1iaW4vbWFpbG1hbi9saXN0aW5mby9saW51eC1k
dmI=

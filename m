Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:27592 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab0IMXF2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 19:05:28 -0400
Date: Mon, 13 Sep 2010 19:05:33 -0400
Subject: Re: Need info to understand TeVii S470 cx23885 MSI  problem
Message-ID: <xtc1ykdwlypbtxapi8bi37h6.1284419133430@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

VGhhbmtzLiAgSSdsbCB0cnkgdG8gbG9vayBhdCB0aGlzIGNsb3NlbHkgbGF0ZXIgaW4gdGhlIHdl
ZWsuCgpOb3RpY2UgdGhlIGJ5dGUgYXQgb2Zmc2V0IDB4YWMgb2YgdGhlIFBDSSBjb25maWcgc3Bh
Y2U6CjB4OTEgLT4gMTQ1CjB4OTkgLT4gMTUzCgpJIHRoaW5rIGl0IG1heSBiZSBzb21ldGhpbmcg
dG8gZG8gd2l0aCBQQ0kgYnVzIGVycm9ycyBhbmQgQUVSLiAgSSBoYXZlIHRvIGRvIG1vcmUgcmVz
ZWFyY2guICBJbiB0aGUgbWVhbnRpbWUgeW91IGNhbiB0cnkgYm9vdGluZyB5b3VyIGtlcm5lbCB3
aXRoIGNvbW1hbmRsaW5lIG9wdGlvbnMgdG86CgoxLiBUdXJuIG9mZiBNU0kgYW5kIGxvb2sgZm9y
IEFFUiBtZXNzYWdlcyB0byBiZSBsb2dnZWQKMi4gIFR1cm4gb2YgQUVSIGFuZCBzZWUgaWYgdGhl
IElSUSBwcm9ibGVtIGdvZXMgYXdheS4KMy4gRG9uJ3QgbGV0IFBDSSB1c2UgTU1DT05GSUcgYW5k
IHNlZSBpZiB0aGUgZXJyb3JzIGdvIGF3YXkuCgpSZWdhcmRzLApBbmR5CgoiSWdvciBNLiBMaXBs
aWFuaW4iIDxsaXBsaWFuaW5AbWUuYnk+IHdyb3RlOgoKPtCSINGB0L7QvtCx0YnQtdC90LjQuCDQ
vtGCIDEzINGB0LXQvdGC0Y/QsdGA0Y8gMjAxMCAyMzo0MToyMSDQsNCy0YLQvtGAIElnb3IgTS4g
TGlwbGlhbmluINC90LDQv9C40YHQsNC7Ogo+PiDQkiDRgdC+0L7QsdGJ0LXQvdC40Lgg0L7RgiAx
MyDRgdC10L3RgtGP0LHRgNGPIDIwMTAgMjM6Mzg6Mjgg0LDQstGC0L7RgCBJZ29yIE0uIExpcGxp
YW5pbiDQvdCw0L/QuNGB0LDQuzoKPj4gPiDQkiDRgdC+0L7QsdGJ0LXQvdC40Lgg0L7RgiAxMiDR
gdC10L3RgtGP0LHRgNGPIDIwMTAgMjI6NTY6NTcg0LDQstGC0L7RgCBBbmR5IFdhbGxzINC90LDQ
v9C40YHQsNC7Ogo+PiA+ID4gSWdvciwKPj4gPiA+IAo+PiA+ID4gVG8gaGVscCB1bmRlcnN0YW5k
IHRoZSBwcm9ibGVtIHdpdGggdGhlIFRlVmlpIFM0NzAgQ1gyMzg4NSBNU0kgbm90Cj4+ID4gPiB3
b3JraW5nIGFmdGVyIG1vZHVsZSB1bmxvYWQgYW5kIHJlbG9hZCwgY291bGQgeW91IHByb3ZpZGUg
dGhlIG91dHB1dCBvZgo+PiA+ID4gCj4+ID4gPiAJIyBsc3BjaSAtZCAxNGYxOiAteHh4eCAtdnZ2
dgo+PiA+ID4gCj4+ID4gPiBhcyByb290IGJlZm9yZSB0aGUgY3gyMzg4NSBtb2R1bGUgbG9hZHMs
IGFmdGVyIHRoZSBtb2R1bGUgbG9hZHMsIGFuZAo+PiA+ID4gYWZ0ZXIgdGhlIG1vZHVsZSBpcyBy
ZW1vdmVkIGFuZCByZWxvYWRlZD8KPj4gPiA+IAo+PiA+ID4gcGxlYXNlIGFsc28gcHJvdmlkZSB0
aGUgTVNJIElSUSBudW1iZXIgbGlzdGVkIGluIGRtZXNnCj4+ID4gPiAob3IgL3Zhci9sb2cvbWVz
c2FnZXMpIGFzc2lnbmVkIHRvIHRoZSBjYXJkLiAgQWxzbyB0aGUgSVJRIG51bWJlciBvZgo+PiA+
ID4gdGhlIHVuaGFuZGxlZCBJUlEgd2hlbiB0aGUgbW9kdWxlIGlzIHJlbG9hZGVkLgo+PiA+ID4g
Cj4+ID4gPiBUaGUgbGludXgga2VybmVsIHNob3VsZCBiZSB3cml0aW5nIHRoZSBNU0kgSVJRIHZl
Y3RvciBpbnRvIHRoZSBQQ0kKPj4gPiA+IGNvbmZpZ3VyYXRpb24gc3BhY2Ugb2YgdGhlIENYMjM4
ODUuICBJdCBsb29rcyBsaWtlIHdoZW4geW91IHVubG9hZCBhbmQKPj4gPiA+IHJlbG9hZCB0aGUg
Y3gyMzg4NSBtb2R1bGUsIGl0IGlzIG5vdCBjaGFuZ2luZyB0aGUgdmVjdG9yLgo+PiA+ID4gCj4+
ID4gPiBSZWdhcmRzLAo+PiA+ID4gQW5keQo+PiA+IAo+PiA+IEFuZHksCj4+ID4gRXJyb3IgYXBw
ZWFycyBvbmx5IGFuZCBpZiB5b3UgemFwIGFjdHVhbCBjaGFubmVsKGludGVycnVwdHMgYWN0dWFs
bHkKPj4gPiBjYWxscykuIEZpcnN0IHRpbWUgbW9kdWxlIGxvYWRlZCBhbmQgemFwcGVkIHNvbWUg
Y2hhbm5lbC4gQXQgdGhpcyBwb2ludAo+PiA+IHRoZXJlIGlzIG5vIGVycm9ycy4gL3Byb2MvaW50
ZXJydXB0cyBzaG93cyBzb21lIGlycSdzIGZvciBjeDIzODg1Lgo+PiA+IFRoZW4gcm1tb2QtaW5z
bW9kIGFuZCBzemFwIGFnYWluLiBWb2lsbGEhIE5vIGlycSB2ZWN0b3IuCj4+ID4gL3Byb2MvaW50
ZXJydXB0cyBzaG93cyB6ZXJvIGlycSBjYWxscyBmb3IgY3gyMzg4NS4KPj4gPiBJbiBteSBjYXNl
IERvX2lycSBjb21wbGFpbnMgYWJvdXQgaXJxIDE1MywgZG1lc3Egc2F5cyBjeDIzODg1IHVzZXMg
NDUuCj4+ID4gCj4+ID4gTXkgZmlyc3QgbG9vayBub3QgY2F0Y2ggYW55dGhpbmcgaW4gbHNwY2ku
Cj4+ID4gRm9yIG5vdyBJJ20gdXNpbmcgd29ya2Fyb3VuZCAtIGZpbmQgcmVnaXN0ZXIgYW5kIGJp
dCBpbiBjeDIzODg1IHRvIHdyaXRlCj4+ID4gdG8gZGlzYWJsZSBNU0kgcmVnaXN0ZXJzLiBJbiBj
b25qdW5jdGlvbiB3aXRoIHBhcnRpY3VsYXIgY2FyZCwKPj4gPiBuYXR1cmFsbHkuCj4+ID4gCj4+
ID4gUmVnYXJkcwo+PiA+IElnb3IKPj4gCj4+IEZvcmdldCB0byBtZW50aW9uLiBUaGUgdHJlZSBp
cyBtZWRpYV90cmVlLCBicmFuY2ggc3RhZ2luZy92Mi42LjM3Cj5Tb3JyeSwgSSB3YXMgaW5hdHRl
bnRpdmUuCj4KPmJhc2gtNC4xIyBsc3BjaSAtZCAxNGYxOiAteHh4eCAtdnZ2diAKPjAyOjAwLjAg
TXVsdGltZWRpYSB2aWRlbyBjb250cm9sbGVyOiBDb25leGFudCBTeXN0ZW1zLCBJbmMuIENYMjM4
ODUgUENJIFZpZGVvIGFuZCBBdWRpbyBEZWNvZGVyIAo+KHJldiAwMikKPiAgICAgICAgU3Vic3lz
dGVtOiBEZXZpY2UgZDQ3MDo5MDIyCj4gICAgICAgIENvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0
ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIt
IAo+RmFzdEIyQi0gRGlzSU5UeC0KPiAgICAgICAgU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZh
c3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNF
UlItIAo+PFBFUlItIElOVHgtCj4gICAgICAgIExhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTog
MzIgYnl0ZXMKPiAgICAgICAgSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDEwCj4gICAg
ICAgIFJlZ2lvbiAwOiBNZW1vcnkgYXQgZmVhMDAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJs
ZSkgW3NpemU9Mk1dCj4gICAgICAgIENhcGFiaWxpdGllczogWzQwXSBFeHByZXNzICh2MSkgRW5k
cG9pbnQsIE1TSSAwMAo+ICAgICAgICAgICAgICAgIERldkNhcDogTWF4UGF5bG9hZCAxMjggYnl0
ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1cwo+ICAgICAgICAgICAg
ICAgICAgICAgICAgRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRS0gRkxSZXNl
dC0KPiAgICAgICAgICAgICAgICBEZXZDdGw6IFJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBO
b24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KPiAgICAgICAgICAgICAgICAgICAgICAgIFJs
eGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3ArCj4gICAgICAgICAgICAg
ICAgICAgICAgICBNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMKPiAg
ICAgICAgICAgICAgICBEZXZTdGE6IENvcnJFcnItIFVuY29yckVycisgRmF0YWxFcnItIFVuc3Vw
cFJlcSsgQXV4UHdyLSBUcmFuc1BlbmQtCj4gICAgICAgICAgICAgICAgTG5rQ2FwOiBQb3J0ICMw
LCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExhdGVuY3kgTDAgPDJ1cywg
TDEgPDR1cwo+ICAgICAgICAgICAgICAgICAgICAgICAgQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0
UmVwLSBCd05vdC0KPiAgICAgICAgICAgICAgICBMbmtDdGw6IEFTUE0gRGlzYWJsZWQ7IFJDQiA2
NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsaysKPiAgICAgICAgICAgICAgICAgICAg
ICAgIEV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KPiAgICAg
ICAgICAgICAgICBMbmtTdGE6IFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4t
IFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCj4gICAgICAgIENhcGFiaWxpdGll
czogWzgwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgo+ICAgICAgICAgICAgICAgIEZsYWdz
OiBQTUVDbGstIERTSSsgRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNo
b3QrLEQzY29sZC0pCj4gICAgICAgICAgICAgICAgU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1F
bmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCj4gICAgICAgIENhcGFiaWxpdGllczogWzkwXSBW
aXRhbCBQcm9kdWN0IERhdGEKPiAgICAgICAgICAgICAgICBQcm9kdWN0IE5hbWU6ICIKPiAgICAg
ICAgICAgICAgICBFbmQKPiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbYTBdIE1TSTogRW5hYmxlLSBD
b3VudD0xLzEgTWFza2FibGUtIDY0Yml0Kwo+ICAgICAgICAgICAgICAgIEFkZHJlc3M6IDAwMDAw
MDAwMDAwMDAwMDAgIERhdGE6IDAwMDAKPiAgICAgICAgS2VybmVsIG1vZHVsZXM6IGN4MjM4ODUK
PjAwOiBmMSAxNCA1MiA4OCAwNiAwMCAxMCAwMCAwMiAwMCAwMCAwNCAwOCAwMCAwMCAwMAo+MTA6
IDA0IDAwIGEwIGZlIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj4yMDogMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgNzAgZDQgMjIgOTAKPjMwOiAwMCAwMCAw
MCAwMCA0MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwYSAwMSAwMCAwMAo+NDA6IDEwIDgwIDAxIDAw
IDAwIDAwIDI4IDAwIDEwIDI4IDBhIDAwIDExIDVjIDAxIDAwCj41MDogNDAgMDAgMTEgMTAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjYwOiAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+NzA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj44MDogMDEgOTAgMjIgN2UgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAKPjkwOiAwMyBhMCAwNCA4MCA3OCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMAo+YTA6IDA1IDAwIDgwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwCj5iMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAKPmMwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMAo+ZDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
Cj5lMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPmYw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+Cj5iYXNo
LTQuMSMgaW5zbW9kIGN4MjM4ODUua28KPmJhc2gtNC4xIyBsc3BjaSAtZCAxNGYxOiAteHh4eCAt
dnZ2diAKPjAyOjAwLjAgTXVsdGltZWRpYSB2aWRlbyBjb250cm9sbGVyOiBDb25leGFudCBTeXN0
ZW1zLCBJbmMuIENYMjM4ODUgUENJIFZpZGVvIGFuZCBBdWRpbyBEZWNvZGVyIAo+KHJldiAwMikK
PiAgICAgICAgU3Vic3lzdGVtOiBEZXZpY2UgZDQ3MDo5MDIyCj4gICAgICAgIENvbnRyb2w6IEkv
Ty0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0g
U3RlcHBpbmctIFNFUlItIAo+RmFzdEIyQi0gRGlzSU5UeCsKPiAgICAgICAgU3RhdHVzOiBDYXAr
IDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9y
dC0gPE1BYm9ydC0gPlNFUlItIAo+PFBFUlItIElOVHgtCj4gICAgICAgIExhdGVuY3k6IDAsIENh
Y2hlIExpbmUgU2l6ZTogMzIgYnl0ZXMKPiAgICAgICAgSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQg
dG8gSVJRIDQ1Cj4gICAgICAgIFJlZ2lvbiAwOiBNZW1vcnkgYXQgZmVhMDAwMDAgKDY0LWJpdCwg
bm9uLXByZWZldGNoYWJsZSkgW3NpemU9Mk1dCj4gICAgICAgIENhcGFiaWxpdGllczogWzQwXSBF
eHByZXNzICh2MSkgRW5kcG9pbnQsIE1TSSAwMAo+ICAgICAgICAgICAgICAgIERldkNhcDogTWF4
UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1
cwo+ICAgICAgICAgICAgICAgICAgICAgICAgRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJ
bmQtIFJCRS0gRkxSZXNldC0KPiAgICAgICAgICAgICAgICBEZXZDdGw6IFJlcG9ydCBlcnJvcnM6
IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KPiAgICAgICAgICAg
ICAgICAgICAgICAgIFJseGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3Ar
Cj4gICAgICAgICAgICAgICAgICAgICAgICBNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJl
cSA1MTIgYnl0ZXMKPiAgICAgICAgICAgICAgICBEZXZTdGE6IENvcnJFcnItIFVuY29yckVycisg
RmF0YWxFcnItIFVuc3VwcFJlcSsgQXV4UHdyLSBUcmFuc1BlbmQtCj4gICAgICAgICAgICAgICAg
TG5rQ2FwOiBQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExh
dGVuY3kgTDAgPDJ1cywgTDEgPDR1cwo+ICAgICAgICAgICAgICAgICAgICAgICAgQ2xvY2tQTS0g
U3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KPiAgICAgICAgICAgICAgICBMbmtDdGw6IEFTUE0g
RGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsaysKPiAgICAg
ICAgICAgICAgICAgICAgICAgIEV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBB
dXRCV0ludC0KPiAgICAgICAgICAgICAgICBMbmtTdGE6IFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgx
LCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCj4gICAg
ICAgIENhcGFiaWxpdGllczogWzgwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgo+ICAgICAg
ICAgICAgICAgIEZsYWdzOiBQTUVDbGstIERTSSsgRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQTUUo
RDArLEQxKyxEMissRDNob3QrLEQzY29sZC0pCj4gICAgICAgICAgICAgICAgU3RhdHVzOiBEMCBO
b1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCj4gICAgICAgIENhcGFi
aWxpdGllczogWzkwXSBWaXRhbCBQcm9kdWN0IERhdGEKPiAgICAgICAgICAgICAgICBQcm9kdWN0
IE5hbWU6ICIKPiAgICAgICAgICAgICAgICBFbmQKPiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbYTBd
IE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0Kwo+ICAgICAgICAgICAgICAg
IEFkZHJlc3M6IDAwMDAwMDAwZmVlMDMwMGMgIERhdGE6IDQxODkKPiAgICAgICAgS2VybmVsIGRy
aXZlciBpbiB1c2U6IGN4MjM4ODUKPiAgICAgICAgS2VybmVsIG1vZHVsZXM6IGN4MjM4ODUKPjAw
OiBmMSAxNCA1MiA4OCAwNiAwNCAxMCAwMCAwMiAwMCAwMCAwNCAwOCAwMCAwMCAwMAo+MTA6IDA0
IDAwIGEwIGZlIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj4yMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgNzAgZDQgMjIgOTAKPjMwOiAwMCAwMCAwMCAw
MCA0MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwYSAwMSAwMCAwMAo+NDA6IDEwIDgwIDAxIDAwIDAw
IDAwIDI4IDAwIDEwIDI4IDBhIDAwIDExIDVjIDAxIDAwCj41MDogNDAgMDAgMTEgMTAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjYwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+NzA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwCj44MDogMDEgOTAgMjIgN2UgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAKPjkwOiAwMyBhMCAwNCA4MCA3OCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAo+YTA6IDA1IDAwIDgxIDAwIDBjIDMwIGUwIGZlIDAwIDAwIDAwIDAwIDg5
IDQxIDAwIDAwCj5iMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKPmMwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo+ZDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj5l
MDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPmYwOiAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+Cj5iYXNoLTQu
MSMgcm1tb2QgY3gyMzg4NQo+YmFzaC00LjEjIGxzcGNpIC1kIDE0ZjE6IC14eHh4IC12dnZ2IAo+
MDI6MDAuMCBNdWx0aW1lZGlhIHZpZGVvIGNvbnRyb2xsZXI6IENvbmV4YW50IFN5c3RlbXMsIElu
Yy4gQ1gyMzg4NSBQQ0kgVmlkZW8gYW5kIEF1ZGlvIERlY29kZXIgCj4ocmV2IDAyKQo+ICAgICAg
ICBTdWJzeXN0ZW06IERldmljZSBkNDcwOjkwMjIKPiAgICAgICAgQ29udHJvbDogSS9PLSBNZW0r
IEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGlu
Zy0gU0VSUi0gCj5GYXN0QjJCLSBEaXNJTlR4LQo+ICAgICAgICBTdGF0dXM6IENhcCsgNjZNSHot
IFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFi
b3J0LSA+U0VSUi0gCj48UEVSUi0gSU5UeC0KPiAgICAgICAgSW50ZXJydXB0OiBwaW4gQSByb3V0
ZWQgdG8gSVJRIDE2Cj4gICAgICAgIFJlZ2lvbiAwOiBNZW1vcnkgYXQgZmVhMDAwMDAgKDY0LWJp
dCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9Mk1dCj4gICAgICAgIENhcGFiaWxpdGllczogWzQw
XSBFeHByZXNzICh2MSkgRW5kcG9pbnQsIE1TSSAwMAo+ICAgICAgICAgICAgICAgIERldkNhcDog
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEg
PDF1cwo+ICAgICAgICAgICAgICAgICAgICAgICAgRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQ
d3JJbmQtIFJCRS0gRkxSZXNldC0KPiAgICAgICAgICAgICAgICBEZXZDdGw6IFJlcG9ydCBlcnJv
cnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KPiAgICAgICAg
ICAgICAgICAgICAgICAgIFJseGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25v
b3ArCj4gICAgICAgICAgICAgICAgICAgICAgICBNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVh
ZFJlcSA1MTIgYnl0ZXMKPiAgICAgICAgICAgICAgICBEZXZTdGE6IENvcnJFcnItIFVuY29yckVy
cisgRmF0YWxFcnItIFVuc3VwcFJlcSsgQXV4UHdyLSBUcmFuc1BlbmQtCj4gICAgICAgICAgICAg
ICAgTG5rQ2FwOiBQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEs
IExhdGVuY3kgTDAgPDJ1cywgTDEgPDR1cwo+ICAgICAgICAgICAgICAgICAgICAgICAgQ2xvY2tQ
TS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KPiAgICAgICAgICAgICAgICBMbmtDdGw6IEFT
UE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsaysKPiAg
ICAgICAgICAgICAgICAgICAgICAgIEV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50
LSBBdXRCV0ludC0KPiAgICAgICAgICAgICAgICBMbmtTdGE6IFNwZWVkIDIuNUdUL3MsIFdpZHRo
IHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCj4g
ICAgICAgIENhcGFiaWxpdGllczogWzgwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgo+ICAg
ICAgICAgICAgICAgIEZsYWdzOiBQTUVDbGstIERTSSsgRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQ
TUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZC0pCj4gICAgICAgICAgICAgICAgU3RhdHVzOiBE
MCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCj4gICAgICAgIENh
cGFiaWxpdGllczogWzkwXSBWaXRhbCBQcm9kdWN0IERhdGEKPiAgICAgICAgICAgICAgICBQcm9k
dWN0IE5hbWU6ICIKPiAgICAgICAgICAgICAgICBFbmQKPiAgICAgICAgQ2FwYWJpbGl0aWVzOiBb
YTBdIE1TSTogRW5hYmxlLSBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0Kwo+ICAgICAgICAgICAg
ICAgIEFkZHJlc3M6IDAwMDAwMDAwZmVlMDMwMGMgIERhdGE6IDQxODkKPiAgICAgICAgS2VybmVs
IG1vZHVsZXM6IGN4MjM4ODUKPjAwOiBmMSAxNCA1MiA4OCAwMiAwMCAxMCAwMCAwMiAwMCAwMCAw
NCAwOCAwMCAwMCAwMAo+MTA6IDA0IDAwIGEwIGZlIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwCj4yMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgNzAgZDQg
MjIgOTAKPjMwOiAwMCAwMCAwMCAwMCA0MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwYSAwMSAwMCAw
MAo+NDA6IDEwIDgwIDAxIDAwIDAwIDAwIDI4IDAwIDEwIDI4IDBhIDAwIDExIDVjIDAxIDAwCj41
MDogNDAgMDAgMTEgMTAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjYwOiAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+NzA6IDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj44MDogMDEgOTAgMjIg
N2UgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjkwOiAwMyBhMCAwNCA4MCA3
OCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+YTA6IDA1IDAwIDgwIDAwIDBjIDMw
IGUwIGZlIDAwIDAwIDAwIDAwIDg5IDQxIDAwIDAwCj5iMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPmMwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+ZDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwCj5lMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAKPmYwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMAo+Cj5iYXNoLTQuMSMgaW5zbW9kIGN4MjM4ODUua28KPmJhc2gtNC4xIyBsc3Bj
aSAtZCAxNGYxOiAteHh4eCAtdnZ2diAKPjAyOjAwLjAgTXVsdGltZWRpYSB2aWRlbyBjb250cm9s
bGVyOiBDb25leGFudCBTeXN0ZW1zLCBJbmMuIENYMjM4ODUgUENJIFZpZGVvIGFuZCBBdWRpbyBE
ZWNvZGVyIAo+KHJldiAwMikKPiAgICAgICAgU3Vic3lzdGVtOiBEZXZpY2UgZDQ3MDo5MDIyCj4g
ICAgICAgIENvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIAo+RmFzdEIyQi0gRGlzSU5UeCsKPiAg
ICAgICAgU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZh
c3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIAo+PFBFUlItIElOVHgtCj4gICAg
ICAgIExhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogMzIgYnl0ZXMKPiAgICAgICAgSW50ZXJy
dXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDQ1Cj4gICAgICAgIFJlZ2lvbiAwOiBNZW1vcnkgYXQg
ZmVhMDAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9Mk1dCj4gICAgICAgIENh
cGFiaWxpdGllczogWzQwXSBFeHByZXNzICh2MSkgRW5kcG9pbnQsIE1TSSAwMAo+ICAgICAgICAg
ICAgICAgIERldkNhcDogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5
IEwwcyA8NjRucywgTDEgPDF1cwo+ICAgICAgICAgICAgICAgICAgICAgICAgRXh0VGFnLSBBdHRu
QnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRS0gRkxSZXNldC0KPiAgICAgICAgICAgICAgICBEZXZD
dGw6IFJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBv
cnRlZC0KPiAgICAgICAgICAgICAgICAgICAgICAgIFJseGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5j
LSBBdXhQd3ItIE5vU25vb3ArCj4gICAgICAgICAgICAgICAgICAgICAgICBNYXhQYXlsb2FkIDEy
OCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMKPiAgICAgICAgICAgICAgICBEZXZTdGE6IENv
cnJFcnItIFVuY29yckVycisgRmF0YWxFcnItIFVuc3VwcFJlcSsgQXV4UHdyLSBUcmFuc1BlbmQt
Cj4gICAgICAgICAgICAgICAgTG5rQ2FwOiBQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4
MSwgQVNQTSBMMHMgTDEsIExhdGVuY3kgTDAgPDJ1cywgTDEgPDR1cwo+ICAgICAgICAgICAgICAg
ICAgICAgICAgQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KPiAgICAgICAgICAg
ICAgICBMbmtDdGw6IEFTUE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFp
bi0gQ29tbUNsaysKPiAgICAgICAgICAgICAgICAgICAgICAgIEV4dFN5bmNoLSBDbG9ja1BNLSBB
dXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KPiAgICAgICAgICAgICAgICBMbmtTdGE6IFNwZWVk
IDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01n
bXQtIEFCV01nbXQtCj4gICAgICAgIENhcGFiaWxpdGllczogWzgwXSBQb3dlciBNYW5hZ2VtZW50
IHZlcnNpb24gMgo+ICAgICAgICAgICAgICAgIEZsYWdzOiBQTUVDbGstIERTSSsgRDErIEQyKyBB
dXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZC0pCj4gICAgICAgICAg
ICAgICAgU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQ
TUUtCj4gICAgICAgIENhcGFiaWxpdGllczogWzkwXSBWaXRhbCBQcm9kdWN0IERhdGEKPiAgICAg
ICAgICAgICAgICBQcm9kdWN0IE5hbWU6ICIKPiAgICAgICAgICAgICAgICBFbmQKPiAgICAgICAg
Q2FwYWJpbGl0aWVzOiBbYTBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0
Kwo+ICAgICAgICAgICAgICAgIEFkZHJlc3M6IDAwMDAwMDAwZmVlMDMwMGMgIERhdGE6IDQxOTEK
PiAgICAgICAgS2VybmVsIGRyaXZlciBpbiB1c2U6IGN4MjM4ODUKPiAgICAgICAgS2VybmVsIG1v
ZHVsZXM6IGN4MjM4ODUKPjAwOiBmMSAxNCA1MiA4OCAwNiAwNCAxMCAwMCAwMiAwMCAwMCAwNCAw
OCAwMCAwMCAwMAo+MTA6IDA0IDAwIGEwIGZlIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwCj4yMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgNzAgZDQgMjIg
OTAKPjMwOiAwMCAwMCAwMCAwMCA0MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwYSAwMSAwMCAwMAo+
NDA6IDEwIDgwIDAxIDAwIDAwIDAwIDI4IDAwIDEwIDI4IDBhIDAwIDExIDVjIDAxIDAwCj41MDog
NDAgMDAgMTEgMTAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjYwOiAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+NzA6IDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj44MDogMDEgOTAgMjIgN2Ug
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjkwOiAwMyBhMCAwNCA4MCA3OCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+YTA6IDA1IDAwIDgxIDAwIDBjIDMwIGUw
IGZlIDAwIDAwIDAwIDAwIDkxIDQxIDAwIDAwCj5iMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPmMwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMAo+ZDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwCj5lMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAKPmYwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMAo+Cj5iYXNoLTQuMSMgc3phcCAtbDEwNzUwIGJyaWRnZS10diAteAo+cmVhZGluZyBj
aGFubmVscyBmcm9tIGZpbGUgJy9yb290Ly5zemFwL2NoYW5uZWxzLmNvbmYnCj56YXBwaW5nIHRv
IDYgJ2JyaWRnZS10dic6Cj5zYXQgMSwgZnJlcXVlbmN5ID0gMTIzMDMgTUh6IEgsIHN5bWJvbHJh
dGUgMjc1MDAwMDAsIHZwaWQgPSAweDAxMzQsIGFwaWQgPSAweDAxMDAgc2lkID0gMHgwMDNiCj51
c2luZyAnL2Rldi9kdmIvYWRhcHRlcjAvZnJvbnRlbmQwJyBhbmQgJy9kZXYvZHZiL2FkYXB0ZXIw
L2RlbXV4MCcKPnN0YXR1cyAxZiB8IHNpZ25hbCBmZGU4IHwgc25yIGUxMjggfCBiZXIgMDAwMDAw
MDAgfCB1bmMgMDAwMDAwMGIgfCBGRV9IQVNfTE9DSwo+YmFzaC00LjEjIGxzcGNpIC1kIDE0ZjE6
IC14eHh4IC12dnZ2IAo+MDI6MDAuMCBNdWx0aW1lZGlhIHZpZGVvIGNvbnRyb2xsZXI6IENvbmV4
YW50IFN5c3RlbXMsIEluYy4gQ1gyMzg4NSBQQ0kgVmlkZW8gYW5kIEF1ZGlvIERlY29kZXIgCj4o
cmV2IDAyKQo+ICAgICAgICBTdWJzeXN0ZW06IERldmljZSBkNDcwOjkwMjIKPiAgICAgICAgQ29u
dHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0g
UGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gCj5GYXN0QjJCLSBEaXNJTlR4Kwo+ICAgICAgICBTdGF0
dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0
LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gCj48UEVSUi0gSU5UeC0KPiAgICAgICAgTGF0ZW5j
eTogMCwgQ2FjaGUgTGluZSBTaXplOiAzMiBieXRlcwo+ICAgICAgICBJbnRlcnJ1cHQ6IHBpbiBB
IHJvdXRlZCB0byBJUlEgNDUKPiAgICAgICAgUmVnaW9uIDA6IE1lbW9yeSBhdCBmZWEwMDAwMCAo
NjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0yTV0KPiAgICAgICAgQ2FwYWJpbGl0aWVz
OiBbNDBdIEV4cHJlc3MgKHYxKSBFbmRwb2ludCwgTVNJIDAwCj4gICAgICAgICAgICAgICAgRGV2
Q2FwOiBNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExhdGVuY3kgTDBzIDw2NG5z
LCBMMSA8MXVzCj4gICAgICAgICAgICAgICAgICAgICAgICBFeHRUYWctIEF0dG5CdG4tIEF0dG5J
bmQtIFB3ckluZC0gUkJFLSBGTFJlc2V0LQo+ICAgICAgICAgICAgICAgIERldkN0bDogUmVwb3J0
IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9ydGVkLQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgUmx4ZE9yZCsgRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0g
Tm9Tbm9vcCsKPiAgICAgICAgICAgICAgICAgICAgICAgIE1heFBheWxvYWQgMTI4IGJ5dGVzLCBN
YXhSZWFkUmVxIDUxMiBieXRlcwo+ICAgICAgICAgICAgICAgIERldlN0YTogQ29yckVyci0gVW5j
b3JyRXJyKyBGYXRhbEVyci0gVW5zdXBwUmVxKyBBdXhQd3ItIFRyYW5zUGVuZC0KPiAgICAgICAg
ICAgICAgICBMbmtDYXA6IFBvcnQgIzAsIFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBBU1BNIEww
cyBMMSwgTGF0ZW5jeSBMMCA8MnVzLCBMMSA8NHVzCj4gICAgICAgICAgICAgICAgICAgICAgICBD
bG9ja1BNLSBTdXJwcmlzZS0gTExBY3RSZXAtIEJ3Tm90LQo+ICAgICAgICAgICAgICAgIExua0N0
bDogQVNQTSBEaXNhYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBSZXRyYWluLSBDb21tQ2xr
Kwo+ICAgICAgICAgICAgICAgICAgICAgICAgRXh0U3luY2gtIENsb2NrUE0tIEF1dFdpZERpcy0g
QldJbnQtIEF1dEJXSW50LQo+ICAgICAgICAgICAgICAgIExua1N0YTogU3BlZWQgMi41R1Qvcywg
V2lkdGggeDEsIFRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUtIEJXTWdtdC0gQUJXTWdt
dC0KPiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbODBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAy
Cj4gICAgICAgICAgICAgICAgRmxhZ3M6IFBNRUNsay0gRFNJKyBEMSsgRDIrIEF1eEN1cnJlbnQ9
MG1BIFBNRShEMCssRDErLEQyKyxEM2hvdCssRDNjb2xkLSkKPiAgICAgICAgICAgICAgICBTdGF0
dXM6IEQwIE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KPiAgICAg
ICAgQ2FwYWJpbGl0aWVzOiBbOTBdIFZpdGFsIFByb2R1Y3QgRGF0YQo+ICAgICAgICAgICAgICAg
IFByb2R1Y3QgTmFtZTogIgo+ICAgICAgICAgICAgICAgIEVuZAo+ICAgICAgICBDYXBhYmlsaXRp
ZXM6IFthMF0gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCj4gICAgICAg
ICAgICAgICAgQWRkcmVzczogMDAwMDAwMDBmZWUwMzAwYyAgRGF0YTogNDE5MQo+ICAgICAgICBL
ZXJuZWwgZHJpdmVyIGluIHVzZTogY3gyMzg4NQo+ICAgICAgICBLZXJuZWwgbW9kdWxlczogY3gy
Mzg4NQo+MDA6IGYxIDE0IDUyIDg4IDA2IDA0IDEwIDAwIDAyIDAwIDAwIDA0IDA4IDAwIDAwIDAw
Cj4xMDogMDQgMDAgYTAgZmUgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjIw
OiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCA3MCBkNCAyMiA5MAo+MzA6IDAw
IDAwIDAwIDAwIDQwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDBhIDAxIDAwIDAwCj40MDogMTAgODAg
MDEgMDAgMDAgMDAgMjggMDAgMTAgMjggMGEgMDAgMTEgNWMgMDEgMDAKPjUwOiA0MCAwMCAxMSAx
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+NjA6IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj43MDogMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjgwOiAwMSA5MCAyMiA3ZSAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+OTA6IDAzIGEwIDA0IDgwIDc4IDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwCj5hMDogMDUgMDAgODEgMDAgMGMgMzAgZTAgZmUgMDAgMDAg
MDAgMDAgOTEgNDEgMDAgMDAKPmIwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAo+YzA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwCj5kMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKPmUwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo+ZjA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj4K
PmJhc2gtNC4xIyBybW1vZCBjeDIzODg1Cj5iYXNoLTQuMSMgaW5zbW9kIGN4MjM4ODUua28KPmJh
c2gtNC4xIyBsc3BjaSAtZCAxNGYxOiAteHh4eCAtdnZ2diAKPjAyOjAwLjAgTXVsdGltZWRpYSB2
aWRlbyBjb250cm9sbGVyOiBDb25leGFudCBTeXN0ZW1zLCBJbmMuIENYMjM4ODUgUENJIFZpZGVv
IGFuZCBBdWRpbyBEZWNvZGVyIAo+KHJldiAwMikKPiAgICAgICAgU3Vic3lzdGVtOiBEZXZpY2Ug
ZDQ3MDo5MDIyCj4gICAgICAgIENvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNs
ZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIAo+RmFzdEIyQi0g
RGlzSU5UeCsKPiAgICAgICAgU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVy
ci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIAo+PFBFUlIt
IElOVHgtCj4gICAgICAgIExhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTogMzIgYnl0ZXMKPiAg
ICAgICAgSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDQ1Cj4gICAgICAgIFJlZ2lvbiAw
OiBNZW1vcnkgYXQgZmVhMDAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9Mk1d
Cj4gICAgICAgIENhcGFiaWxpdGllczogWzQwXSBFeHByZXNzICh2MSkgRW5kcG9pbnQsIE1TSSAw
MAo+ICAgICAgICAgICAgICAgIERldkNhcDogTWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVu
YyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1cwo+ICAgICAgICAgICAgICAgICAgICAgICAg
RXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJbmQtIFJCRS0gRkxSZXNldC0KPiAgICAgICAg
ICAgICAgICBEZXZDdGw6IFJlcG9ydCBlcnJvcnM6IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZh
dGFsLSBVbnN1cHBvcnRlZC0KPiAgICAgICAgICAgICAgICAgICAgICAgIFJseGRPcmQrIEV4dFRh
Zy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3ArCj4gICAgICAgICAgICAgICAgICAgICAgICBN
YXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIgYnl0ZXMKPiAgICAgICAgICAgICAg
ICBEZXZTdGE6IENvcnJFcnItIFVuY29yckVycisgRmF0YWxFcnItIFVuc3VwcFJlcSsgQXV4UHdy
LSBUcmFuc1BlbmQtCj4gICAgICAgICAgICAgICAgTG5rQ2FwOiBQb3J0ICMwLCBTcGVlZCAyLjVH
VC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExhdGVuY3kgTDAgPDJ1cywgTDEgPDR1cwo+ICAg
ICAgICAgICAgICAgICAgICAgICAgQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0K
PiAgICAgICAgICAgICAgICBMbmtDdGw6IEFTUE0gRGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNh
YmxlZC0gUmV0cmFpbi0gQ29tbUNsaysKPiAgICAgICAgICAgICAgICAgICAgICAgIEV4dFN5bmNo
LSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KPiAgICAgICAgICAgICAgICBM
bmtTdGE6IFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERM
QWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCj4gICAgICAgIENhcGFiaWxpdGllczogWzgwXSBQb3dl
ciBNYW5hZ2VtZW50IHZlcnNpb24gMgo+ICAgICAgICAgICAgICAgIEZsYWdzOiBQTUVDbGstIERT
SSsgRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZC0p
Cj4gICAgICAgICAgICAgICAgU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9
MCBEU2NhbGU9MCBQTUUtCj4gICAgICAgIENhcGFiaWxpdGllczogWzkwXSBWaXRhbCBQcm9kdWN0
IERhdGEKPiAgICAgICAgICAgICAgICBQcm9kdWN0IE5hbWU6ICIKPiAgICAgICAgICAgICAgICBF
bmQKPiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbYTBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFz
a2FibGUtIDY0Yml0Kwo+ICAgICAgICAgICAgICAgIEFkZHJlc3M6IDAwMDAwMDAwZmVlMDMwMGMg
IERhdGE6IDQxOTkKPiAgICAgICAgS2VybmVsIGRyaXZlciBpbiB1c2U6IGN4MjM4ODUKPiAgICAg
ICAgS2VybmVsIG1vZHVsZXM6IGN4MjM4ODUKPjAwOiBmMSAxNCA1MiA4OCAwNiAwNCAxMCAwMCAw
MiAwMCAwMCAwNCAwOCAwMCAwMCAwMAo+MTA6IDA0IDAwIGEwIGZlIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwCj4yMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgNzAgZDQgMjIgOTAKPjMwOiAwMCAwMCAwMCAwMCA0MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
YSAwMSAwMCAwMAo+NDA6IDEwIDgwIDAxIDAwIDAwIDAwIDI4IDAwIDEwIDI4IDBhIDAwIDExIDVj
IDAxIDAwCj41MDogNDAgMDAgMTEgMTAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAKPjYwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+
NzA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj44MDog
MDEgOTAgMjIgN2UgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjkwOiAwMyBh
MCAwNCA4MCA3OCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+YTA6IDA1IDAwIDgx
IDAwIDBjIDMwIGUwIGZlIDAwIDAwIDAwIDAwIDk5IDQxIDAwIDAwCj5iMDogMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPmMwOiAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+ZDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj5lMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPmYwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMAo+Cj5iYXNoLTQuMSMgc3phcCAtbDEwNzUwIGJyaWRnZS10diAt
eAo+cmVhZGluZyBjaGFubmVscyBmcm9tIGZpbGUgJy9yb290Ly5zemFwL2NoYW5uZWxzLmNvbmYn
Cj56YXBwaW5nIHRvIDYgJ2JyaWRnZS10dic6Cj5zYXQgMSwgZnJlcXVlbmN5ID0gMTIzMDMgTUh6
IEgsIHN5bWJvbHJhdGUgMjc1MDAwMDAsIHZwaWQgPSAweDAxMzQsIGFwaWQgPSAweDAxMDAgc2lk
ID0gMHgwMDNiCj51c2luZyAnL2Rldi9kdmIvYWRhcHRlcjAvZnJvbnRlbmQwJyBhbmQgJy9kZXYv
ZHZiL2FkYXB0ZXIwL2RlbXV4MCcKPnN0YXR1cyAwMCB8IHNpZ25hbCBmNjE4IHwgc25yIGUxMjgg
fCBiZXIgMDAwMDAwMDAgfCB1bmMgMDAwMDAwMGIgfCAKPgo+TWVzc2FnZSBmcm9tIHN5c2xvZ2RA
bG9jYWxob3N0IGF0IFR1ZSBTZXAgMTQgMDE6MDA6NTAgMjAxMCAuLi4KPmxvY2FsaG9zdCBrZXJu
ZWw6IGRvX0lSUTogMC4xNDUgTm8gaXJxIGhhbmRsZXIgZm9yIHZlY3RvciAoaXJxIC0xKQo+c3Rh
dHVzIDAwIHwgc2lnbmFsIGY2MTggfCBzbnIgZTEyOCB8IGJlciAwMDAwMDAwMCB8IHVuYyAwMDAw
MDAwMCB8IAo+c3RhdHVzIDAwIHwgc2lnbmFsIGY2MTggfCBzbnIgZTEyOCB8IGJlciAwMDAwMDAw
MCB8IHVuYyAwMDAwMDAwMCB8IAo+XkMKPmJhc2gtNC4xIyBsc3BjaSAtZCAxNGYxOiAteHh4eCAt
dnZ2diAKPjAyOjAwLjAgTXVsdGltZWRpYSB2aWRlbyBjb250cm9sbGVyOiBDb25leGFudCBTeXN0
ZW1zLCBJbmMuIENYMjM4ODUgUENJIFZpZGVvIGFuZCBBdWRpbyBEZWNvZGVyIAo+KHJldiAwMikK
PiAgICAgICAgU3Vic3lzdGVtOiBEZXZpY2UgZDQ3MDo5MDIyCj4gICAgICAgIENvbnRyb2w6IEkv
Ty0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0g
U3RlcHBpbmctIFNFUlItIAo+RmFzdEIyQi0gRGlzSU5UeCsKPiAgICAgICAgU3RhdHVzOiBDYXAr
IDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9y
dC0gPE1BYm9ydC0gPlNFUlItIAo+PFBFUlItIElOVHgtCj4gICAgICAgIExhdGVuY3k6IDAsIENh
Y2hlIExpbmUgU2l6ZTogMzIgYnl0ZXMKPiAgICAgICAgSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQg
dG8gSVJRIDQ1Cj4gICAgICAgIFJlZ2lvbiAwOiBNZW1vcnkgYXQgZmVhMDAwMDAgKDY0LWJpdCwg
bm9uLXByZWZldGNoYWJsZSkgW3NpemU9Mk1dCj4gICAgICAgIENhcGFiaWxpdGllczogWzQwXSBF
eHByZXNzICh2MSkgRW5kcG9pbnQsIE1TSSAwMAo+ICAgICAgICAgICAgICAgIERldkNhcDogTWF4
UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1
cwo+ICAgICAgICAgICAgICAgICAgICAgICAgRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5kLSBQd3JJ
bmQtIFJCRS0gRkxSZXNldC0KPiAgICAgICAgICAgICAgICBEZXZDdGw6IFJlcG9ydCBlcnJvcnM6
IENvcnJlY3RhYmxlLSBOb24tRmF0YWwtIEZhdGFsLSBVbnN1cHBvcnRlZC0KPiAgICAgICAgICAg
ICAgICAgICAgICAgIFJseGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25vb3Ar
Cj4gICAgICAgICAgICAgICAgICAgICAgICBNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJl
cSA1MTIgYnl0ZXMKPiAgICAgICAgICAgICAgICBEZXZTdGE6IENvcnJFcnItIFVuY29yckVycisg
RmF0YWxFcnItIFVuc3VwcFJlcSsgQXV4UHdyLSBUcmFuc1BlbmQtCj4gICAgICAgICAgICAgICAg
TG5rQ2FwOiBQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIExh
dGVuY3kgTDAgPDJ1cywgTDEgPDR1cwo+ICAgICAgICAgICAgICAgICAgICAgICAgQ2xvY2tQTS0g
U3VycHJpc2UtIExMQWN0UmVwLSBCd05vdC0KPiAgICAgICAgICAgICAgICBMbmtDdGw6IEFTUE0g
RGlzYWJsZWQ7IFJDQiA2NCBieXRlcyBEaXNhYmxlZC0gUmV0cmFpbi0gQ29tbUNsaysKPiAgICAg
ICAgICAgICAgICAgICAgICAgIEV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBB
dXRCV0ludC0KPiAgICAgICAgICAgICAgICBMbmtTdGE6IFNwZWVkIDIuNUdUL3MsIFdpZHRoIHgx
LCBUckVyci0gVHJhaW4tIFNsb3RDbGsrIERMQWN0aXZlLSBCV01nbXQtIEFCV01nbXQtCj4gICAg
ICAgIENhcGFiaWxpdGllczogWzgwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgo+ICAgICAg
ICAgICAgICAgIEZsYWdzOiBQTUVDbGstIERTSSsgRDErIEQyKyBBdXhDdXJyZW50PTBtQSBQTUUo
RDArLEQxKyxEMissRDNob3QrLEQzY29sZC0pCj4gICAgICAgICAgICAgICAgU3RhdHVzOiBEMCBO
b1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCj4gICAgICAgIENhcGFi
aWxpdGllczogWzkwXSBWaXRhbCBQcm9kdWN0IERhdGEKPiAgICAgICAgICAgICAgICBQcm9kdWN0
IE5hbWU6ICIKPiAgICAgICAgICAgICAgICBFbmQKPiAgICAgICAgQ2FwYWJpbGl0aWVzOiBbYTBd
IE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0Kwo+ICAgICAgICAgICAgICAg
IEFkZHJlc3M6IDAwMDAwMDAwZmVlMDMwMGMgIERhdGE6IDQxOTkKPiAgICAgICAgS2VybmVsIGRy
aXZlciBpbiB1c2U6IGN4MjM4ODUKPiAgICAgICAgS2VybmVsIG1vZHVsZXM6IGN4MjM4ODUKPjAw
OiBmMSAxNCA1MiA4OCAwNiAwNCAxMCAwMCAwMiAwMCAwMCAwNCAwOCAwMCAwMCAwMAo+MTA6IDA0
IDAwIGEwIGZlIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj4yMDogMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgNzAgZDQgMjIgOTAKPjMwOiAwMCAwMCAwMCAw
MCA0MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwYSAwMSAwMCAwMAo+NDA6IDEwIDgwIDAxIDAwIDAw
IDAwIDI4IDAwIDEwIDI4IDBhIDAwIDExIDVjIDAxIDAwCj41MDogNDAgMDAgMTEgMTAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPjYwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+NzA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwCj44MDogMDEgOTAgMjIgN2UgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAKPjkwOiAwMyBhMCAwNCA4MCA3OCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMAo+YTA6IDA1IDAwIDgxIDAwIDBjIDMwIGUwIGZlIDAwIDAwIDAwIDAwIDk5
IDQxIDAwIDAwCj5iMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAKPmMwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MAo+ZDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCj5l
MDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKPmYwOiAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAo+Cj5iYXNoLTQu
MSMgCj4KPi0tIAo+SWdvciBNLiBMaXBsaWFuaW4KPk1pY3Jvc29mdCBXaW5kb3dzIEZyZWUgWm9u
ZSAtIExpbnV4IHVzZWQgZm9yIGFsbCBDb21wdXRpbmcgVGFza3MKPi0tCj5UbyB1bnN1YnNjcmli
ZSBmcm9tIHRoaXMgbGlzdDogc2VuZCB0aGUgbGluZSAidW5zdWJzY3JpYmUgbGludXgtbWVkaWEi
IGluCj50aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZwo+
TW9yZSBtYWpvcmRvbW8gaW5mbyBhdCAgaHR0cDovL3ZnZXIua2VybmVsLm9yZy9tYWpvcmRvbW8t
aW5mby5odG1sCg==


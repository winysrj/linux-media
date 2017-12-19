Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:45307 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762483AbdLSLyF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:54:05 -0500
From: <Wenyou.Yang@microchip.com>
To: <sakari.ailus@iki.fi>
CC: <mchehab@s-opensource.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>, <devicetree@vger.kernel.org>,
        <corbet@lwn.net>, <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>
Subject: RE: [PATCH v9 2/2] media: i2c: Add the ov7740 image sensor driver
Date: Tue, 19 Dec 2017 11:54:03 +0000
Message-ID: <F9F4555C4E01D7469D37975B62D0EFBB8DE616@CHN-SV-EXMX07.mchp-main.com>
References: <20171211013146.2497-1-wenyou.yang@microchip.com>
 <20171211013146.2497-3-wenyou.yang@microchip.com>
 <20171219092246.3usg5mdyi27ivqlq@valkosipuli.retiisi.org.uk>
In-Reply-To: <20171219092246.3usg5mdyi27ivqlq@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU2FrYXJpLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNha2Fy
aSBBaWx1cyBbbWFpbHRvOnNha2FyaS5haWx1c0Bpa2kuZmldDQo+IFNlbnQ6IDIwMTfE6jEy1MIx
OcjVIDE3OjIzDQo+IFRvOiBXZW55b3UgWWFuZyAtIEE0MTUzNSA8V2VueW91LllhbmdAbWljcm9j
aGlwLmNvbT4NCj4gQ2M6IE1hdXJvIENhcnZhbGhvIENoZWhhYiA8bWNoZWhhYkBzLW9wZW5zb3Vy
Y2UuY29tPjsgUm9iIEhlcnJpbmcNCj4gPHJvYmgrZHRAa2VybmVsLm9yZz47IE1hcmsgUnV0bGFu
ZCA8bWFyay5ydXRsYW5kQGFybS5jb20+OyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9y
ZzsgTmljb2xhcyBGZXJyZSAtIE00MzIzOCA8Tmljb2xhcy5GZXJyZUBtaWNyb2NoaXAuY29tPjsN
Cj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IEpvbmF0aGFuIENvcmJldCA8Y29yYmV0QGx3
bi5uZXQ+OyBIYW5zIFZlcmt1aWwNCj4gPGh2ZXJrdWlsQHhzNGFsbC5ubD47IGxpbnV4LWFybS1r
ZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgTGludXggTWVkaWEgTWFpbGluZyBMaXN0DQo+IDxs
aW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc+OyBTb25nanVuIFd1IDxzb25nanVuLnd1QG1pY3Jv
Y2hpcC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjkgMi8yXSBtZWRpYTogaTJjOiBBZGQg
dGhlIG92Nzc0MCBpbWFnZSBzZW5zb3IgZHJpdmVyDQo+IA0KPiBPbiBNb24sIERlYyAxMSwgMjAx
NyBhdCAwOTozMTo0NkFNICswODAwLCBXZW55b3UgWWFuZyB3cm90ZToNCj4gPiBUaGUgb3Y3NzQw
IChjb2xvcikgaW1hZ2Ugc2Vuc29yIGlzIGEgaGlnaCBwZXJmb3JtYW5jZSBWR0EgQ01PUyBpbWFn
ZQ0KPiA+IHNuZXNvciwgd2hpY2ggc3VwcG9ydHMgZm9yIG91dHB1dCBmb3JtYXRzOiBSQVcgUkdC
IGFuZCBZVVYgYW5kIGltYWdlDQo+ID4gc2l6ZXM6IFZHQSwgYW5kIFFWR0EsIENJRiBhbmQgYW55
IHNpemUgc21hbGxlci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNvbmdqdW4gV3UgPHNvbmdq
dW4ud3VAbWljcm9jaGlwLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZW55b3UgWWFuZyA8d2Vu
eW91LnlhbmdAbWljcm9jaGlwLmNvbT4NCj4gDQo+IEFwcGxpZWQgd2l0aCB0aGlzIGRpZmY6DQoN
ClRoYW5rIHlvdSB2ZXJ5IG11Y2guDQoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlh
L2kyYy9vdjc3NDAuYyBiL2RyaXZlcnMvbWVkaWEvaTJjL292Nzc0MC5jIGluZGV4DQo+IDAzMDhi
YTQzN2JiYi4uMDQxYTc3MDM5ZDcwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL21lZGlhL2kyYy9v
djc3NDAuYw0KPiArKysgYi9kcml2ZXJzL21lZGlhL2kyYy9vdjc3NDAuYw0KPiBAQCAtMSw1ICsx
LDcgQEANCj4gLS8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+IC0vLyBDb3B5
cmlnaHQgKGMpIDIwMTcgTWljcm9jaGlwIENvcnBvcmF0aW9uLg0KPiArLyoNCj4gKyAqIFNQRFgt
TGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ICsgKiBDb3B5cmlnaHQgKGMpIDIwMTcgTWlj
cm9jaGlwIENvcnBvcmF0aW9uLg0KPiArICovDQo+IA0KPiAgI2luY2x1ZGUgPGxpbnV4L2Nsay5o
Pg0KPiAgI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+DQo+IA0KPiAtLQ0KPiBTYWthcmkgQWlsdXMN
Cj4gZS1tYWlsOiBzYWthcmkuYWlsdXNAaWtpLmZpDQoNCg0KQmVzdCBSZWdhcmRzLA0KV2VueW91
IFlhbmcNCg==

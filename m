Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:43817 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbdLKQJ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:09:26 -0500
From: Bart Van Assche <Bart.VanAssche@wdc.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "balbi@kernel.org" <balbi@kernel.org>
CC: "romain.izard.pro@gmail.com" <romain.izard.pro@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "ruslan.bilovol@gmail.com" <ruslan.bilovol@gmail.com>,
        "hare@suse.com" <hare@suse.com>,
        "cascardo@cascardo.eti.br" <cascardo@cascardo.eti.br>
Subject: Re: [PATCH 1/2] usb: gadget: restore tristate-choice for legacy
 gadgets
Date: Mon, 11 Dec 2017 16:09:20 +0000
Message-ID: <1513008559.2747.0.camel@wdc.com>
References: <20171211113048.3514863-1-arnd@arndb.de>
In-Reply-To: <20171211113048.3514863-1-arnd@arndb.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <E55CEA706D229D47A6314617C0AB99C9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

T24gTW9uLCAyMDE3LTEyLTExIGF0IDEyOjMwICswMTAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBPbmUgcGF0Y2ggdGhhdCB3YXMgbWVhbnQgYXMgYSBjbGVhbnVwIGFwcGFyZW50bHkgZGlkIG1v
cmUgdGhhbiBpdCBpbnRlbmRlZCwNCj4gYWxsb3dpbmcgYWxsIGNvbWJpbmF0aW9ucyBvZiBsZWdh
Y3kgZ2FkZ2V0IGRyaXZlcnMgdG8gYmUgYnVpbHQgaW50byB0aGUNCj4ga2VybmVsLCBhbmQgbGVh
dmluZyBhbiBlbXB0eSAnY2hvaWNlJyBzdGF0ZW1lbnQgYmVoaW5kOg0KPiANCj4gZHJpdmVycy91
c2IvZ2FkZ2V0L0tjb25maWc6NDg3Ondhcm5pbmc6IGNob2ljZSBkZWZhdWx0IHN5bWJvbCAnVVNC
X0VUSCcgaXMgbm90IGNvbnRhaW5lZCBpbiB0aGUgY2hvaWNlDQo+IA0KPiBUaGUgZGVzY3JpcHRp
b24gb2YgY29tbWl0IDdhOTYxOGEyMmFhZCAoInVzYjogZ2FkZ2V0OiBhbGxvdyB0byBlbmFibGUg
bGVnYWN5DQo+IGRyaXZlcnMgd2l0aG91dCBVU0JfRVRIIikgd2FzIGEgYml0IGNyeXB0aWMsIGFz
IGl0IGRpZCBub3QgY2hhbmdlIHRoZQ0KPiBiZWhhdmlvciBvZiBVU0JfRVRIIG90aGVyIHRoYW4g
YWxsb3dpbmcgaXQgdG8gYmUgYnVpbHQgaW50byB0aGUga2VybmVsDQo+IGFsb25nc2lkZSBvdGhl
ciBsZWdhY3kgZ2FkZ2V0cywgd2hpY2ggaXMgbm90IGEgdmFsaWQgY29uZmlndXJhdGlvbi4NCj4g
DQo+IEFzIEZlbGlwZSBleHBsYWluZWQgaW4gdGhlIGRlc2NyaXB0aW9uIGZvciBjb21taXQgYmM0
OWQxZDE3ZGNmICgidXNiOg0KPiBnYWRnZXQ6IGRvbid0IGNvdXBsZSBjb25maWdmcyB0byBsZWdh
Y3kgZ2FkZ2V0cyIpLCB0aGUgY29uZmlnZnMgYmFzZWQNCj4gZ2FkZ2V0cyBjYW4gYmUgZnJlZWx5
IGNvbmZpZ3VyZWQgYXMgbG9hZGFibGUgbW9kdWxlcyBvciBidWlsdC1pbg0KPiBkcml2ZXJzLCBi
dXQgdGhlIGxlZ2FjeSBnYWRnZXRzIGNhbiBvbmx5IGJlIG1vZHVsZXMgaWYgdGhlcmUgaXMgbW9y
ZQ0KPiB0aGFuIG9uZSBvZiB0aGVtLCBzbyB3ZSByZXF1aXJlIHRoZSAnY2hvaWNlJyBzdGF0ZW1l
bnQgaGVyZS4NCj4gDQo+IFRoaXMgbGVhdmVzIHRoZSBhZGRlZCBVU0JfR0FER0VUX0xFR0FDWSBt
ZW51Y29uZmlnIHN5bWJvbCBpbiBwbGFjZSwNCj4gYnV0IHRoZW4gcmVzdG9yZXMgdGhlICdjaG9p
Y2UnIGJlbG93IGl0LCBzbyB3ZSBjYW4gZW5mb3JjZSB0aGUNCj4gc2luZ2xlLWxlZ2FjeS1nYWRn
ZXQgcnVsZSBhcyBiZWZvcmUuDQoNCkhlbGxvIEFybmQsDQoNCkEgZGlzY3Vzc2lvbiBpcyBvbmdv
aW5nIGFib3V0IHdoZXRoZXIgb3Igbm90IGNvbW1pdCA3YTk2MThhMjJhYWQgc2hvdWxkIGJlIHJl
dmVydGVkLg0KUGxlYXNlIGRyb3AgdGhpcyBwYXRjaCB1bnRpbCBhIGNvbmNsdXNpb24gaGFzIGJl
ZW4gcmVhY2hlZC4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==

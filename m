Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:31838 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751498AbdFZKGR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 06:06:17 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: "H. Nikolaus Schaller" <hns@goldelico.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
Subject: Re: [PATCH v1 0/6] Add support of OV9655 camera
Date: Mon, 26 Jun 2017 10:05:41 +0000
Message-ID: <cb9bcc6e-4bc8-7eaa-3d15-6e16e22226f2@st.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com>
In-Reply-To: <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE11225E35AA654C82341E0EB2465CF1@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgTmlrb2xhdXMsDQoNCk9uIDA2LzIyLzIwMTcgMDU6NDEgUE0sIEguIE5pa29sYXVzIFNjaGFs
bGVyIHdyb3RlOg0KPiANCj4+IEFtIDIyLjA2LjIwMTcgdW0gMTc6MDUgc2NocmllYiBIdWd1ZXMg
RnJ1Y2hldCA8aHVndWVzLmZydWNoZXRAc3QuY29tPjoNCj4+DQo+PiBUaGlzIHBhdGNoc2V0IGVu
YWJsZXMgT1Y5NjU1IGNhbWVyYSBzdXBwb3J0Lg0KPj4NCj4+IE9WOTY1NSBzdXBwb3J0IGhhcyBi
ZWVuIHRlc3RlZCB1c2luZyBTVE0zMkY0RElTLUNBTSBleHRlbnNpb24gYm9hcmQNCj4+IHBsdWdn
ZWQgb24gY29ubmVjdG9yIFAxIG9mIFNUTTMyRjc0NkctRElTQ08gYm9hcmQuDQo+PiBEdWUgdG8g
bGFjayBvZiBPVjk2NTAvNTIgaGFyZHdhcmUgc3VwcG9ydCwgdGhlIG1vZGlmaWVkIHJlbGF0ZWQg
Y29kZQ0KPj4gY291bGQgbm90IGhhdmUgYmVlbiBjaGVja2VkIGZvciBub24tcmVncmVzc2lvbi4N
Cj4+DQo+PiBGaXJzdCBwYXRjaGVzIHVwZ3JhZGUgY3VycmVudCBzdXBwb3J0IG9mIE9WOTY1MC81
MiB0byBwcmVwYXJlIHRoZW4NCj4+IGludHJvZHVjdGlvbiBvZiBPVjk2NTUgdmFyaWFudCBwYXRj
aC4NCj4+IEJlY2F1c2Ugb2YgT1Y5NjU1IHJlZ2lzdGVyIHNldCBzbGlnaHRseSBkaWZmZXJlbnQg
ZnJvbSBPVjk2NTAvOTY1MiwNCj4+IG5vdCBhbGwgb2YgdGhlIGRyaXZlciBmZWF0dXJlcyBhcmUg
c3VwcG9ydGVkIChjb250cm9scykuIFN1cHBvcnRlZA0KPj4gcmVzb2x1dGlvbnMgYXJlIGxpbWl0
ZWQgdG8gVkdBLCBRVkdBLCBRUVZHQS4NCj4+IFN1cHBvcnRlZCBmb3JtYXQgaXMgbGltaXRlZCB0
byBSR0I1NjUuDQo+PiBDb250cm9scyBhcmUgbGltaXRlZCB0byBjb2xvciBiYXIgdGVzdCBwYXR0
ZXJuIGZvciB0ZXN0IHB1cnBvc2UuDQo+Pg0KPj4gT1Y5NjU1IGluaXRpYWwgc3VwcG9ydCBpcyBi
YXNlZCBvbiBhIGRyaXZlciB3cml0dGVuIGJ5IEguIE5pa29sYXVzIFNjaGFsbGVyIFsxXS4NCj4g
DQo+IEdyZWF0IQ0KPiANCj4gSSB3aWxsIHRlc3QgYXMgc29vbiBhcyBwb3NzaWJsZS4NCj4gDQoN
Ck1hbnkgdGhhbmtzIGZvciB5b3VyIGFjdGl2ZSByZXZpZXcgYW5kIHRlc3RpbmcgTmlrb2xhdXMg
IQ0KDQo+PiBPVjk2NTUgcmVnaXN0ZXJzIHNlcXVlbmNlcyBjb21lIGZyb20gU1RNMzJDdWJlRjcg
ZW1iZWRkZWQgc29mdHdhcmUgWzJdLg0KPiANCj4gVGhlcmUgaXMgYWxzbyBhIHByZWxpbWluYXJ5
IGRhdGEgc2hlZXQsIGUuZy4gaGVyZToNCj4gDQo+IGh0dHA6Ly9lbGVjdHJpY3N0dWZmLmNvLnVr
L09WOTY1NS1kYXRhc2hlZXQtYW5ub3RhdGVkLnBkZg0KDQpUaGlzIGlzIHRoZSBkYXRhc2hlZXQg
SSd2ZSB1c2VkIGZvciByZWdpc3RlcnMgbmFtaW5nIGFuZCBzaWduaWZpY2F0aW9uLg0KDQpCUiwN
Ckh1Z3Vlcy4NCj4gDQo+Pg0KPj4gWzFdIGh0dHA6Ly9naXQuZ29sZGVsaWNvLmNvbS8/cD1ndGEw
NC1rZXJuZWwuZ2l0O2E9c2hvcnRsb2c7aD1yZWZzL2hlYWRzL3dvcmsvaG5zL3ZpZGVvL292OTY1
NQ0KPj4gWzJdIGh0dHBzOi8vZGV2ZWxvcGVyLm1iZWQub3JnL3RlYW1zL1NUL2NvZGUvQlNQX0RJ
U0NPX0Y3NDZORy9maWxlL2UxZDlkYTdmZTg1Ni9Ecml2ZXJzL0JTUC9Db21wb25lbnRzL292OTY1
NS9vdjk2NTUuYw0KPj4NCj4+ID09PT09PT09PT09DQo+PiA9IGhpc3RvcnkgPQ0KPj4gPT09PT09
PT09PT0NCj4+IHZlcnNpb24gMToNCj4+ICAgLSBJbml0aWFsIHN1Ym1pc3Npb24uDQo+Pg0KPj4g
SC4gTmlrb2xhdXMgU2NoYWxsZXIgKDEpOg0KPj4gICBEVCBiaW5kaW5nczogYWRkIGJpbmRpbmdz
IGZvciBvdjk2NXggY2FtZXJhIG1vZHVsZQ0KPj4NCj4+IEh1Z3VlcyBGcnVjaGV0ICg1KToNCj4+
ICAgW21lZGlhXSBvdjk2NTA6IGFkZCBkZXZpY2UgdHJlZSBzdXBwb3J0DQo+PiAgIFttZWRpYV0g
b3Y5NjUwOiBzZWxlY3QgdGhlIG5lYXJlc3QgaGlnaGVyIHJlc29sdXRpb24NCj4+ICAgW21lZGlh
XSBvdjk2NTA6IHVzZSB3cml0ZV9hcnJheSgpIGZvciByZXNvbHV0aW9uIHNlcXVlbmNlcw0KPj4g
ICBbbWVkaWFdIG92OTY1MDogYWRkIG11bHRpcGxlIHZhcmlhbnQgc3VwcG9ydA0KPj4gICBbbWVk
aWFdIG92OTY1MDogYWRkIHN1cHBvcnQgb2YgT1Y5NjU1IHZhcmlhbnQNCj4+DQo+PiAuLi4vZGV2
aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9pMmMvb3Y5NjV4LnR4dCAgICAgICB8ICAzNyArDQo+PiBk
cml2ZXJzL21lZGlhL2kyYy9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgNiAr
LQ0KPj4gZHJpdmVycy9tZWRpYS9pMmMvb3Y5NjUwLmMgICAgICAgICAgICAgICAgICAgICAgICAg
fCA3OTIgKysrKysrKysrKysrKysrKystLS0tDQo+PiAzIGZpbGVzIGNoYW5nZWQsIDcwNCBpbnNl
cnRpb25zKCspLCAxMzEgZGVsZXRpb25zKC0pDQo+PiBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL2kyYy9vdjk2NXgudHh0DQo+Pg0KPj4g
LS0gDQo+PiAxLjkuMQ0KPj4NCj4gDQo+IEJSIGFuZCB0aGFua3MsDQo+IE5pa29sYXVzIFNjaGFs
bGVyDQo+IA==

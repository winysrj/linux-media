Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:37328 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdCIHWm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 02:22:42 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net"
        <linux1394-devel@lists.sourceforge.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "Hans Liljestrand" <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Juergen Gross <jgross@suse.com>
Subject: RE: [Xen-devel] [PATCH 29/29] drivers, xen: convert grant_map.users
 from atomic_t to refcount_t
Date: Thu, 9 Mar 2017 07:19:12 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C569F1@IRSMSX102.ger.corp.intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-30-git-send-email-elena.reshetova@intel.com>
 <99270126-7751-eed0-5efa-fc695ff3be25@oracle.com>
 <2236FBA76BA1254E88B949DDB74E612B41C56177@IRSMSX102.ger.corp.intel.com>
 <c4ea3925-f505-3c5b-a9fc-c74ea5a7cbe9@oracle.com>
In-Reply-To: <c4ea3925-f505-3c5b-a9fc-c74ea5a7cbe9@oracle.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQo+IE9uIDAzLzA4LzIwMTcgMDg6NDkgQU0sIFJlc2hldG92YSwgRWxlbmEgd3JvdGU6DQo+ID4+
IE9uIDAzLzA2LzIwMTcgMDk6MjEgQU0sIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPj4+IHJl
ZmNvdW50X3QgdHlwZSBhbmQgY29ycmVzcG9uZGluZyBBUEkgc2hvdWxkIGJlDQo+ID4+PiB1c2Vk
IGluc3RlYWQgb2YgYXRvbWljX3Qgd2hlbiB0aGUgdmFyaWFibGUgaXMgdXNlZCBhcw0KPiA+Pj4g
YSByZWZlcmVuY2UgY291bnRlci4gVGhpcyBhbGxvd3MgdG8gYXZvaWQgYWNjaWRlbnRhbA0KPiA+
Pj4gcmVmY291bnRlciBvdmVyZmxvd3MgdGhhdCBtaWdodCBsZWFkIHRvIHVzZS1hZnRlci1mcmVl
DQo+ID4+PiBzaXR1YXRpb25zLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEVsZW5hIFJl
c2hldG92YSA8ZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbT4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6
IEhhbnMgTGlsamVzdHJhbmQgPGlzaGthbWllbEBnbWFpbC5jb20+DQo+ID4+PiBTaWduZWQtb2Zm
LWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4NCj4gPj4+IFNpZ25lZC1vZmYt
Ynk6IERhdmlkIFdpbmRzb3IgPGR3aW5kc29yQGdtYWlsLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4g
IGRyaXZlcnMveGVuL2dudGRldi5jIHwgMTEgKysrKysrLS0tLS0NCj4gPj4+ICAxIGZpbGUgY2hh
bmdlZCwgNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+PiBSZXZpZXdlZC1ieTog
Qm9yaXMgT3N0cm92c2t5IDxib3Jpcy5vc3Ryb3Zza3lAb3JhY2xlLmNvbT4NCj4gPiBJcyB0aGVy
ZSBhIHRyZWUgdGhhdCBjYW4gdGFrZSB0aGlzIGNoYW5nZT8gVHVybnMgb3V0IGl0IGlzIGJldHRl
ciB0byBwcm9wYWdhdGUNCj4gY2hhbmdlcyB2aWEgc2VwYXJhdGUgdHJlZXMgYW5kIG9ubHkgbGVm
dG92ZXJzIGNhbiBiZSB0YWtlbiB2aWEgR3JlZydzIHRyZWUuDQo+ID4NCj4gDQo+IFN1cmUsIHdl
IGNhbiB0YWtlIGl0IHZpYSBYZW4gdHJlZSBmb3IgcmMzLg0KDQpUaGFuayB5b3UgdmVyeSBtdWNo
IQ0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVuYS4NCg0KPiANCj4gLWJvcmlzDQo=

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:10547 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752861AbdCHODZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 09:03:25 -0500
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
Date: Wed, 8 Mar 2017 13:49:32 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C56177@IRSMSX102.ger.corp.intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-30-git-send-email-elena.reshetova@intel.com>
 <99270126-7751-eed0-5efa-fc695ff3be25@oracle.com>
In-Reply-To: <99270126-7751-eed0-5efa-fc695ff3be25@oracle.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQo+IE9uIDAzLzA2LzIwMTcgMDk6MjEgQU0sIEVsZW5hIFJlc2hldG92YSB3cm90ZToNCj4gPiBy
ZWZjb3VudF90IHR5cGUgYW5kIGNvcnJlc3BvbmRpbmcgQVBJIHNob3VsZCBiZQ0KPiA+IHVzZWQg
aW5zdGVhZCBvZiBhdG9taWNfdCB3aGVuIHRoZSB2YXJpYWJsZSBpcyB1c2VkIGFzDQo+ID4gYSBy
ZWZlcmVuY2UgY291bnRlci4gVGhpcyBhbGxvd3MgdG8gYXZvaWQgYWNjaWRlbnRhbA0KPiA+IHJl
ZmNvdW50ZXIgb3ZlcmZsb3dzIHRoYXQgbWlnaHQgbGVhZCB0byB1c2UtYWZ0ZXItZnJlZQ0KPiA+
IHNpdHVhdGlvbnMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBFbGVuYSBSZXNoZXRvdmEgPGVs
ZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSGFucyBMaWxqZXN0
cmFuZCA8aXNoa2FtaWVsQGdtYWlsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLZWVzIENvb2sg
PGtlZXNjb29rQGNocm9taXVtLm9yZz4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBXaW5kc29y
IDxkd2luZHNvckBnbWFpbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMveGVuL2dudGRldi5j
IHwgMTEgKysrKysrLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwg
NSBkZWxldGlvbnMoLSkNCj4gDQo+IFJldmlld2VkLWJ5OiBCb3JpcyBPc3Ryb3Zza3kgPGJvcmlz
Lm9zdHJvdnNreUBvcmFjbGUuY29tPg0KDQpJcyB0aGVyZSBhIHRyZWUgdGhhdCBjYW4gdGFrZSB0
aGlzIGNoYW5nZT8gVHVybnMgb3V0IGl0IGlzIGJldHRlciB0byBwcm9wYWdhdGUgY2hhbmdlcyB2
aWEgc2VwYXJhdGUgdHJlZXMgYW5kIG9ubHkgbGVmdG92ZXJzIGNhbiBiZSB0YWtlbiB2aWEgR3Jl
ZydzIHRyZWUuICANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQoNCg==

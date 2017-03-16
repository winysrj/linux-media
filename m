Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:31644 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751838AbdCPSAQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 14:00:16 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net"
        <linux1394-devel@lists.sourceforge.net>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 08/29] drivers, md: convert mddev.active from atomic_t
 to refcount_t
Date: Thu, 16 Mar 2017 18:00:07 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C59FF8@IRSMSX102.ger.corp.intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
         <1488810076-3754-9-git-send-email-elena.reshetova@intel.com>
         <87lgs8ukfq.fsf@concordia.ellerman.id.au>
         <2236FBA76BA1254E88B949DDB74E612B41C588E8@IRSMSX102.ger.corp.intel.com>
 <1489503539.3214.17.camel@HansenPartnership.com>
In-Reply-To: <1489503539.3214.17.camel@HansenPartnership.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PiBPbiBUdWUsIDIwMTctMDMtMTQgYXQgMTI6MjkgKzAwMDAsIFJlc2hldG92YSwgRWxlbmEgd3Jv
dGU6DQo+ID4gPiBFbGVuYSBSZXNoZXRvdmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+IHdy
aXRlczoNCj4gPiA+DQo+ID4gPiA+IHJlZmNvdW50X3QgdHlwZSBhbmQgY29ycmVzcG9uZGluZyBB
UEkgc2hvdWxkIGJlDQo+ID4gPiA+IHVzZWQgaW5zdGVhZCBvZiBhdG9taWNfdCB3aGVuIHRoZSB2
YXJpYWJsZSBpcyB1c2VkIGFzDQo+ID4gPiA+IGEgcmVmZXJlbmNlIGNvdW50ZXIuIFRoaXMgYWxs
b3dzIHRvIGF2b2lkIGFjY2lkZW50YWwNCj4gPiA+ID4gcmVmY291bnRlciBvdmVyZmxvd3MgdGhh
dCBtaWdodCBsZWFkIHRvIHVzZS1hZnRlci1mcmVlDQo+ID4gPiA+IHNpdHVhdGlvbnMuDQo+ID4g
PiA+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEVsZW5hIFJlc2hldG92YSA8ZWxlbmEucmVzaGV0
b3ZhQGludGVsLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogSGFucyBMaWxqZXN0cmFuZCA8
aXNoa2FtaWVsQGdtYWlsLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogS2VlcyBDb29rIDxr
ZWVzY29va0BjaHJvbWl1bS5vcmc+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IERhdmlkIFdpbmRz
b3IgPGR3aW5kc29yQGdtYWlsLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+ICBkcml2ZXJzL21k
L21kLmMgfCA2ICsrKy0tLQ0KPiA+ID4gPiAgZHJpdmVycy9tZC9tZC5oIHwgMyArKy0NCj4gPiA+
ID4gIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+
ID4NCj4gPiA+IFdoZW4gYm9vdGluZyBsaW51eC1uZXh0IChzcGVjaWZpY2FsbHkgNWJlNDkyMWM5
OTU4ZWMpIEknbSBzZWVpbmcNCj4gPiA+IHRoZQ0KPiA+ID4gYmFja3RyYWNlIGJlbG93LiBJIHN1
c3BlY3QgdGhpcyBwYXRjaCBpcyBqdXN0IGV4cG9zaW5nIGFuIGV4aXN0aW5nDQo+ID4gPiBpc3N1
ZT8NCj4gPg0KPiA+IFllcywgd2UgaGF2ZSBhY3R1YWxseSBiZWVuIGZvbGxvd2luZyB0aGlzIGlz
c3VlIGluIHRoZSBhbm90aGVyDQo+ID4gdGhyZWFkLg0KPiA+IEl0IGxvb2tzIGxpa2UgdGhlIG9i
amVjdCBpcyByZS11c2VkIHNvbWVob3csIGJ1dCBJIGNhbid0IHF1aXRlDQo+ID4gdW5kZXJzdGFu
ZCBob3cganVzdCBieSByZWFkaW5nIHRoZSBjb2RlLg0KPiA+IFRoaXMgd2FzIHdoYXQgSSBwdXQg
aW50byB0aGUgcHJldmlvdXMgdGhyZWFkOg0KPiA+DQo+ID4gIlRoZSBsb2cgYmVsb3cgaW5kaWNh
dGVzIHRoYXQgeW91IGFyZSB1c2luZyB5b3VyIHJlZmNvdW50ZXIgaW4gYSBiaXQNCj4gPiB3ZWly
ZCB3YXkgaW4gbWRkZXZfZmluZCgpLg0KPiA+IEhvd2V2ZXIsIEkgY2FuJ3QgZmluZCB0aGUgcGxh
Y2UgKGp1c3QgYnkgcmVhZGluZyB0aGUgY29kZSkgd2hlcmUgeW91DQo+ID4gd291bGQgaW5jcmVt
ZW50IHJlZmNvdW50ZXIgZnJvbSB6ZXJvICh2cy4gc2V0dGluZyBpdCB0byBvbmUpLg0KPiA+IEl0
IGxvb2tzIGxpa2UgeW91IGVpdGhlciBpdGVyYXRlIG92ZXIgZXhpc3Rpbmcgbm9kZXMgKGFuZCBp
bmNyZW1lbnQNCj4gPiB0aGVpciBjb3VudGVycywgd2hpY2ggc2hvdWxkIGJlID49IDEgYXQgdGhl
IHRpbWUgb2YgaW5jcmVtZW50KSBvcg0KPiA+IGNyZWF0ZSBhIG5ldyBub2RlLCBidXQgdGhlbiBt
ZGRldl9pbml0KCkgc2V0cyB0aGUgY291bnRlciB0byAxLiAiDQo+ID4NCj4gPiBJZiB5b3UgY2Fu
IGhlbHAgdG8gdW5kZXJzdGFuZCB3aGF0IGlzIGdvaW5nIG9uIHdpdGggdGhlIG9iamVjdA0KPiA+
IGNyZWF0aW9uL2Rlc3RydWN0aW9uLCB3b3VsZCBiZSBhcHByZWNpYXRlZCENCj4gPg0KPiA+IEFs
c28gU2hhb2h1YSBMaSBzdG9wcGVkIHRoaXMgcGF0Y2ggY29taW5nIGZyb20gaGlzIHRyZWUgc2lu
Y2UgdGhlDQo+ID4gaXNzdWUgd2FzIGNhdWdodCBhdCB0aGF0IHRpbWUsIHNvIHdlIGFyZSBub3Qg
Z29pbmcgdG8gbWVyZ2UgdGhpcw0KPiA+IHVudGlsIHdlIGZpZ3VyZSBpdCBvdXQuDQo+IA0KPiBB
c2tpbmcgb24gdGhlIGNvcnJlY3QgbGlzdCAoZG0tZGV2ZWwpIHdvdWxkIGhhdmUgZ290IHlvdSB0
aGUgZWFzeQ0KPiBhbnN3ZXI6ICBUaGUgcmVmY291bnQgYmVoaW5kIG1kZGV2LT5hY3RpdmUgaXMg
YSBnZW51aW5lIGF0b21pYy4gIEl0IGhhcw0KPiByZWZjb3VudCBwcm9wZXJ0aWVzIGJ1dCBvbmx5
IGlmIHRoZSBhcnJheSBmYWlscyB0byBpbml0aWFsaXNlIChpbiB0aGF0DQo+IGNhc2UsIGZpbmFs
IHB1dCBraWxscyBpdCkuICBPbmNlIGl0J3MgYWRkZWQgdG8gdGhlIHN5c3RlbSBhcyBhIGdlbmRp
c2ssDQo+IGl0IGNhbm5vdCBiZSBmcmVlZCB1bnRpbCBtZF9mcmVlKCkuICBUaHVzIGl0cyAtPmFj
dGl2ZSBjb3VudCBjYW4gZ28gdG8NCj4gemVybyAod2hlbiBpdCBiZWNvbWVzIGluYWN0aXZlOyB1
c3VhbGx5IGJlY2F1c2Ugb2YgYW4gdW5tb3VudCkuIE9uIGENCj4gc2ltcGxlIGFsbG9jYXRpb24g
cmVnYXJkbGVzcyBvZiBvdXRjb21lLCB0aGUgbGFzdCBleGVjdXRlZCBzdGF0ZW1lbnQgaW4NCj4g
bWRfYWxsb2MgaXMgbWRkZXZfcHV0KCk6IHRoYXQgZGVzdHJveXMgdGhlIGRldmljZSBpZiB3ZSBk
aWRuJ3QgbWFuYWdlDQo+IHRvIGNyZWF0ZSBpdCBvciByZXR1cm5zIDAgYW5kIGFkZHMgYW4gaW5h
Y3RpdmUgZGV2aWNlIHRvIHRoZSBzeXN0ZW0NCj4gd2hpY2ggdGhlIHVzZXIgY2FuIGdldCB3aXRo
IG1kZGV2X2ZpbmQoKS4NCg0KVGhhbmsgeW91IEphbWVzIGZvciBleHBsYWluaW5nIHRoaXMhIEkg
Z3Vlc3MgaW4gdGhpcyBjYXNlLCB0aGUgY29udmVyc2lvbiBkb2Vzbid0IG1ha2Ugc2Vuc2UuIA0K
QW5kIHNvcnJ5IGFib3V0IG5vdCBhc2tpbmcgaW4gYSBjb3JyZWN0IHBsYWNlOiB3ZSBhcmUgaGFu
ZGxpbmcgbWFueSBzaW1pbGFyIHBhdGNoZXMgbm93IGFuZCB3aGlsZSBJIHRyeSB0byByZWFjaCB0
aGUgcmlnaHQgYXVkaWVuY2UgdXNpbmcgZ2V0X21haW50YWluZXIgc2NyaXB0LCBpdCBkb2Vzbid0
IGFsd2F5cyBzdWNjZWVkcy4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KDQo+IA0KPiBKYW1l
cw0KPiANCg0K

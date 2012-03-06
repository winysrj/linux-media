Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45433 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030372Ab2CFPZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 10:25:16 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0G00K6GYU2RX00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 15:25:14 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G00ENWYU12T@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 15:25:14 +0000 (GMT)
Date: Tue, 06 Mar 2012 16:24:04 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: V4L2 MFC video decoding example application
To: linux-media <linux-media@vger.kernel.org>
Cc: "mika.kamppuri@symbio.com" <mika.kamppuri@symbio.com>,
	"jari.issakainen@symbio.com" <jari.issakainen@symbio.com>,
	"thomas.langas@fxitech.com" <thomas.langas@fxitech.com>,
	"dakuit00@googlemail.com" <dakuit00@googlemail.com>,
	"brian@seedmorn.cn" <brian@seedmorn.cn>,
	"dron0gus@gmail.com" <dron0gus@gmail.com>,
	"sawyer@seedmorn.cn" <sawyer@seedmorn.cn>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"subash.ramaswamy@linaro.org" <subash.ramaswamy@linaro.org>,
	"maheshbhairodagi@gmail.com" <maheshbhairodagi@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"naveen.ch@samsung.com" <naveen.ch@samsung.com>,
	"sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jtp.park@samsung.com" <jtp.park@samsung.com>,
	"jaeryul.oh@samsung.com" <jaeryul.oh@samsung.com>,
	Chanho Park <chanho61.park@samsung.com>
Message-id: <ADF13DA15EB3FE4FBA487CCC7BEFDF36270347EFE4@bssrvexch01>
Content-language: en-US
Content-transfer-encoding: base64
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGksDQoNCkkgd291bGQgbGlrZSB0byBpbmZvcm0geW91IHRoYXQgdGhlIGV4YW1wbGUgYXBwbGlj
YXRpb24gZm9yIHRoZSBNRkMgZHJpdmVyIGhhcyBiZWVuIHByZXBhcmVkIGFuZCB3YXMgdG9kYXkg
cmVsZWFzZWQgdG8gdGhlIG9wZW4gc291cmNlLg0KDQpUaGUgYXBwbGljYXRpb24gZGVtb25zdHJh
dGVzIGhvdyB0byBzZXR1cCBhbmQgaGFuZGxlIHZpZGVvIHN0cmVhbSBkZWNvZGluZy4gSXQgdXNl
cyBNRkMgZm9yIHZpZGVvIGRlY29kaW5nIGFuZCBGSU1DIGZvciBwb3N0IHByb2Nlc3NpbmcgKGNv
bG9yIGNvbnZlcnNpb24gYW5kIHNjYWxpbmcpLiBUaGUgcmVzdWx0aW5nIGltYWdlIGlzIGRpc3Bs
YXllZCB1c2luZyB0aGUgZnJhbWUgYnVmZmVyLiBUaGUgbWFpbiBnb2FsIHdhcyByZWxlYXNpbmcg
YSBzaW1wbGUgYW5kIGVhc3kgdG8gdW5kZXJzdGFuZCBleGFtcGxlIGFwcGxpY2F0aW9uLiBJIGhv
cGUgdGhhdCBpdCB3aWxsIHByb3ZlIHVzZWZ1bCBhbmQgY2xlYXIuDQoNClRoZSBjb2RlIGNhbiBi
ZSBmb3VuZCBoZXJlOg0KaHR0cDovL2dpdC5pbmZyYWRlYWQub3JnL3VzZXJzL2ttcGFyay9wdWJs
aWMtYXBwcy90cmVlL0hFQUQ6L3Y0bDItbWZjLWV4YW1wbGUNCg0KQmVzdCB3aXNoZXMsDQotLQ0K
S2FtaWwgRGVic2tpDQpMaW51eCBQbGF0Zm9ybSBHcm91cA0KU2Ftc3VuZyBQb2xhbmQgUiZEIENl
bnRlcg0KDQoNCg0KVGhlIGFib3ZlIG1lc3NhZ2UgaXMgaW50ZW5kZWQgc29sZWx5IGZvciB0aGUg
bmFtZWQgYWRkcmVzc2VlIGFuZCBtYXkgY29udGFpbiB0cmFkZSBzZWNyZXQsIGluZHVzdHJpYWwg
dGVjaG5vbG9neSBvciBwcml2aWxlZ2VkIGFuZCBjb25maWRlbnRpYWwgaW5mb3JtYXRpb24gb3Ro
ZXJ3aXNlIHByb3RlY3RlZCB1bmRlciBhcHBsaWNhYmxlIGxhdy4gQW55IHVuYXV0aG9yaXplZCBk
aXNzZW1pbmF0aW9uLCBkaXN0cmlidXRpb24sIGNvcHlpbmcgb3IgdXNlIG9mIHRoZSBpbmZvcm1h
dGlvbiBjb250YWluZWQgaW4gdGhpcyBjb21tdW5pY2F0aW9uIGlzIHN0cmljdGx5IHByb2hpYml0
ZWQuIElmIHlvdSBoYXZlIHJlY2VpdmVkIHRoaXMgY29tbXVuaWNhdGlvbiBpbiBlcnJvciwgcGxl
YXNlIG5vdGlmeSBzZW5kZXIgYnkgZW1haWwgYW5kIGRlbGV0ZSB0aGlzIGNvbW11bmljYXRpb24g
aW1tZWRpYXRlbHkuDQoNCg0KUG93ecW8c3phIHdpYWRvbW/Fm8SHIHByemV6bmFjem9uYSBqZXN0
IHd5xYLEhWN6bmllIGRsYSBhZHJlc2F0YSBuaW5pZWpzemVqIHdpYWRvbW/Fm2NpIGkgbW/FvGUg
emF3aWVyYcSHIGluZm9ybWFjamUgYsSZZMSFY2UgdGFqZW1uaWPEhSBoYW5kbG93xIUsIHRhamVt
bmljxIUgcHJ6ZWRzacSZYmlvcnN0d2Egb3JheiBpbmZvcm1hY2plIG8gY2hhcmFrdGVyemUgcG91
Zm55bSBjaHJvbmlvbmUgb2Jvd2nEhXp1asSFY3ltaSBwcnplcGlzYW1pIHByYXdhLiBKYWtpZWtv
bHdpZWsgbmlldXByYXduaW9uZSBpY2ggcm96cG93c3plY2huaWFuaWUsIGR5c3RyeWJ1Y2phLCBr
b3Bpb3dhbmllIGx1YiB1xbx5Y2llIGluZm9ybWFjamkgemF3YXJ0eWNoIHcgcG93ecW8c3plaiB3
aWFkb21vxZtjaSBqZXN0IHphYnJvbmlvbmUuIEplxZtsaSBvdHJ6eW1hxYJlxZsgcG93ecW8c3rE
hSB3aWFkb21vxZvEhyBvbXnFgmtvd28sIHVwcnplam1pZSBwcm9zesSZIHBvaW5mb3JtdWogbyB0
eW0gZmFrY2llIGRyb2fEhSBtYWlsb3fEhSBuYWRhd2PEmSB0ZWogd2lhZG9tb8WbY2kgb3JheiBu
aWV6d8WCb2N6bmllIHVzdcWEIHBvd3nFvHN6xIUgd2lhZG9tb8WbxIcgemUgc3dvamVnbyBrb21w
dXRlcmEuDQo=

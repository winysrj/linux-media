Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43183 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbZKSW7i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 17:59:38 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
Date: Thu, 19 Nov 2009 16:59:36 -0600
Subject: vpfe capture - Patches ready for merge
Message-ID: <A69FA2915331DC488A831521EAE36FE40155A517B6@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A69FA2915331DC488A831521EAE36FE40155A517B6dlee06enttico_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A69FA2915331DC488A831521EAE36FE40155A517B6dlee06enttico_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Mauro,

We have few patches already reviewed and ready for merge (See Hans' pull re=
quest in the attachment. Could you merge these so that we can base our futu=
re patches on this?=20

Thanks
Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com


--_002_A69FA2915331DC488A831521EAE36FE40155A517B6dlee06enttico_
Content-Type: message/rfc822

Received: from dflp53.itg.ti.com (128.247.5.6) by dlee74.ent.ti.com
 (157.170.170.8) with Microsoft SMTP Server (TLS) id 8.1.358.0; Tue, 10 Nov
 2009 11:59:07 -0600
Received: from neches.ext.ti.com (localhost [127.0.0.1])	by dflp53.itg.ti.com
 (8.13.8/8.13.8) with ESMTP id nAAHx3WT022079;	Tue, 10 Nov 2009 11:59:03 -0600
 (CST)
Received: from mail181-va3-R.bigfish.com (mail-va3.bigfish.com
 [216.32.180.114])	by neches.ext.ti.com (8.13.7/8.13.7) with ESMTP id
 nAAHx2mR027157	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256
 verify=FAIL);	Tue, 10 Nov 2009 11:59:03 -0600
Received: from mail181-va3 (localhost.localdomain [127.0.0.1])	by
 mail181-va3-R.bigfish.com (Postfix) with ESMTP id 813A0AF83EA;	Tue, 10 Nov
 2009 17:59:02 +0000 (UTC)
Received: from mail181-va3 (localhost.localdomain [127.0.0.1]) by mail181-va3
 (MessageSwitch) id 1257875941925858_10513; Tue, 10 Nov 2009 17:59:01 +0000
 (UTC)
Received: from VA3EHSMHS006.bigfish.com (unknown [10.7.14.241])	by
 mail181-va3.bigfish.com (Postfix) with ESMTP id CECBABF804D;	Tue, 10 Nov 2009
 17:59:01 +0000 (UTC)
Received: from vger.kernel.org (209.132.176.167) by VA3EHSMHS006.bigfish.com
 (10.7.99.16) with Microsoft SMTP Server id 14.0.482.32; Tue, 10 Nov 2009
 17:59:01 +0000
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand	id
 S1750929AbZKJR6t (ORCPT <rfc822;rtivy@ti.com> + 15 others);	Tue, 10 Nov 2009
 12:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZKJR6t
	(ORCPT <rfc822;linux-media-outgoing>);	Tue, 10 Nov 2009 12:58:49 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1357 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org	with ESMTP
 id S1750929AbZKJR6s (ORCPT	<rfc822;linux-media@vger.kernel.org>);	Tue, 10 Nov
 2009 12:58:48 -0500
Received: from tschai.lan (cm-84.208.105.24.getinternet.no [84.208.105.24])
	(authenticated bits=0)	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id
 nAAHwcoK084837	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256
 verify=NO);	Tue, 10 Nov 2009 18:58:43 +0100 (CET)	(envelope-from
 hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, "Hiremath, Vaibhav"
	<hvaibhav@ti.com>
Sender: "linux-media-owner@vger.kernel.org"
	<linux-media-owner@vger.kernel.org>
Date: Tue, 10 Nov 2009 11:58:38 -0600
Subject: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
Thread-Topic: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
Thread-Index: AcpiL3+lCQXwrXLRRrC9kQOtqHUmSw==
Message-ID: <200911101858.38183.hverkuil@xs4all.nl>
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: dlee74.ent.ti.com
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
x-virus-scanned: by XS4ALL Virus Scanner
user-agent: KMail/1.9.9
x-bigfish: 
 vps3(z2005n3fb8kf2bjz552II4015L14e1Izz1202hzza509lz2dh6bhadk259o61h)
list-id: <linux-media.vger.kernel.org>
x-spam-tcs-scl: 0:0
x-spamscore: 3
x-mailing-list: linux-media@vger.kernel.org
x-reverse-dns: vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0

SGkgTWF1cm8sDQoNClBsZWFzZSBwdWxsIGZyb20gaHR0cDovL3d3dy5saW51eHR2Lm9yZy9oZy9+
aHZlcmt1aWwvdjRsLWR2YiBmb3IgdGhlIGZvbGxvd2luZzoNCg0KLSB2NGwyLXNwZWM6IGFkZCBt
aXNzaW5nIFY0TDItUElYLUZNVC1TVFYwNjgwIGRlc2NyaXB0aW9uLg0KLSBkZWNvZGVfdG02MDAw
OiBmaXggY29tcGlsYXRpb24NCi0gZGF2aW5jaTogcmVtb3ZlIHN0cmF5IGR1cGxpY2F0ZSBjb25m
aWcgcG9pbnRlcg0KLSBkYXZpbmNpOiBhZGQgbWlzc2luZyB2cGlmX2NhcHR1cmUuYy9oIGZpbGVz
DQotIERhdmluY2kgVlBGRSBDYXB0dXJlOiBTcGVjaWZ5IGRldmljZSBwb2ludGVyIGluIHZpZGVv
YnVmX3F1ZXVlX2RtYV9jb250aWdfaW5pdA0KLSBEYXZpbmNpIFZQRkUgQ2FwdHVyZTogYWRkIGky
YyBhZGFwdGVyIGlkIGluIHBsYXRmb3JtIGRhdGENCi0gRGF2aW5jaSBWUEZFIENhcHR1cmU6IFRh
a2UgaTJjIGFkYXB0ZXIgaWQgdGhyb3VnaCBwbGF0Zm9ybSBkYXRhDQotIERhdmluY2kgVlBGRSBD
YXB0dXJlOlJlcGxhY2VkIElSUV9WRElOVDEgd2l0aCB2cGZlX2Rldi0+Y2NkY19pcnExDQotIFY0
TDI6IEFkZGVkIENJRCdzIFY0TDJfQ0lEX1JPVEFURS9CR19DT0xPUg0KLSB2NGwyIGRvYzogQWRk
ZWQgUk9UQVRFIGFuZCBCR19DT0xPUiBjb250cm9sIGRvY3VtZW50YXRpb24NCi0gRGF2aW5jaSBW
UEZFIENhcHR1cmU6IEFkZCBzdXBwb3J0IGZvciBDb250cm9sIGlvY3Rscw0KLSBWNEwyOiBBZGQg
Q2FwYWJpbGl0eSBhbmQgRmxhZyBmaWVsZCBmb3IgQ2hyb21hIEtleQ0KLSB2NGwyIGRvYzogQWRk
ZWQgRkJVRl9DQVBfU1JDX0NIUk9NQUtFWS9GTEFHX1NSQ19DSFJPTUFLRVkNCg0KTm90ZSB0aGF0
IHRoZSB0aGlyZCBwYXRjaCAoZGF2aW5jaTogcmVtb3ZlIHN0cmF5IGR1cGxpY2F0ZSBjb25maWcg
cG9pbnRlcikgaXMNCmEgaGlnaC1wcmlvIGJ1ZyBmaXggdGhhdCBtdXN0IGdvIGludG8gMi42LjMy
Lg0KDQpJIGRpc2NvdmVyZWQgdGhhdCBmb3Igc29tZSByZWFzb24gdGhlIGRhdmluY2kvdnBpZl9j
YXB0dXJlLmMvaCBmaWxlcyB3ZXJlDQptaXNzaW5nIGluIHRoZSB2NGwtZHZiIG1hc3RlciByZXBv
LCBzbyB0aGV5IGFyZSBhZGRlZCBiYWNrIGluIHRoZSBmb3VydGgNCnBhdGNoIChJIGNvcGllZCB0
aGVtIGZyb20gMi42LjMyLXJjNikuDQoNClRoZXJlIGlzIG9uZSBhcmNoIHBhdGNoIGludm9sdmVk
IGhlcmUgYXMgd2VsbDoNCmh0dHA6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC81MzQyNi8N
Cg0KVGhpcyBwYXRjaCBiZWxvbmdzIGFmdGVyICJEYXZpbmNpIFZQRkUgQ2FwdHVyZTogYWRkIGky
YyBhZGFwdGVyIGlkIGluIHBsYXRmb3JtIGRhdGEiDQpidXQgYmVmb3JlICJUYWtlIGkyYyBhZGFw
dGVyIGlkIHRocm91Z2ggcGxhdGZvcm0gZGF0YSIuDQoNClRoZSBuZXcgY29udHJvbHMgYW5kIGNo
cm9tYWtleSBjYXAvZmxhZyB3ZXJlIG9yaWdpbmFsbHkgZGlzY3Vzc2VkIGluIEphbnVhcnkNCnRv
IEFwcmlsIHRoaXMgeWVhciBiYXNlZCBvbiBvbWFwIHBhdGNoZXMgZnJvbSBIYXJkaWsgU2hhaC4g
SSBhY3R1YWxseQ0KdGhvdWdodCB0aGVzZSBwYXRjaGVzIHdlcmUgY29tbWl0dGVkIG1vbnRocyBh
Z28sIGJ1dCB0aGV5IGFwcGFyZW50bHkgZmVsbA0Kb24gdGhlIGZsb29yLiBUaGUgb3JpZ2luYWwg
ZGlzY3Vzc2lvbiBpcyBoZXJlOg0KaHR0cDovL3d3dy5tYWlsLWFyY2hpdmUuY29tL2xpbnV4LW1l
ZGlhJTQwdmdlci5rZXJuZWwub3JnL21zZzAwNjI0Lmh0bWwNCg0KVGhhbmtzLA0KDQogICAgICAg
IEhhbnMNCg0KZGlmZnN0YXQ6DQogYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2RhdmluY2kv
dnBpZl9jYXB0dXJlLmMgfCAyMTY4ICsrKysrKysrKysrKysrKysrKysrKw0KIGIvbGludXgvZHJp
dmVycy9tZWRpYS92aWRlby9kYXZpbmNpL3ZwaWZfY2FwdHVyZS5oIHwgIDE2NSArDQogbGludXgv
RG9jdW1lbnRhdGlvbi9Eb2NCb29rL3Y0bC9jb250cm9scy54bWwgICAgICAgfCAgIDIwDQogbGlu
dXgvRG9jdW1lbnRhdGlvbi9Eb2NCb29rL3Y0bC9waXhmbXQueG1sICAgICAgICAgfCAgICA1DQog
bGludXgvRG9jdW1lbnRhdGlvbi9Eb2NCb29rL3Y0bC92aWRlb2RldjIuaC54bWwgICAgfCAxMTAz
ICsrKysrLS0tLS0NCiBsaW51eC9Eb2N1bWVudGF0aW9uL0RvY0Jvb2svdjRsL3ZpZGlvYy1nLWZi
dWYueG1sICB8ICAgMTcNCiBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2RhdmluY2kvdnBmZV9j
YXB0dXJlLmMgICB8ICAgNDUNCiBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2RhdmluY2kvdnBp
Zl9kaXNwbGF5LmMgICB8ICAgIDENCiBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3Y0bDItY29t
bW9uLmMgICAgICAgICAgICB8ICAgIDkNCiBsaW51eC9pbmNsdWRlL2xpbnV4L3ZpZGVvZGV2Mi5o
ICAgICAgICAgICAgICAgICAgICB8ICAgIDYNCiBsaW51eC9pbmNsdWRlL21lZGlhL2RhdmluY2kv
dnBmZV9jYXB0dXJlLmggICAgICAgICB8ICAgIDINCiB2NGwyLWFwcHMvdXRpbC9NYWtlZmlsZSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDINCiB2NGwyLWFwcHMvdXRpbC9kZWNvZGVf
dG02MDAwLmMgICAgICAgICAgICAgICAgICAgICB8ICAgIDINCiAxMyBmaWxlcyBjaGFuZ2VkLCAy
OTg3IGluc2VydGlvbnMoKyksIDU1OCBkZWxldGlvbnMoLSkNCg0KLS0NCkhhbnMgVmVya3VpbCAt
IHZpZGVvNGxpbnV4IGRldmVsb3BlciAtIHNwb25zb3JlZCBieSBUQU5EQkVSRyBUZWxlY29tDQot
LQ0KVG8gdW5zdWJzY3JpYmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vic2Ny
aWJlIGxpbnV4LW1lZGlhIiBpbg0KdGhlIGJvZHkgb2YgYSBtZXNzYWdlIHRvIG1ham9yZG9tb0B2
Z2VyLmtlcm5lbC5vcmcNCk1vcmUgbWFqb3Jkb21vIGluZm8gYXQgIGh0dHA6Ly92Z2VyLmtlcm5l
bC5vcmcvbWFqb3Jkb21vLWluZm8uaHRtbA0KDQo=

--_002_A69FA2915331DC488A831521EAE36FE40155A517B6dlee06enttico_--

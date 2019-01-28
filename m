Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D31CC282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 155422175B
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388995AbfA1QX0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:23:26 -0500
Received: from smtp-prod05.osg.ufl.edu ([128.227.74.125]:39630 "EHLO
        smtp.ufl.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388096AbfA1QXY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:23:24 -0500
X-UFL-GatorLink-Authenticated: authenticated as  () with  from 10.36.197.39
Received: from exmbxprd18.ad.ufl.edu ([10.36.197.39])
        by smtp.ufl.edu (8.14.4/8.14.4/3.0.0) with ESMTP id x0SGNJnZ023999
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT);
        Mon, 28 Jan 2019 11:23:19 -0500
Received: from exmbxprd18.ad.ufl.edu (10.36.197.39) by exmbxprd18.ad.ufl.edu
 (10.36.197.39) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 28 Jan
 2019 11:23:18 -0500
Received: from exmbxprd18.ad.ufl.edu ([fe80::890c:cba5:27b2:db27]) by
 exmbxprd18.ad.ufl.edu ([fe80::890c:cba5:27b2:db27%19]) with mapi id
 15.00.1395.000; Mon, 28 Jan 2019 11:23:18 -0500
From:   "Yavuz, Tuba" <tuba@ece.ufl.edu>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
Subject: Re: [PATCH] : media : hackrf : memory leak
Thread-Topic: [PATCH] : media : hackrf : memory leak
Thread-Index: AQHUtxM1m404NYuQy0OyLislZ5eU1KXE2moL
Date:   Mon, 28 Jan 2019 16:23:18 +0000
Message-ID: <1548692598727.81350@ece.ufl.edu>
References: <1548629863510.35899@ece.ufl.edu>,<c99c66e0-54b5-1f4d-8ad9-412286fce6be@xs4all.nl>
In-Reply-To: <c99c66e0-54b5-1f4d-8ad9-412286fce6be@xs4all.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.36.198.14]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-28_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901280123
X-UFL-Spam-Level: *
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgSGFucywKCllvdSBhcmUgcmlnaHQuLgoKVGhpcyB3YXMgYSBmYWxzZSBwb3NpdGl2ZSBkdWUg
dG8gYSBidWcgaW4gbXkgZW52aXJvbm1lbnQgbW9kZWwuIE9idmlvdXNseSwgdjRsMl9kZXZpY2Vf
ZGlzY29ubmVjdCBkb2VzIG5vdCBhZmZlY3QgdGhlIHY0bDJfZGV2aWNlIHJlZmVyZW5jZSBjb3Vu
dC4KCkJlc3QsCgpUdWJhCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
RnJvbTogSGFucyBWZXJrdWlsIDxodmVya3VpbEB4czRhbGwubmw+ClNlbnQ6IE1vbmRheSwgSmFu
dWFyeSAyOCwgMjAxOSA5OjEwIEFNClRvOiBZYXZ1eiwgVHViYTsgbGludXgtbWVkaWFAdmdlci5r
ZXJuZWwub3JnCkNjOiBHcmVnIEtIClN1YmplY3Q6IFJlOiBbUEFUQ0hdIDogbWVkaWEgOiBoYWNr
cmYgOiBtZW1vcnkgbGVhawoKSGkgVHViYSwKCk9uIDEvMjcvMTkgMTE6NTcgUE0sIFlhdnV6LCBU
dWJhIHdyb3RlOgo+Cj4KPiBEdWUgdG8gYSBtaXNzaW5nIHY0bDJfZGV2aWNlX2dldCBmdW5jdGlv
biBpbiB0aGUgaGFja3JmX3Byb2JlIGZ1bmN0aW9uLAo+IHRoZSByZWZlcmVuY2UgY291bnQgb2Yg
dGhlIHY0bDJfZGV2aWNlIG9iamVjdCByZWFjaGVzIHplcm8gaW5zaWRlIHRoZQo+IHdyb25nIEFQ
SSBmdW5jdGlvbiAodmlkZW9fdW5yZWdpc3Rlcl9kZXZpY2UpIGluc3RlYWQgb2YgdjRsMl9kZXZp
Y2VfcHV0Lgo+IFRoaXMgY2F1c2VzIGEgbWVtb3J5IGxlYWsgYXMgdGhlIHJlbGVhc2UgY2FsbGJh
Y2sgd291bGQgbm90IGdldCBjYWxsZWQuCgpUaGUgcmVmY291bnQgaXMgMSBhZnRlciBjYWxsaW5n
IHY0bDJfZGV2aWNlX3JlZ2lzdGVyKCkuIEVhY2ggdmlkZW9fcmVnaXN0ZXJfZGV2aWNlCmNhbGwg
d2lsbCBpbmNyZW1lbnQgdGhlIHJlZmNvdW50IGJ5IDEuIFdoZW4gYSB2aWRlbyBub2RlIGlzIHJl
bGVhc2VkICh2NGwyX2RldmljZV9yZWxlYXNlKQp0aGUgcmVmY291bnQgaXMgZGVjcmVtZW50ZWQs
IGFuZCB3aGVuIHRoZSBkZXZpY2UgaXMgZGlzY29ubmVjdGVkIChoYWNrcmZfZGlzY29ubmVjdCkK
dGhlIHJlZmNvdW50IGlzIGRlY3JlbWVudGVkIGFnYWluLgoKU28gSSBkb24ndCBzZWUgd2hlcmUg
dGhlcmUgaXMgYSBtZW1vcnkgbGVhaywgYW5kIG5laXRoZXIgZG8gSSB1bmRlcnN0YW5kIGhvdwpp
bmNyZW1lbnRpbmcgdGhlIHJlZmNvdW50IHdvdWxkIHByZXZlbnQgYSBtZW1vcnkgbGVhay4gSSB3
b3VsZCBleHBlY3QgdGhhdCBpdApjYXVzZXMgYSBtZW1vcnkgbGVhayEKCklzIHRoZXJlIHNvbWV0
aGluZyBlbHNlIGdvaW5nIG9uIGhlcmU/CgpSZWdhcmRzLAoKICAgICAgICBIYW5zCgo+Cj4KPiBS
ZXBvcnRlZC1ieTogVHViYSBZYXZ1eiA8dHViYUBlY2UudWZsLmVkdT4KPiBTaWduZWQtb2ZmLWJ5
OiBUdWJhIFlhdnV6IDx0dWJhQGVjZS51ZmwuZWR1Pgo+IC0tLQo+Cj4KPiAtLS0gZHJpdmVycy9t
ZWRpYS91c2IvaGFja3JmL2hhY2tyZi5jLm9yaWcgICAgMjAxOS0wMS0yNiAxMTozNzoxOC45MTIy
MTA4MjMgLTA1MDAKPiArKysgZHJpdmVycy9tZWRpYS91c2IvaGFja3JmL2hhY2tyZi5jIDIwMTkt
MDEtMjcgMTc6NTA6NDEuNjYwNzM2Njg4IC0wNTAwCj4gQEAgLTE1MjQsNiArMTUyNCw3IEBAIHN0
YXRpYyBpbnQgaGFja3JmX3Byb2JlKHN0cnVjdCB1c2JfaW50ZXIKPiAgICAgICAgICAgICAgICAg
ICAgICAgIkZhaWxlZCB0byByZWdpc3RlciBhcyB2aWRlbyBkZXZpY2UgKCVkKVxuIiwgcmV0KTsK
PiAgICAgICAgICAgICAgIGdvdG8gZXJyX3ZpZGVvX3VucmVnaXN0ZXJfZGV2aWNlX3J4Owo+ICAg
ICAgIH0KPiArICAgICB2NGwyX2RldmljZV9nZXQoJmRldi0+djRsMl9kZXYpOwo+ICAgICAgIGRl
dl9pbmZvKGRldi0+ZGV2LCAiUmVnaXN0ZXJlZCBhcyAlc1xuIiwKPiAgICAgICAgICAgICAgICB2
aWRlb19kZXZpY2Vfbm9kZV9uYW1lKCZkZXYtPnR4X3ZkZXYpKTvigIsKPgo+Cgo=

Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5E3C282CA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 13:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2864D2186A
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 13:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="UVQVryGP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbfBLNjt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:39:49 -0500
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:8015 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbfBLNjt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 08:39:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3810; q=dns/txt; s=iport;
  t=1549978788; x=1551188388;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Jklf2a1pZXYqoTcXtiEuoDDB5Q+1QogyoztqPzndhn0=;
  b=UVQVryGPXOJ70VYYyKgb001K8kHkxwwgitWRWBZfFEhriy9iGXhjv1/r
   P5rFk7AYJINDdUkkjCpTCvyAvHxwEQVX09xZDqo4m5otEDefy+DfDIywE
   4SqHfVKT4N1ra/ZY3TEpiY/9lJY9QEkegfBzGGQcCg1lNNVYSZptYD1o1
   g=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AEAABfy2Jc/5JdJa1jGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBUQUBAQEBCwGCA2eBAycKg3qIGo1/gmGGSY5pgXsLAQEjhEk?=
 =?us-ascii?q?Zgz4iNAkNAQMBAQIBAQJtHAyFSgEBAQMBJw06CxACAQYCDgoEKAICMBoLAgQ?=
 =?us-ascii?q?BDQUIgx2BaQMNCA+QB5tbCHoziikFgQeLPBeBQD+BEYMSgldHBBiBJSIXgm6?=
 =?us-ascii?q?CWwKJYguYfzMJAoc2h16BEIIiIYFthUuLKIozhT+BKop5AhEUgScfOIFWcBU?=
 =?us-ascii?q?7gmyCKBctiDKFP0ExAY1cgR+BHwEB?=
X-IronPort-AV: E=Sophos;i="5.58,362,1544486400"; 
   d="scan'208";a="516922639"
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2019 13:39:47 +0000
Received: from XCH-ALN-015.cisco.com (xch-aln-015.cisco.com [173.36.7.25])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id x1CDdlsH004529
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 12 Feb 2019 13:39:47 GMT
Received: from xch-aln-012.cisco.com (173.36.7.22) by XCH-ALN-015.cisco.com
 (173.36.7.25) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 Feb
 2019 07:39:45 -0600
Received: from xch-aln-012.cisco.com ([173.36.7.22]) by XCH-ALN-012.cisco.com
 ([173.36.7.22]) with mapi id 15.00.1395.000; Tue, 12 Feb 2019 07:39:44 -0600
From:   "Hans Verkuil (hansverk)" <hansverk@cisco.com>
To:     Wen Yang <yellowriver2010@hotmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?UmU6ILTwuLQ6IFtQQVRDSCAxLzRdIG1lZGlhOiBjZWMtbm90aWZpZXI6IGZp?=
 =?gb2312?Q?x_possible_object_reference_leak?=
Thread-Topic: =?gb2312?B?tPC4tDogW1BBVENIIDEvNF0gbWVkaWE6IGNlYy1ub3RpZmllcjogZml4IHBv?=
 =?gb2312?Q?ssible_object_reference_leak?=
Thread-Index: AQHUwCH951ryS7AxYU2IkMLJINPqbQ==
Date:   Tue, 12 Feb 2019 13:39:44 +0000
Message-ID: <7021cb53c38d49c8b111bc67503f70f0@XCH-ALN-012.cisco.com>
References: <HK0PR02MB363461179B3A702DB9CAEC55B26A0@HK0PR02MB3634.apcprd02.prod.outlook.com>
 <3ed515b78a404ec4a22b5f69ed9d6e28@XCH-ALN-012.cisco.com>
 <6b7fc837599e4069b876b32473b31746@XCH-ALN-012.cisco.com>
 <HK0PR02MB3634D1937109CD28ECBF1654B2650@HK0PR02MB3634.apcprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.47.79.183]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Outbound-SMTP-Client: 173.36.7.25, xch-aln-015.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

SGkgV2VuLAoKT24gMi8xMi8xOSAyOjA0IFBNLCBXZW4gWWFuZyB3cm90ZToKPiBIaSBIYW5zLCB0
aGFuayB5b3UgZm9yIHlvdXIgY29tbWVudHMuCj4gSSB3aWxsIHVzZSBteSBjb21wYW55J3MgbWFp
bGJveCBhbmQgc3VibWl0IGEgdjIgcGF0Y2ggdG8gZml4IHRoZXNlIHByb2JsZW1zIHRvbW9ycm93
LgoKSSBtYWRlIGEgYnVuY2ggb2YgcGF0Y2hlcyBmaXhpbmcgdGhpcyB5ZXN0ZXJkYXkuIEl0J3Mg
YXZhaWxhYmxlIGhlcmU6CgpodHRwczovL2dpdC5saW51eHR2Lm9yZy9odmVya3VpbC9tZWRpYV90
cmVlLmdpdC9sb2cvP2g9Y2VjLXJlZmNudAoKSSBoYXZlbid0IHBvc3RlZCBhbnl0aGluZyBzaW5j
ZSBJIGhhZCBubyBjaGFuY2UgdG8gdGVzdCBpdCB3aXRoIGFjdHVhbApoYXJkd2FyZS4gQnV0IGlm
IHlvdSBoYXZlIGhhcmR3YXJlIGFuZCBhcmUgYWJsZSB0byB2ZXJpZnkgdGhhdCB0aGlzCnNvbHZl
cyB0aGUgaXNzdWUsIHRoZW4gcGxlYXNlIGxldCBtZSBrbm93IHNvIHRoYXQgSSBjYW4gZ2V0IHRo
aXMgbWVyZ2VkLgoKUmVnYXJkcywKCglIYW5zCgo+IAo+IFJlZ2FyZHMsCj4gCj4gICAgICAgICBX
ZW4KPiAKPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4gt6K8/sjL
OiBIYW5zIFZlcmt1aWwgKGhhbnN2ZXJrKSA8aGFuc3ZlcmtAY2lzY28uY29tPgo+ILeiy83Ksbzk
OiAyMDE5xOoy1MIxMcjVIDEwOjU3Cj4gytW8/sjLOiBXZW4gWWFuZzsgSGFucyBWZXJrdWlsOyBN
YXVybyBDYXJ2YWxobyBDaGVoYWIKPiCzrcvNOiBMaW51eCBNZWRpYSBNYWlsaW5nIExpc3Q7IExL
TUwKPiDW98ziOiBSZTogW1BBVENIIDEvNF0gbWVkaWE6IGNlYy1ub3RpZmllcjogZml4IHBvc3Np
YmxlIG9iamVjdCByZWZlcmVuY2UgbGVhawo+IAo+IE9uIDExLzAyLzIwMTkgMTE6MzgsIEhhbnMg
VmVya3VpbCAoaGFuc3ZlcmspIHdyb3RlOgo+PiBPbiAwOS8wMi8yMDE5IDAzOjQ4LCBXZW4gWWFu
ZyB3cm90ZToKPj4+IHB1dF9kZXZpY2UoKSBzaG91bGQgYmUgY2FsbGVkIGluIGNlY19ub3RpZmll
cl9yZWxlYXNlKCksCj4+PiBzaW5jZSB0aGUgZGV2IGlzIGJlaW5nIHBhc3NlZCBkb3duIHRvIGNl
Y19ub3RpZmllcl9nZXRfY29ubigpLAo+Pj4gd2hpY2ggaG9sZHMgcmVmZXJlbmNlLiBPbiBjZWNf
bm90aWZpZXIgZGVzdHJ1Y3Rpb24sIGl0Cj4+PiBzaG91bGQgZHJvcCB0aGUgcmVmZXJlbmNlIHRv
IHRoZSBkZXZpY2UuCj4+Pgo+Pj4gRml4ZXM6IDY5MTdhN2I3NzQxMyAoIlttZWRpYV0gbWVkaWE6
IGFkZCBDRUMgbm90aWZpZXIgc3VwcG9ydCIpCj4+PiBTaWduZWQtb2ZmLWJ5OiBXZW4gWWFuZyA8
eWVsbG93cml2ZXIyMDEwQGhvdG1haWwuY29tPgo+Pj4gLS0tCj4+PiAgZHJpdmVycy9tZWRpYS9j
ZWMvY2VjLW5vdGlmaWVyLmMgfCAxICsKPj4+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KykKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9jZWMvY2VjLW5vdGlmaWVyLmMg
Yi9kcml2ZXJzL21lZGlhL2NlYy9jZWMtbm90aWZpZXIuYwo+Pj4gaW5kZXggZGQyMDc4Yi4uNjIx
ZDRhZSAxMDA2NDQKPj4+IC0tLSBhL2RyaXZlcnMvbWVkaWEvY2VjL2NlYy1ub3RpZmllci5jCj4+
PiArKysgYi9kcml2ZXJzL21lZGlhL2NlYy9jZWMtbm90aWZpZXIuYwo+Pj4gQEAgLTY2LDYgKzY2
LDcgQEAgc3RhdGljIHZvaWQgY2VjX25vdGlmaWVyX3JlbGVhc2Uoc3RydWN0IGtyZWYgKmtyZWYp
Cj4+PiAgICAgICAgICAgICAgY29udGFpbmVyX29mKGtyZWYsIHN0cnVjdCBjZWNfbm90aWZpZXIs
IGtyZWYpOwo+Pj4KPj4+ICAgICAgbGlzdF9kZWwoJm4tPmhlYWQpOwo+Pj4gKyAgICBwdXRfZGV2
aWNlKG4tPmRldik7Cj4+PiAgICAgIGtmcmVlKG4tPmNvbm4pOwo+Pj4gICAgICBrZnJlZShuKTsK
Pj4+ICB9Cj4+Pgo+Pgo+PiBTb3JyeSwgbm8uIFRoZSBkZXYgcG9pbnRlciBpcyBqdXN0IGEgc2Vh
cmNoIGtleSB0aGF0IHRoZSBub3RpZmllciBjb2RlIGxvb2tzCj4+IGZvci4gSXQgaXMgbm90IHRo
ZSBub3RpZmllcidzIHJlc3BvbnNpYmlsaXR5IHRvIHRha2UgYSByZWZlcmVuY2UsIHRoYXQgd291
bGQKPj4gYmUgdGhlIHJlc3BvbnNpYmlsaXR5IG9mIHRoZSBoZG1pIGFuZCBjZWMgZHJpdmVycy4K
PiAKPiBDb3JyZWN0aW9uOiB0aGUgY2VjIGRyaXZlciBzaG91bGQgbmV2ZXIgdGFrZSBhIHJlZmVy
ZW5jZSBvZiB0aGUgaGRtaSBkZXZpY2UuCj4gSXQgbmV2ZXIgYWNjZXNzZXMgdGhlIEhETUkgZGV2
aWNlLCBpdCBvbmx5IG5lZWRzIHRoZSBIRE1JIGRldmljZSBwb2ludGVyIGFzCj4gYSBrZXkgaW4g
dGhlIG5vdGlmaWVyIGxpc3QuCj4gCj4gVGhlIHJlYWwgcHJvYmxlbSBpcyB0aGF0IHNldmVyYWwg
Q0VDIGRyaXZlcnMgdGFrZSBhIHJlZmVyZW5jZSBvZiB0aGUgSERNSSBkZXZpY2UKPiBhbmQgbmV2
ZXIgcmVsZWFzZSBpdC4gU28gdGhvc2UgZHJpdmVycyBuZWVkIHRvIGJlIGZpeGVkLgo+IAo+IFJl
Z2FyZHMsCj4gCj4gICAgICAgICBIYW5zCj4gCj4+Cj4+IElmIHlvdSBjYW4gZGVtb25zdHJhdGUg
dGhhdCB0aGVyZSBpcyBhbiBvYmplY3QgcmVmZXJlbmNlIGxlYWssIHRoZW4gcGxlYXNlCj4+IHBy
b3ZpZGUgdGhlIGRldGFpbHM6IGl0IGlzIGxpa2VseSBhIGJ1ZyBlbHNld2hlcmUgYW5kIG5vdCBp
biB0aGUgbm90aWZpZXIKPj4gY29kZS4KPj4KPj4gQlRXLCB5b3VyIHBhdGNoIHNlcmllcyBkaWRu
J3QgYXJyaXZlIG9uIHRoZSBsaW51eC1tZWRpYSBtYWlsaW5nbGlzdCBmb3IKPj4gc29tZSByZWFz
b24uCj4+Cj4+IFJlZ2FyZHMsCj4+Cj4+ICAgICAgIEhhbnMKPj4KPiAKPiAKCg==

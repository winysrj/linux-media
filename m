Return-Path: <SRS0=npIJ=QD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5BFC282CA
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 22:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DAEF2133D
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 22:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfA0W5s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 17:57:48 -0500
Received: from smtp-prod04.osg.ufl.edu ([128.227.74.220]:42182 "EHLO
        smtp.ufl.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbfA0W5s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 17:57:48 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2019 17:57:47 EST
X-UFL-GatorLink-Authenticated: authenticated as  () with  from 10.36.197.39
Received: from exmbxprd18.ad.ufl.edu ([10.36.197.39])
        by smtp.ufl.edu (8.14.4/8.14.4/3.0.0) with ESMTP id x0RMviLk048038
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT);
        Sun, 27 Jan 2019 17:57:44 -0500
Received: from exmbxprd18.ad.ufl.edu (10.36.197.39) by exmbxprd18.ad.ufl.edu
 (10.36.197.39) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Sun, 27 Jan
 2019 17:57:43 -0500
Received: from exmbxprd18.ad.ufl.edu ([fe80::890c:cba5:27b2:db27]) by
 exmbxprd18.ad.ufl.edu ([fe80::890c:cba5:27b2:db27%19]) with mapi id
 15.00.1395.000; Sun, 27 Jan 2019 17:57:43 -0500
From:   "Yavuz, Tuba" <tuba@ece.ufl.edu>
To:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
Subject: [PATCH] : media : hackrf : memory leak 
Thread-Topic: [PATCH] : media : hackrf : memory leak 
Thread-Index: AQHUtpOo0mjhSxBNJEyE9HSW4CLlIA==
Date:   Sun, 27 Jan 2019 22:57:43 +0000
Message-ID: <1548629863510.35899@ece.ufl.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.36.198.11]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-01-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=885
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901270184
X-UFL-Spam-Level: *
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

CiAgICAgCkR1ZSB0byBhIG1pc3NpbmcgdjRsMl9kZXZpY2VfZ2V0IGZ1bmN0aW9uIGluIHRoZSBo
YWNrcmZfcHJvYmUgZnVuY3Rpb24swqAKdGhlIHJlZmVyZW5jZSBjb3VudCBvZiB0aGUgdjRsMl9k
ZXZpY2Ugb2JqZWN0IHJlYWNoZXMgemVybyBpbnNpZGUgdGhlwqAKd3JvbmcgQVBJIGZ1bmN0aW9u
ICh2aWRlb191bnJlZ2lzdGVyX2RldmljZSkgaW5zdGVhZCBvZiB2NGwyX2RldmljZV9wdXQuwqAK
VGhpcyBjYXVzZXMgYSBtZW1vcnkgbGVhayBhcyB0aGUgcmVsZWFzZSBjYWxsYmFjayB3b3VsZCBu
b3QgZ2V0IGNhbGxlZC4KCgpSZXBvcnRlZC1ieTogVHViYSBZYXZ1eiA8dHViYUBlY2UudWZsLmVk
dT4KU2lnbmVkLW9mZi1ieTogVHViYSBZYXZ1eiA8dHViYUBlY2UudWZsLmVkdT4KLS0tCgoKLS0t
IGRyaXZlcnMvbWVkaWEvdXNiL2hhY2tyZi9oYWNrcmYuYy5vcmlnCTIwMTktMDEtMjYgMTE6Mzc6
MTguOTEyMjEwODIzIC0wNTAwCisrKyBkcml2ZXJzL21lZGlhL3VzYi9oYWNrcmYvaGFja3JmLmMJ
MjAxOS0wMS0yNyAxNzo1MDo0MS42NjA3MzY2ODggLTA1MDAKQEAgLTE1MjQsNiArMTUyNCw3IEBA
IHN0YXRpYyBpbnQgaGFja3JmX3Byb2JlKHN0cnVjdCB1c2JfaW50ZXIKwqAJCQkiRmFpbGVkIHRv
IHJlZ2lzdGVyIGFzIHZpZGVvIGRldmljZSAoJWQpXG4iLCByZXQpOwrCoAkJZ290byBlcnJfdmlk
ZW9fdW5yZWdpc3Rlcl9kZXZpY2Vfcng7CsKgCX0KKwl2NGwyX2RldmljZV9nZXQoJmRldi0+djRs
Ml9kZXYpOwrCoAlkZXZfaW5mbyhkZXYtPmRldiwgIlJlZ2lzdGVyZWQgYXMgJXNcbiIsCsKgCQkg
dmlkZW9fZGV2aWNlX25vZGVfbmFtZSgmZGV2LT50eF92ZGV2KSk74oCLCiA=

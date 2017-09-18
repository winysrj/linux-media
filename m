Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:19632 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750974AbdIRWAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 18:00:51 -0400
From: "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: RE: [PATCH v1] media: ov13858: Fix 4224x3136 video flickering at
 some vblanks
Date: Mon, 18 Sep 2017 22:00:46 +0000
Message-ID: <8408A4B5C50F354EA5F62D9FC805153D2C488118@ORSMSX115.amr.corp.intel.com>
References: <1505342325-9180-1-git-send-email-chiranjeevi.rapolu@intel.com>
 <CAAFQd5DOdQfS0Vj0SZ0PG+7dWpObca-5LS7amO0t-k4QyAcFSQ@mail.gmail.com>
In-Reply-To: <CAAFQd5DOdQfS0Vj0SZ0PG+7dWpObca-5LS7amO0t-k4QyAcFSQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgVG9tYXN6LA0KDQo+VGhlIGNoYW5nZSBvZiByZWdpc3RlciB2YWx1ZXMgaXRzZWxmIGRvZXNu
J3QgZ2l2ZSBhbnkgaW5mb3JtYXRpb24gYWJvdXQgd2hhdCBpcyBjaGFuZ2VkLiBDb3VsZCB5b3Ug
ZXhwbGFpbiB0aGUgZm9sbG93aW5nOg0KPi0gV2hhdCBpcyB0aGUgImNyb3AiIGluIHRoaXMgY2Fz
ZT8NCg0KVGhlIG5ldyBjcm9wIGlzICgwLDgpLCAoNDI1NSwgMzE1OSkuDQoNCj4tIFdoYXQgdmFs
dWUgd2FzIGl0IHNldCB0byBiZWZvcmUgYW5kIHdoeSB3YXMgaXQgd3Jvbmc/DQoNCk9sZCBjcm9w
IHdhcyAoMCwgMCksICg0MjU1LCAzMTY3KS4gV2l0aCB0aGlzIGNyb3AsIFZUUyA8IDB4QzlFIHdh
cyByZXN1bHRpbmcgaW4NCmJsYW5rIGZyYW1lcyBzb21ldGltZXMuIEJ1dCB3ZSBuZWVkIFZUUyA8
IDB4QzlFIHRvIGdldCB+MzBmcHMuDQoNCj4tIFdoYXQgaXMgdGhlIG5ldyB2YWx1ZSBhbmQgd2h5
IGlzIGl0IGdvb2Q/DQoNCldpdGggbmV3IGNyb3AgYXMgYWJvdmUsICBWVFMgMHhDOEUgaXMgc3Vw
cG9ydGVkIGFuZCB5aWVsZHMgfjMwZnBzLg0KDQpDaGlyYW4uDQo=

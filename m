Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44637 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726083AbeJPQeu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 12:34:50 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v4 12/12] ov5640: Enforce a mode change when changing the
 framerate
Date: Tue, 16 Oct 2018 08:45:12 +0000
Message-ID: <577aec7f-a637-524d-dc0b-d6f08890d884@st.com>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-13-maxime.ripard@bootlin.com>
 <45c2db62-b6b9-34a6-1e4b-16d622f8461a@st.com>
 <20181016071031.3xkjlzbmiiusrgsb@flea>
In-Reply-To: <20181016071031.3xkjlzbmiiusrgsb@flea>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9E2D1CB9AD50F4AAD20B79B2FA08865@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

WW91J3JlIHdlbGNvbWUgOykNCg0KT24gMTAvMTYvMjAxOCAwOToxMCBBTSwgTWF4aW1lIFJpcGFy
ZCB3cm90ZToNCj4gSGkgSHVndWVzLA0KPiANCj4gT24gTW9uLCBPY3QgMTUsIDIwMTggYXQgMDE6
NTc6NDBQTSArMDAwMCwgSHVndWVzIEZSVUNIRVQgd3JvdGU6DQo+PiBUaGlzIGlzIGFscmVhZHkg
Zml4ZWQgaW4gbWVkaWEgdHJlZToNCj4+IDA5Mjk5ODNlNDljODFjMWQ0MTM3MDJjZDliODNiYjA2
YzRhMjU1NWMgbWVkaWE6IG92NTY0MDogZml4IGZyYW1lcmF0ZSB1cGRhdGUNCj4gDQo+IE15IGJh
ZCB0aGVuLCBJIG1pc3NlZCBpdCwgdGhhbmtzIQ0KPiBNYXhpbWUNCj4g

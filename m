Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:63394 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751136AbeEHFkt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 01:40:49 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "jacopo@jmondi.org" <jacopo@jmondi.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: RE: [RESEND PATCH v9 1/2] media: dt-bindings: Add bindings for
 Dongwoon DW9807 voice coil
Date: Tue, 8 May 2018 05:36:48 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D595CB8@PGSMSX111.gar.corp.intel.com>
References: <1525276428-17379-1-git-send-email-andy.yeh@intel.com>
 <1525276428-17379-2-git-send-email-andy.yeh@intel.com>
 <20180502213637.ycvksj33edrkprpn@kekkonen.localdomain>
In-Reply-To: <20180502213637.ycvksj33edrkprpn@kekkonen.localdomain>
Content-Language: en-US
Content-Type: multipart/mixed;
        boundary="_002_8E0971CCB6EA9D41AF58191A2D3978B61D595CB8PGSMSX111garcor_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_8E0971CCB6EA9D41AF58191A2D3978B61D595CB8PGSMSX111garcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Dear reviewers,

As the dt-binding patch has been accepted, would any help set the driver pa=
tch be accepted too? Any missing action from my side blocked the process. T=
hanks in advance.=20

media: dw9807: Add dw9807 vcm driver
https://patchwork.linuxtv.org/patch/49159/

Regards, Andy

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]=20
Sent: Thursday, May 3, 2018 5:37 AM
To: Yeh, Andy <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org; devicetree@vger.kernel.org; tfiga@chromium=
.org; jacopo@jmondi.org; Chiang, AlanX <alanx.chiang@intel.com>
Subject: Re: [RESEND PATCH v9 1/2] media: dt-bindings: Add bindings for Don=
gwoon DW9807 voice coil

On Wed, May 02, 2018 at 11:53:47PM +0800, Andy Yeh wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
>=20
> Dongwoon DW9807 is a voice coil lens driver.
>=20
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

I don't remember seeing these two on the first patch nor giving mine. For w=
hat it's worth, I've applied v8 to my tree here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=3Dfor-4.18-3>

I.e. there's no need to resend the same patch to just add the regular acked=
-by or reviewed-by tags. "RESEND" in the subject suggests you're sending ex=
actly the same patch, and in that case the version would be unchanged as we=
ll.

> Acked-by: Rob Herring <robh@kernel.org>
>=20
> ---
>  Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 9=20
> +++++++++
>  1 file changed, 9 insertions(+)
>  create mode 100644=20
> Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
>=20
> diff --git=20
> a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt=20
> b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> new file mode 100644
> index 0000000..0a1a860
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
> @@ -0,0 +1,9 @@
> +Dongwoon Anatech DW9807 voice coil lens driver
> +
> +DW9807 is a 10-bit DAC with current sink capability. It is intended=20
> +for controlling voice coil lenses.
> +
> +Mandatory properties:
> +
> +- compatible: "dongwoon,dw9807"
> +- reg: I2C slave address

--
Sakari Ailus
sakari.ailus@linux.intel.com

--_002_8E0971CCB6EA9D41AF58191A2D3978B61D595CB8PGSMSX111garcor_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Tue, 08 May 2018 05:36:48 GMT";
	modification-date="Tue, 08 May 2018 05:36:48 GMT"

Received: from orsmsx103.amr.corp.intel.com (10.22.225.130) by
 PGSMSX110.gar.corp.intel.com (10.221.44.111) with Microsoft SMTP Server (TLS)
 id 14.3.319.2; Sat, 5 May 2018 23:51:12 +0800
Received: from orsmga005.jf.intel.com (10.7.209.41) by
 ORSMSX103-1.jf.intel.com (10.22.225.130) with Microsoft SMTP Server id
 14.3.319.2; Sat, 5 May 2018 08:51:09 -0700
Received: from orsmga106.jf.intel.com ([10.7.208.65])  by
 orsmga005-1.jf.intel.com with ESMTP; 05 May 2018 08:51:09 -0700
Received: from www.linuxtv.org ([130.149.80.248])  by mga18.intel.com with
 ESMTP/TLS/AES128-GCM-SHA256; 05 May 2018 08:51:05 -0700
Received: from localhost ([127.0.0.1] helo=www.linuxtv.org)	by www.linuxtv.org
 with esmtp (Exim 4.84_2)	(envelope-from <patchwork@linuxtv.org>)	id
 1fEzSg-0004pS-6d	for andy.yeh@intel.com; Sat, 05 May 2018 15:51:02 +0000
From: Patchwork <patchwork@linuxtv.org>
To: "Yeh, Andy" <andy.yeh@intel.com>
Subject: [linux-media] Patch notification: 3 patches updated
Thread-Topic: [linux-media] Patch notification: 3 patches updated
Thread-Index: AQHT5IjkjrFYliEsWUW3KcecUCa/qg==
Date: Sat, 5 May 2018 15:51:02 +0000
Message-ID: <20180505155102.18397.29471@www.linuxtv.org>
Content-Language: zh-TW
X-MS-Exchange-Organization-AuthSource: ORSMSX103.amr.corp.intel.com
X-MS-Has-Attach: 
X-Auto-Response-Suppress: All
X-MS-TNEF-Correlator: 
received-spf: None (mga18.intel.com: no sender authenticity  information
 available from domain of  postmaster@www.linuxtv.org) identity=helo;
  client-ip=130.149.80.248; receiver=mga18.intel.com;
  envelope-from="patchwork@linuxtv.org";
  x-sender="postmaster@www.linuxtv.org";
  x-conformance=sidf_compatible.downgrade_pra
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A406AC643C295418A55D421396F4AE9@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0

SGVsbG8sDQoNClRoZSBmb2xsb3dpbmcgcGF0Y2hlcyAoc3VibWl0dGVkIGJ5IHlvdSkgaGF2ZSBi
ZWVuIHVwZGF0ZWQgaW4gcGF0Y2h3b3JrOg0KDQogKiBsaW51eC1tZWRpYTogW1JFU0VORCx2OCwx
LzJdIG1lZGlhOiBkdC1iaW5kaW5nczogQWRkIGJpbmRpbmdzIGZvciBEb25nd29vbiBEVzk4MDcg
dm9pY2UgY29pbA0KICAgICAtIGh0dHA6Ly9wYXRjaHdvcmsubGludXh0di5vcmcvcGF0Y2gvNDkw
MjgvDQogICAgIC0gZm9yOiBMaW51eCBNZWRpYSBrZXJuZWwgcGF0Y2hlcw0KICAgIHdhczogTmV3
DQogICAgbm93OiBBY2NlcHRlZA0KDQogKiBsaW51eC1tZWRpYTogW1JFU0VORCx2OSwxLzJdIG1l
ZGlhOiBkdC1iaW5kaW5nczogQWRkIGJpbmRpbmdzIGZvciBEb25nd29vbiBEVzk4MDcgdm9pY2Ug
Y29pbA0KICAgICAtIGh0dHA6Ly9wYXRjaHdvcmsubGludXh0di5vcmcvcGF0Y2gvNDkxNTgvDQog
ICAgIC0gZm9yOiBMaW51eCBNZWRpYSBrZXJuZWwgcGF0Y2hlcw0KICAgIHdhczogTmV3DQogICAg
bm93OiBBY2NlcHRlZA0KDQogKiBsaW51eC1tZWRpYTogUkVTRU5EW1BBVENIIHY2IDEvMl0gbWVk
aWE6IGR0LWJpbmRpbmdzOiBBZGQgYmluZGluZ3MgZm9yIERvbmd3b29uIERXOTgwNyB2b2ljZSBj
b2lsDQogICAgIC0gaHR0cDovL3BhdGNod29yay5saW51eHR2Lm9yZy9wYXRjaC80Nzk3OS8NCiAg
ICAgLSBmb3I6IExpbnV4IE1lZGlhIGtlcm5lbCBwYXRjaGVzDQogICAgd2FzOiBOZXcNCiAgICBu
b3c6IEFjY2VwdGVkDQoNClRoaXMgZW1haWwgaXMgYSBub3RpZmljYXRpb24gb25seSAtIHlvdSBk
byBub3QgbmVlZCB0byByZXNwb25kLg0KDQotDQoNClBhdGNoZXMgc3VibWl0dGVkIHRvIGxpbnV4
LW1lZGlhQHZnZXIua2VybmVsLm9yZyBoYXZlIHRoZSBmb2xsb3dpbmcNCnBvc3NpYmxlIHN0YXRl
czoNCg0KTmV3OiBQYXRjaGVzIG5vdCB5ZXQgcmV2aWV3ZWQgKHR5cGljYWxseSBuZXcgcGF0Y2hl
cyk7DQoNClVuZGVyIHJldmlldzogV2hlbiBpdCBpcyBleHBlY3RlZCB0aGF0IHNvbWVvbmUgaXMg
cmV2aWV3aW5nIGl0ICh0eXBpY2FsbHksDQogICAgICAgICAgICAgIHRoZSBkcml2ZXIncyBhdXRo
b3Igb3IgbWFpbnRhaW5lcikuIFVuZm9ydHVuYXRlbHksIHBhdGNod29yaw0KICAgICAgICAgICAg
ICBkb2Vzbid0IGhhdmUgYSBmaWVsZCB0byBpbmRpY2F0ZSB3aG8gaXMgdGhlIGRyaXZlciBtYWlu
dGFpbmVyLg0KICAgICAgICAgICAgICBJZiBpbiBkb3VidCBhYm91dCB3aG8gaXMgdGhlIGRyaXZl
ciBtYWludGFpbmVyIHBsZWFzZSBjaGVjayB0aGUNCiAgICAgICAgICAgICAgTUFJTlRBSU5FUlMg
ZmlsZSBvciBhc2sgYXQgdGhlIE1MOw0KDQpTdXBlcnNlZGVkOiB3aGVuIHRoZSBzYW1lIHBhdGNo
IGlzIHNlbnQgdHdpY2UsIG9yIGEgbmV3IHZlcnNpb24gb2YgdGhlDQogICAgICAgICAgICBzYW1l
IHBhdGNoIGlzIHNlbnQsIGFuZCB0aGUgbWFpbnRhaW5lciBpZGVudGlmaWVkIGl0LCB0aGUgZmly
c3QNCiAgICAgICAgICAgIHZlcnNpb24gaXMgbWFya2VkIGFzIHN1Y2guIEl0IGlzIGFsc28gdXNl
ZCB3aGVuIGEgcGF0Y2ggd2FzDQogICAgICAgICAgICBzdXBlcnNlZWRlZCBieSBhIGdpdCBwdWxs
IHJlcXVlc3QuDQoNCk9ic29sZXRlZDogcGF0Y2ggZG9lc24ndCBhcHBseSBhbnltb3JlLCBiZWNh
dXNlIHRoZSBtb2RpZmllZCBjb2RlIGRvZXNuJ3QNCiAgICAgICAgICAgZXhpc3QgYW55bW9yZS4N
Cg0KQ2hhbmdlcyByZXF1ZXN0ZWQ6IHdoZW4gc29tZW9uZSByZXF1ZXN0cyBjaGFuZ2VzIG9mIHRo
ZSBwYXRjaDsNCg0KUmVqZWN0ZWQ6IFdoZW4gdGhlIHBhdGNoIGlzIHdyb25nIG9yIGRvZXNuJ3Qg
YXBwbHkuIE1vc3Qgb2YgdGhlDQogICAgICAgICAgdGltZSwgJ3JlamVjdGVkJyBhbmQgJ2NoYW5n
ZXMgcmVxdWVzdGVkJyBtZWFucyB0aGUgc2FtZSB0aGluZw0KICAgICAgICAgIGZvciB0aGUgZGV2
ZWxvcGVyOiBoZSdsbCBuZWVkIHRvIHJlLXdvcmsgb24gdGhlIHBhdGNoLg0KDQpSRkM6IHBhdGNo
ZXMgbWFya2VkIGFzIHN1Y2ggYW5kIG90aGVyIHBhdGNoZXMgdGhhdCBhcmUgYWxzbyBSRkMsIGJ1
dCB0aGUNCiAgICAgcGF0Y2ggYXV0aG9yIHdhcyBub3QgbmljZSBlbm91Z2ggdG8gbWFyayB0aGVt
IGFzIHN1Y2guIFRoYXQgaW5jbHVkZXM6DQogICAgICAgIC0gcGF0Y2hlcyBzZW50IGJ5IGEgZHJp
dmVyJ3MgbWFpbnRhaW5lciB3aG8gc2VuZCBwYXRjaGVzDQogICAgICAgICAgdmlhIGdpdCBwdWxs
IHJlcXVlc3RzOw0KICAgICAgICAtIHBhdGNoZXMgd2l0aCBhIHZlcnkgYWN0aXZlIGNvbW11bml0
eSAodHlwaWNhbGx5IGZyb20gZGV2ZWxvcGVycw0KICAgICAgICAgIHdvcmtpbmcgd2l0aCBlbWJl
ZGRlZCBkZXZpY2VzKSwgd2hlcmUgbG90cyBvZiB2ZXJzaW9ucyBhcmUNCiAgICAgICAgICBuZWVk
ZWQgZm9yIHRoZSBkcml2ZXIgbWFpbnRhaW5lciBhbmQvb3IgdGhlIGNvbW11bml0eSB0byBiZQ0K
ICAgICAgICAgIGhhcHB5IHdpdGguDQoNClRPRE86IEEgdmFyaWFudCBvZiBSRkMuIEl0IGtlZXBz
IHRoZSBwYXRjaCB2aXNpYmxlIGF0IHBhdGNod29yayBtYWluDQogICAgICAgIHNjcmVlbiwgYWxs
b3dpbmcgdG8gYmV0dGVyIHRyYWNrIGl0Lg0KDQpOb3QgQXBwbGljYWJsZTogZm9yIHBhdGNoZXMg
dGhhdCBhcmVuJ3QgbWVhbnQgdG8gYmUgYXBwbGllZCB2aWENCiAgICAgICAgICAgICAgICB0aGUg
bWVkaWEtdHJlZS5naXQuDQoNCkFjY2VwdGVkOiB3aGVuIHNvbWUgZHJpdmVyIG1haW50YWluZXIg
c2F5cyB0aGF0IHRoZSBwYXRjaCB3aWxsIGJlIGFwcGxpZWQNCiAgICAgICAgICB2aWEgaGlzIHRy
ZWUsIG9yIHdoZW4gZXZlcnl0aGluZyBpcyBvayBhbmQgaXQgZ290IGFwcGxpZWQNCiAgICAgICAg
ICBlaXRoZXIgYXQgdGhlIG1haW4gdHJlZSBvciB2aWEgc29tZSBvdGhlciB0cmVlIChmaXhlcyB0
cmVlOw0KICAgICAgICAgIHNvbWUgb3RoZXIgbWFpbnRhaW5lcidzIHRyZWUgLSB3aGVuIGl0IGJl
bG9uZ3MgdG8gb3RoZXIgc3Vic3lzdGVtcywNCiAgICAgICAgICBldGMpOw0KDQpJZiB5b3UgdGhp
bmsgYW55IHN0YXR1cyBjaGFuZ2UgaXMgYSBtaXN0YWtlLCBwbGVhc2Ugc2VuZCBhbiBlbWFpbCB0
byB0aGUgTUwuDQoNCi0NCg0KVGhpcyBpcyBhbiBhdXRvbWF0ZWQgbWFpbCBzZW50IGJ5IHRoZSBw
YXRjaHdvcmsgc3lzdGVtIGF0DQpwYXRjaHdvcmsubGludXh0di5vcmcuIFRvIHN0b3AgcmVjZWl2
aW5nIHRoZXNlIG5vdGlmaWNhdGlvbnMsIGVkaXQNCnlvdXIgbWFpbCBzZXR0aW5ncyBhdDoNCiAg
aHR0cDovL3BhdGNod29yay5saW51eHR2Lm9yZy9tYWlsLw0K

--_002_8E0971CCB6EA9D41AF58191A2D3978B61D595CB8PGSMSX111garcor_--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:45630 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdJLJwJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 05:52:09 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Henrik Austad <haustad@cisco.com>,
        "Martin Bugge (marbugge)" <marbugge@cisco.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
 <d5034d03-1ef4-0253-0efc-ae7fd5cb09e9@ti.com>
 <9f921701-910c-d749-378c-038e8405f656@xs4all.nl>
 <f5d93c33-7825-1034-a605-ee38c796ca20@ti.com>
 <185e0c6e-8776-67e3-363f-fe9ebef3ba29@xs4all.nl>
 <2799bcc5-df51-e977-b3c0-22922f59fc39@ti.com>
 <97ea6ac0-cc7a-b5a8-6e8e-5a3a9e52a463@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <d8ba4946-7549-2d17-f8d7-719e1796d636@ti.com>
Date: Thu, 12 Oct 2017 12:52:03 +0300
MIME-Version: 1.0
In-Reply-To: <97ea6ac0-cc7a-b5a8-6e8e-5a3a9e52a463@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=EF=BB=BF
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Bu=
siness ID: 0615521-4. Kotipaikka/Domicile: Helsinki

On 12/10/17 12:42, Hans Verkuil wrote:
> On 10/12/17 10:03, Tomi Valkeinen wrote:
>>
>> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus=
/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
>>
>> On 12/10/17 09:50, Hans Verkuil wrote:
>>
>>>> I can't test with a TV, so no CEC for me... But otherwise I think the
>>>> series works ok now, and looks ok. So I'll apply, but it's a bit late
>>>> for the next merge window, so I'll aim for 4.15 with this.
>>>
>>> What is the status? Do you need anything from me? I'd like to get this =
in for 4.15.
>>
>> Thanks for reminding. I think I would've forgotten...
>>
>> I sent the pull request, so all should be fine.
>>
>> If possible, please test the pull request, preferably with drm-next
>> merged (git://people.freedesktop.org/~airlied/linux drm-next), as I
>> don't have a CEC capable display.
>=20
> I'll try to do that tomorrow or Monday.
>=20
> I have one other question for you: does keeping ls_oe_gpio high all the
> time affect this old bug fix:
>=20
> https://github.com/myfluxi/xxICSKernel/commit/21189f03d3ec3a74d9949907c82=
8410d7a9a86d5

No, the issue is about the HDMI PHY. The i2c lines are not related.
LS_OE only affects the i2c.

> I don't think so, but I'm not 100% sure. As far as I can see the PHY powe=
r
> sequence (OFF, TXON, LDOON) does not change and that seems to be the
> crucial fix according to the commit above.
>=20
> I would hate being responsible for lots of burnt-out pandaboards :-)
>=20
> There is an alternative solution: when there is no HPD then it is also
> possible to pull the ls_oe_gpio high only when transmitting a CEC message=
.
>=20
> That would obviously require some code changes.
>=20
> Sorry for raising this issue so late, but this just came up today in
> internal discussions.

Well, it would be nice to not have LS_OE enabled all the time. But I'm
not sure how much that really matters. I'm sure it uses some power, but
is that even measurable, I have no idea.

 Tomi

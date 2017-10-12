Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:65406 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdJLIEB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 04:04:01 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
 <d5034d03-1ef4-0253-0efc-ae7fd5cb09e9@ti.com>
 <9f921701-910c-d749-378c-038e8405f656@xs4all.nl>
 <f5d93c33-7825-1034-a605-ee38c796ca20@ti.com>
 <185e0c6e-8776-67e3-363f-fe9ebef3ba29@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <2799bcc5-df51-e977-b3c0-22922f59fc39@ti.com>
Date: Thu, 12 Oct 2017 11:03:56 +0300
MIME-Version: 1.0
In-Reply-To: <185e0c6e-8776-67e3-363f-fe9ebef3ba29@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=EF=BB=BF
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Bu=
siness ID: 0615521-4. Kotipaikka/Domicile: Helsinki

On 12/10/17 09:50, Hans Verkuil wrote:

>> I can't test with a TV, so no CEC for me... But otherwise I think the
>> series works ok now, and looks ok. So I'll apply, but it's a bit late
>> for the next merge window, so I'll aim for 4.15 with this.
>=20
> What is the status? Do you need anything from me? I'd like to get this in=
 for 4.15.

Thanks for reminding. I think I would've forgotten...

I sent the pull request, so all should be fine.

If possible, please test the pull request, preferably with drm-next
merged (git://people.freedesktop.org/~airlied/linux drm-next), as I
don't have a CEC capable display.

 Tomi

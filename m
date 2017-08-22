Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:11967 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932305AbdHVJoX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 05:44:23 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
 <d5034d03-1ef4-0253-0efc-ae7fd5cb09e9@ti.com>
 <9f921701-910c-d749-378c-038e8405f656@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <f5d93c33-7825-1034-a605-ee38c796ca20@ti.com>
Date: Tue, 22 Aug 2017 12:44:16 +0300
MIME-Version: 1.0
In-Reply-To: <9f921701-910c-d749-378c-038e8405f656@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=EF=BB=BFHi Hans,

>>=20
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Bu=
siness ID: 0615521-4. Kotipaikka/Domicile: Helsinki

On 11/08/17 13:57, Tomi Valkeinen wrote:
>>
>>> I'm doing some testing with this series on my panda. One issue I see is
>>> that when I unload the display modules, I get:
>>>
>>> [   75.180206] platform 58006000.encoder: enabled after unload, idling
>>> [   75.187896] platform 58001000.dispc: enabled after unload, idling
>>> [   75.198242] platform 58000000.dss: enabled after unload, idling
>>
>> This one is caused by hdmi_cec_adap_enable() never getting called with
>> enable=3Dfalse when unloading the modules. Should that be called
>> explicitly in hdmi4_cec_uninit, or is the CEC framework supposed to call=
 it?
>=20
> Nicely found!
>=20
> The cec_delete_adapter() function calls __cec_s_phys_addr(CEC_PHYS_ADDR_I=
NVALID)
> which would normally call adap_enable(false), except when the device node=
 was
> already unregistered, in which case it just returns immediately.
>=20
> The patch below should fix this. Let me know if it works, and I'll post a=
 proper
> patch and get that in for 4.14 (and possible backported as well, I'll hav=
e to
> look at that).

Thanks, this fixes the issue.

I again saw "HDMICORE: omapdss HDMICORE error: operation stopped when
reading edid" when I loaded the modules. My panda also froze just now
when unloading the display modules, and it doesn't react to sysrq.

After testing a bit without the CEC patches, I saw the above error, so I
don't think it's related to your patches.

I can't test with a TV, so no CEC for me... But otherwise I think the
series works ok now, and looks ok. So I'll apply, but it's a bit late
for the next merge window, so I'll aim for 4.15 with this.

 Tomi

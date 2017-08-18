Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:13220 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdHRJCa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 05:02:30 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
Message-ID: <d5034d03-1ef4-0253-0efc-ae7fd5cb09e9@ti.com>
Date: Fri, 18 Aug 2017 12:02:24 +0300
MIME-Version: 1.0
In-Reply-To: <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=EF=BB=BFHi Hans,


Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Bu=
siness ID: 0615521-4. Kotipaikka/Domicile: Helsinki

On 11/08/17 13:57, Tomi Valkeinen wrote:

> I'm doing some testing with this series on my panda. One issue I see is
> that when I unload the display modules, I get:
>=20
> [   75.180206] platform 58006000.encoder: enabled after unload, idling
> [   75.187896] platform 58001000.dispc: enabled after unload, idling
> [   75.198242] platform 58000000.dss: enabled after unload, idling

This one is caused by hdmi_cec_adap_enable() never getting called with
enable=3Dfalse when unloading the modules. Should that be called
explicitly in hdmi4_cec_uninit, or is the CEC framework supposed to call it=
?

 Tomi

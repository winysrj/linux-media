Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:27259 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752812AbdHKK6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 06:58:05 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
Date: Fri, 11 Aug 2017 13:57:18 +0300
MIME-Version: 1.0
In-Reply-To: <20170802085408.16204-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=EF=BB=BFHi Hans,


Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Bu=
siness ID: 0615521-4. Kotipaikka/Domicile: Helsinki

On 02/08/17 11:53, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This patch series adds CEC support for the omap4. It is based on
> the 4.13-rc2 kernel with this patch series applied:
>=20
> http://www.spinics.net/lists/dri-devel/msg143440.html
>=20
> It is virtually identical to the first patch series posted in
> April:
>=20
> http://www.spinics.net/lists/dri-devel/msg138950.html
>=20
> The only two changes are in the Kconfig due to CEC Kconfig
> changes in 4.13 (it now selects CEC_CORE instead of depending on
> CEC_CORE) and a final patch was added adding a lost_hotplug op
> since for proper CEC support I have to know when the hotplug
> signal goes away.
>=20
> Tested with my Pandaboard.

I'm doing some testing with this series on my panda. One issue I see is
that when I unload the display modules, I get:

[   75.180206] platform 58006000.encoder: enabled after unload, idling
[   75.187896] platform 58001000.dispc: enabled after unload, idling
[   75.198242] platform 58000000.dss: enabled after unload, idling

So I think something is left enabled, most likely in the HDMI driver. I
haven't debugged this yet.

The first time I loaded the modules I also got "operation stopped when
reading edid", but I haven't seen that since. Possibly not related to
this series.

Are there some simple ways to test the CEC? My buildroot fs has
cec-compliance, cec-ctl and cec-follower commands. Are you familiar with
those? Can they be used?

 Tomi

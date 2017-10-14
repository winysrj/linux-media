Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59889 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753026AbdJNNsN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Oct 2017 09:48:13 -0400
Subject: Re: [PATCHv4 0/4] tegra-cec: add Tegra HDMI CEC support
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <9314614a-446d-b76d-640b-033cc74e3879@xs4all.nl>
 <20171014133410.GA13205@ulmo>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f3c8aa19-fc13-63fc-724b-1200ce7ce090@xs4all.nl>
Date: Sat, 14 Oct 2017 15:48:08 +0200
MIME-Version: 1.0
In-Reply-To: <20171014133410.GA13205@ulmo>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/2017 03:34 PM, Thierry Reding wrote:
> On Sat, Oct 14, 2017 at 02:08:31PM +0200, Hans Verkuil wrote:
>> Hi Thierry,
>>
>> On 09/11/2017 02:29 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> This patch series adds support for the Tegra CEC functionality.
>>>
>>> This v4 has been rebased to the latest 4.14 pre-rc1 mainline.
>>>
>>> Please review! Other than for the bindings that are now Acked I have not
>>> received any feedback.
>>
>> Can you or someone else from the Tegra maintainers review this?
>>
>> I have not heard anything about this patch series, nor of the previous
>> versions of this series. What's the hold-up?
> 
> Sorry about that. I've been meaning to look at this for a while now, but
> never got around to it. From a quick glance this looks good. Let me take
> this for a quick test-drive when I'm back at the office next week and
> I'll report back.

It would be great if you can test if the TK1 dts changes will also work
with the Jetson X1. It should, but I don't have a Jetson X1 to test with.

> Is there any particular ordering that we need to observe in order to
> merge this? Looks to me like it would be safe to merge patches 1 and 3
> through the CEC (media?) tree and take the others through DRM and Tegra
> separately without breaking anything.

Correct. Once I have your Ack I can make a pull request for patches 1+3.
Patches 2+4 would have to go through you.

Regards,

	Hans

> 
> Thierry
> 
>>> The first patch documents the CEC bindings, the second adds support
>>> for this to tegra124.dtsi and enables it for the Jetson TK1.
>>>
>>> The third patch adds the CEC driver itself and the final patch adds
>>> the cec notifier support to the drm/tegra driver in order to notify
>>> the CEC driver whenever the physical address changes.
>>>
>>> I expect that the dts changes apply as well to the Tegra X1/X2 and possibly
>>> other Tegra SoCs, but I can only test this with my Jetson TK1 board.
>>>
>>> The dt-bindings and the tegra-cec driver would go in through the media
>>> subsystem, the drm/tegra part through the drm subsystem and the dts
>>> changes through (I guess) the linux-tegra developers. Luckily they are
>>> all independent of one another.
>>>
>>> To test this you need the CEC utilities from git://linuxtv.org/v4l-utils.git.
>>>
>>> To build this:
>>>
>>> git clone git://linuxtv.org/v4l-utils.git
>>> cd v4l-utils
>>> ./bootstrap.sh; ./configure
>>> make
>>> sudo make install # optional, you really only need utils/cec*
>>>
>>> To test:
>>>
>>> cec-ctl --playback # configure as playback device
>>> cec-ctl -S # detect all connected CEC devices
>>>
>>> See here for the public CEC API:
>>>
>>> https://hverkuil.home.xs4all.nl/spec/uapi/cec/cec-api.html
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>> Changes since v3:
>>>
>>> - Use the new CEC_CAP_DEFAULTS define
>>> - Use IS_ERR(cec->adap) instead of IS_ERR_OR_NULL(cec->adap)
>>>   (cec_allocate_adapter never returns a NULL pointer)
>>> - Drop the device_init_wakeup: wakeup is not (yet) supported by
>>>   the CEC framework and I have never tested it.
>>>
>>> Hans Verkuil (4):
>>>   dt-bindings: document the tegra CEC bindings
>>>   ARM: tegra: add CEC support to tegra124.dtsi
>>>   tegra-cec: add Tegra HDMI CEC driver
>>>   drm/tegra: add cec-notifier support
>>>
>>>  .../devicetree/bindings/media/tegra-cec.txt        |  27 ++
>>>  MAINTAINERS                                        |   8 +
>>>  arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   4 +
>>>  arch/arm/boot/dts/tegra124.dtsi                    |  12 +-
>>>  drivers/gpu/drm/tegra/Kconfig                      |   1 +
>>>  drivers/gpu/drm/tegra/drm.h                        |   3 +
>>>  drivers/gpu/drm/tegra/hdmi.c                       |   9 +
>>>  drivers/gpu/drm/tegra/output.c                     |   6 +
>>>  drivers/media/platform/Kconfig                     |  11 +
>>>  drivers/media/platform/Makefile                    |   2 +
>>>  drivers/media/platform/tegra-cec/Makefile          |   1 +
>>>  drivers/media/platform/tegra-cec/tegra_cec.c       | 501 +++++++++++++++++++++
>>>  drivers/media/platform/tegra-cec/tegra_cec.h       | 127 ++++++
>>>  13 files changed, 711 insertions(+), 1 deletion(-)
>>>  create mode 100644 Documentation/devicetree/bindings/media/tegra-cec.txt
>>>  create mode 100644 drivers/media/platform/tegra-cec/Makefile
>>>  create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.c
>>>  create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.h
>>>
>>

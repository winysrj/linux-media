Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58229 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936424AbdEYPGf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 11:06:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [RFC PATCH 0/7] drm/i915: add support for DisplayPort CEC-Tunneling-over-AUX
Date: Thu, 25 May 2017 17:06:19 +0200
Message-Id: <20170525150626.29748-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
protocol.

This patch series is based on v4.12-rc2.

The first four patches add support for a new CEC capability which is
needed for these devices and for two helper functions.

Then the DP CEC registers are added using Clint's patch.

The core CEC tunneling support is added to drm_dp_cec.c.

And finally this is hooked up in the i915 driver.

Ideally the cec driver is created and destroyed whenever the DP-to-HDMI
adapter is connected/disconnected, but I have not been a able to find
a way to distinguish between connecting/disconnecting the HDMI cable
and connecting/disconnecting the actual DP-to-HDMI adapter.

My current approach is to check the CEC tunneling support whenever a new
display is connected:

- if CEC tunneling is supported, but no CEC adapter exists, then create one.
- if CEC tunneling is not supported, then unregister the CEC adapter if one
  was created earlier.
- if CEC tunneling is supported and the capabilities are identical to the
  existing CEC adapter, then leave it be.
- if CEC tunneling is supported and the capabilities are different to the
  existing CEC adapter, then unregister that CEC adapter and register a
  new one.

This works well, but it would be much nicer if I would just know when the
DP adapter is disconnected as opposed to when the HDMI cable is disconnected
from the adapter. Suggestions are welcome.

The other remaining problem is that there are DP/USB-C to HDMI adapters that
support CEC tunneling in the chipset, but where the CEC pin is simply never
hooked up. From the point of view of the driver CEC is supported, but you'll
never see any other devices.

I am considering sending a CEC POLL message to logical address 0 (the TV)
to detect if the CEC pin is connected, but this is not 100% guaranteed to
work. This can be put under a kernel config option, though.

I think I need to do something for this since of the 5 USB-C to HDMI
adapters I've tested that set the CEC tunneling capability, only 2 have
the CEC pin hooked up. So this seems to be quite common.

I have tested this with my Intel NUC7i5BNK and with the two working
USB-C to HDMI adapters that I have found:

a Samsung EE-PW700 adapter and a Kramer ADC-U31C/HF adapter (I think that's
the model, I need to confirm this).

As usual the specifications of these adapters never, ever tell you whether
this is supported or not :-( It's trial and error to find one that works. In
fact, of the 10 USB-C to HDMI adapters I tested 5 didn't support CEC tunneling
at all, and of the remaining 5 only two had the CEC pin hooked up and so
actually worked.

BTW, all adapters that supported CEC tunneling used the Parade PS176 chip.

Output of cec-ctl -S (discovers the CEC topology):

$ cec-ctl -S
Driver Info:
        Driver Name                : i915
        Adapter Name               : DPDDC-C
        Capabilities               : 0x0000007e
                Logical Addresses
                Transmit
                Passthrough
                Remote Control Support
                Monitor All
        Driver version             : 4.12.0
        Available Logical Addresses: 4
        Physical Address           : 3.0.0.0
        Logical Address Mask       : 0x0010
        CEC Version                : 2.0
        Vendor ID                  : 0x000c03 (HDMI)
        OSD Name                   : 'Playback'
        Logical Addresses          : 1 (Allow RC Passthrough)

          Logical Address          : 4 (Playback Device 1)
            Primary Device Type    : Playback
            Logical Address Type   : Playback
            All Device Types       : Playback
            RC TV Profile          : None
            Device Features        :
                None

        System Information for device 0 (TV) from device 4 (Playback Device 1):
                CEC Version                : 1.4
                Physical Address           : 0.0.0.0
                Primary Device Type        : TV
                Vendor ID                  : 0x0000f0 (Samsung)
                OSD Name                   : TV
                Menu Language              : eng
                Power Status               : On

        Topology:

        0.0.0.0: TV
            3.0.0.0: Playback Device 1

Regards,

	Hans

Clint Taylor (1):
  drm/cec: Add CEC over Aux register definitions

Hans Verkuil (6):
  cec: add CEC_CAP_NEEDS_HPD
  cec-ioc-adap-g-caps.rst: document CEC_CAP_NEEDS_HPD
  cec: add cec_s_phys_addr_from_edid helper function
  cec: add cec_phys_addr_invalidate() helper function
  drm: add support for DisplayPort CEC-Tunneling-over-AUX
  drm/i915: add DisplayPort CEC-Tunneling-over-AUX support

 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   8 +
 drivers/gpu/drm/Kconfig                            |   3 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/drm_dp_cec.c                       | 196 +++++++++++++++++++++
 drivers/gpu/drm/i915/Kconfig                       |  11 ++
 drivers/gpu/drm/i915/intel_dp.c                    |  46 ++++-
 drivers/media/cec/cec-adap.c                       |  34 +++-
 drivers/media/cec/cec-api.c                        |   5 +-
 drivers/media/cec/cec-core.c                       |   1 +
 include/drm/drm_dp_helper.h                        |  83 +++++++++
 include/media/cec.h                                |  15 ++
 include/uapi/linux/cec.h                           |   2 +
 12 files changed, 394 insertions(+), 11 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_dp_cec.c

-- 
2.11.0

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:53546 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbeH0Lnz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 07:43:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>
Subject: [PATCHv2 0/5] drm/nouveau+amdgpu: add DP CEC-Tunneling-over-AUX
Date: Mon, 27 Aug 2018 09:58:15 +0200
Message-Id: <20180827075820.41109-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that the DisplayPort CEC-Tunneling-over-AUX drm+i915 support
has been merged in the mainline kernel it is time to roll this
out to nouveau and amdgpu as well.

The first patch is required for this: it adds checks that the drm_dp_cec
functions are called with a working aux implementation. These checks
weren't necessary for the i915, but nouveau and amdgpu require them.

The next two patches update a comment in drm_dp_cec.c and fix a bug
in sideband AUX handling that I found while researching CEC Tunneling
over an MST hub. It's there to prevent others from stumbling over the
same bug in the future.

The fourth patch adds support for CEC to the nouveau driver.

The last patch adds support for CEC to the amdgpu driver. CEC is
only supported for the new DC modesetting code (thanks to Alex Deucher
for explaining this to me). I have no plans to add CEC support to the
old modesetting code (amd/amdgpu/dce*.c). If someone wants to, then
please contact me. I can't test this myself, but I can assist.

Changes since v1:

- Added Acks/Reviewed-by tags
- Removed a spurious non-functional change in patch 5 as pointed out by
  Harry Wentland.

Two notes on CEC-Tunneling-over-AUX:

1) You need to be very careful about which USB-C/DP/mini-DP to HDMI
   adapters you buy. Only a few support this feature correctly today.
   Known chipsets that support this are Parade PS175 & PS176 and
   MegaChips 2900. Unfortunately almost all Parade-based adapters
   do not hook up the HDMI CEC pin to the chip, making them useless
   for this. The Parade reference design was only recently changed
   to hook up this pin, so perhaps this situation will change for
   new Parade-based adapters.

   Adapters based on the new MegaChips 2900 fare much better: it
   appears that their reference design *does* hook up the CEC pin.
   Club3D has adapters using this device for USB-C, DP and mini-DP
   to HDMI, and they all work fine.

   If anyone finds other adapters that work besides those I list
   in https://hverkuil.home.xs4all.nl/cec-status.txt, please let
   me know and I'll add them to the list.

   Linux is the first OS that supports this feature, so I am
   not surprised that HW support for this has been poor. Hopefully
   this will change going forward. BTW, note the irony that CEC is
   now supported for DP-to-HDMI adapters, but not for the native
   HDMI ports on NVIDIA/AMD/Intel GPUs.

2) CEC-Tunneling does not work (yet?) if there is an MST hub in
   between. I'm still researching this but this might be a limitation 
   of MST.

Regards,

        Hans

PS: I've requested committer rights to drm-misc, so hopefully I can
commit this series myself.

Hans Verkuil (5):
  drm_dp_cec: check that aux has a transfer function
  drm_dp_cec: add note about good MegaChips 2900 CEC support
  drm_dp_mst_topology: fix broken
    drm_dp_sideband_parse_remote_dpcd_read()
  drm/nouveau: add DisplayPort CEC-Tunneling-over-AUX support
  drm/amdgpu: add DisplayPort CEC-Tunneling-over-AUX support

 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  9 ++++++++-
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c    |  2 ++
 drivers/gpu/drm/drm_dp_cec.c                   | 18 +++++++++++++++++-
 drivers/gpu/drm/drm_dp_mst_topology.c          |  1 +
 drivers/gpu/drm/nouveau/nouveau_connector.c    | 17 +++++++++++++++--
 5 files changed, 43 insertions(+), 4 deletions(-)

-- 
2.18.0

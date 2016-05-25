Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:35796 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbcEYTTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 15:19:51 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/8] rcar-vin: Enable Gen3 support
Date: Wed, 25 May 2016 21:10:01 +0200
Message-Id: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Hi,

This series enable Gen3 support for the rcar-vin driver. It is based on 
top of the media_tree:

git://linuxtv.org/media_tree.git master

And it depends on the first rcar-vin patch at which I hope soon will 
enter the media tree:

https://patchwork.linuxtv.org/patch/34129/

This is a rather large patch since unfortunately the subdevice and input 
selection on Gen3 are much more complex than on Gen2, see individual 
patches for a more detailed explanation.

- Patch 1-3 picks up work done by Ulrich so that effort is not wasted 
  before the driver is updated for Gen3.
- Patch 4-6 are the big patches where the driver learns how to work with 
  Gen3.
- Patch 7-8 add compatible strings for Gen3 and fallback strings that 
  are present in the old soc-camera driver but not in this new driver.

The series is tested on Koelsch for Gen2 and it works as expected. If 
one wants to test the HDMI input the patch 'r8a7791-koelsch.dts: add 
HDMI input' from Hans Verkuil are needed to add it to DT . The driver 
passes a v4l2-compliance on Gen2 without errors or warnings.  And there 
are no problems grabbing frames using the CVBS or HDMI input sources 
using qv4l2.

For Gen3 there are more drivers needed to get working video input 
running. To be able to grab frames drivers are needed for the R-Car 
CSI-2 interface and the ADV7482 devices which are not yet present in the 
kernel. Prototypes for thees two drivers exist and a wiki page at 
http://elinux.org/R-Car/Tests:rcar-vin talks about how to test it all 
together.

Whit thees prototype drivers for CSI-2 and ADV7482 the rcar-vin driver 
pass the v4l2-compliance tool without errors or warnings on CVBS inputs.  
On HDMI inputs it complains about missing DV features, this is because 
the prototype ADV7482 do not yet implement thees operations and are not 
a fault in the rcar-vin driver.

Disregarding the v4l2-compliance result there is no issue grabbing 
frames from both CVBS and HDMI input sources on Salvator-X. But more 
work is needed on the prototype drivers before they are ready to be 
submitted for upstream.

Niklas Söderlund (5):
  [media] rcar-vin: allow subdevices to be bound late
  [media] rcar-vin: add Gen3 HW registers
  [media] rcar-vin: add shared subdevice groups
  [media] rcar-vin: enable Gen3
  [media] rcar-vin: add Gen2 and Gen3 fallback compatibility strings

Ulrich Hecht (3):
  media: rcar-vin: pad-aware driver initialisation
  media: rcar_vin: Use correct pad number in try_fmt
  media: rcar-vin: add DV timings support

 .../devicetree/bindings/media/rcar_vin.txt         |  218 +++-
 drivers/media/platform/rcar-vin/Kconfig            |    2 +-
 drivers/media/platform/rcar-vin/Makefile           |    2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |  474 ++++++---
 drivers/media/platform/rcar-vin/rcar-dma.c         |  202 +++-
 drivers/media/platform/rcar-vin/rcar-group.c       | 1122 ++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-group.h       |  139 +++
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  449 ++++----
 drivers/media/platform/rcar-vin/rcar-vin.h         |   83 +-
 9 files changed, 2253 insertions(+), 438 deletions(-)
 create mode 100644 drivers/media/platform/rcar-vin/rcar-group.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-group.h

-- 
2.8.2


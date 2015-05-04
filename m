Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8878 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbEDRfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 13:35:03 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Kamil Debski' <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
In-reply-to: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
Subject: RE: [PATCH v6 00/11] HDMI CEC framework
Date: Mon, 04 May 2015 19:34:58 +0200
Message-id: <"0cc501d08690$a4ff9410$eefebc30$@debski"@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry, I missed the subject for this cover-letter. Added it in this reply.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Kamil Debski [mailto:k.debski@samsung.com]
> Sent: Monday, May 04, 2015 7:33 PM
> To: dri-devel@lists.freedesktop.org; linux-media@vger.kernel.org
> Cc: m.szyprowski@samsung.com; k.debski@samsung.com;
> mchehab@osg.samsung.com; hverkuil@xs4all.nl; kyungmin.park@samsung.com;
> thomas@tommie-lie.de; sean@mess.org; dmitry.torokhov@gmail.com; linux-
> input@vger.kernel.org; linux-samsung-soc@vger.kernel.org;
> lars@opdenkamp.eu
> Subject: [PATCH v6 00/11]
> 
> Hi,
> 
> The sixth version of this patchset addresses recent comments on the
> mailing list. Please see the changelog below for details.
> 
> Best wishes,
> Kamil Debski
> 
> Changes since v5
> ================
> - drop struct cec_timeval in favour of a __u64 that keeps the timestamp
> in ns
> - remove userspace documentation from Documentation/cec.txt as
> userspace API
>   is described in the DocBook
> - add missing documentation for the passthrough mode to the DocBook
> - add information about the number of events that can be queued
> - fix misspelling of reply
> - fix behaviour of posting an event in cec_received_msg, such that the
> behaviour
>   is consistent with the documentation
> 
> Changes since v4
> ================
> - add sequence numbering to transmitted messages
> - add sequence number handling to event hanlding
> - add passthrough mode
> - change reserved field sizes
> - fixed CEC version defines and addec CEC 2.0 commands
> - add DocBook documentation
> 
> Changes since v3
> ================
> - remove the promiscuous mode
> - rewrite the devicetree patches
> - fixes, expansion and partial rewrite of the documentation
> - reorder of API structures and addition of reserved fields
> - use own struct to report time (32/64 bit safe)
> - fix of handling events
> - add cec.h to include/uapi/linux/Kbuild
> - fixes in the adv76xx driver (add missing methods, change adv7604 to
> adv76xx)
> - cleanup of debug messages in s5p-cec driver
> - remove non necessary claiming of a gpio in the s5p-cec driver
> - cleanup headers of the s5p-cec driver
> 
> Changes since v2
> ===============-
> - added promiscuous mode
> - added new key codes to the input framework
> - add vendor ID reporting
> - add the possibility to clear assigned logical addresses
> - cleanup of the rc cec map
> 
> Changes since v1
> ================
> - documentation edited and moved to the Documentation folder
> - added key up/down message handling
> - add missing CEC commands to the cec.h file
> 
> Background
> ==========
> 
> The work on a common CEC framework was started over three years ago by
> Hans Verkuil. Unfortunately the work has stalled. As I have received
> the task of creating a driver for the CEC interface module present on
> the Exynos range of SoCs, I got in touch with Hans. He replied that the
> work stalled due to his lack of time.
> 
> Original RFC by Hans Verkuil/Martin Bugge
> =========================================
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg28735.html
> 
> 
> Hans Verkuil (5):
>   cec: add HDMI CEC framework
>   DocBook/media: add CEC documentation
>   v4l2-subdev: add HDMI CEC ops
>   cec: adv7604: add cec support.
>   cec: adv7511: add cec support.
> 
> Kamil Debski (6):
>   dts: exynos4*: add HDMI CEC pin definition to pinctrl
>   dts: exynos4: add node for the HDMI CEC device
>   dts: exynos4412-odroid*: enable the HDMI CEC device
>   HID: add HDMI CEC specific keycodes
>   rc: Add HDMI CEC protoctol handling
>   cec: s5p-cec: Add s5p-cec driver
> 
>  Documentation/DocBook/media/Makefile               |    4 +-
>  Documentation/DocBook/media/v4l/biblio.xml         |   10 +
>  Documentation/DocBook/media/v4l/cec-api.xml        |   74 ++
>  Documentation/DocBook/media/v4l/cec-func-close.xml |   59 +
>  Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   73 ++
>  Documentation/DocBook/media/v4l/cec-func-open.xml  |   94 ++
>  Documentation/DocBook/media/v4l/cec-func-poll.xml  |   89 ++
>  .../DocBook/media/v4l/cec-ioc-g-adap-log-addrs.xml |  275 +++++
>  .../DocBook/media/v4l/cec-ioc-g-adap-phys-addr.xml |   78 ++
>  .../DocBook/media/v4l/cec-ioc-g-adap-state.xml     |   87 ++
>  Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml |  173 +++
>  .../DocBook/media/v4l/cec-ioc-g-event.xml          |  125 ++
>  .../DocBook/media/v4l/cec-ioc-g-passthrough.xml    |   88 ++
>  .../DocBook/media/v4l/cec-ioc-g-vendor-id.xml      |   70 ++
>  .../DocBook/media/v4l/cec-ioc-receive.xml          |  185 +++
>  Documentation/DocBook/media_api.tmpl               |    6 +-
>  Documentation/cec.txt                              |  165 +++
>  .../devicetree/bindings/media/s5p-cec.txt          |   33 +
>  arch/arm/boot/dts/exynos4.dtsi                     |   12 +
>  arch/arm/boot/dts/exynos4210-pinctrl.dtsi          |    7 +
>  arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |    4 +
>  arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |    7 +
>  drivers/media/Kconfig                              |    6 +
>  drivers/media/Makefile                             |    2 +
>  drivers/media/cec.c                                | 1191
> ++++++++++++++++++++
>  drivers/media/i2c/adv7511.c                        |  347 +++++-
>  drivers/media/i2c/adv7604.c                        |  207 +++-
>  drivers/media/platform/Kconfig                     |   10 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/s5p-cec/Makefile            |    4 +
>  drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   37 +
>  .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  208 ++++
>  drivers/media/platform/s5p-cec/regs-cec.h          |   96 ++
>  drivers/media/platform/s5p-cec/s5p_cec.c           |  283 +++++
>  drivers/media/platform/s5p-cec/s5p_cec.h           |   76 ++
>  drivers/media/rc/keymaps/Makefile                  |    1 +
>  drivers/media/rc/keymaps/rc-cec.c                  |  144 +++
>  drivers/media/rc/rc-main.c                         |    1 +
>  include/media/adv7511.h                            |    6 +-
>  include/media/cec.h                                |  142 +++
>  include/media/rc-core.h                            |    1 +
>  include/media/rc-map.h                             |    5 +-
>  include/media/v4l2-subdev.h                        |    8 +
>  include/uapi/linux/Kbuild                          |    1 +
>  include/uapi/linux/cec.h                           |  332 ++++++
>  include/uapi/linux/input.h                         |   12 +
>  46 files changed, 4824 insertions(+), 15 deletions(-)  create mode
> 100644 Documentation/DocBook/media/v4l/cec-api.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-log-
> addrs.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-
> phys-addr.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-adap-
> state.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-caps.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-event.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-
> passthrough.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-vendor-
> id.xml
>  create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml
>  create mode 100644 Documentation/cec.txt  create mode 100644
> Documentation/devicetree/bindings/media/s5p-cec.txt
>  create mode 100644 drivers/media/cec.c
>  create mode 100644 drivers/media/platform/s5p-cec/Makefile
>  create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
>  create mode 100644 drivers/media/platform/s5p-
> cec/exynos_hdmi_cecctrl.c
>  create mode 100644 drivers/media/platform/s5p-cec/regs-cec.h
>  create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.c
>  create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.h
>  create mode 100644 drivers/media/rc/keymaps/rc-cec.c  create mode
> 100644 include/media/cec.h  create mode 100644 include/uapi/linux/cec.h
> 
> --
> 1.7.9.5


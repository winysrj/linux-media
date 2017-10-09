Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47551 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751257AbdJIMn0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 08:43:26 -0400
Subject: Re: [PATCH v11 0/4] Add Rockchip RGA V4l2 support
To: Jacob Chen <jacob-chen@iotwrt.com>,
        linux-rockchip@lists.infradead.org
References: <20171009090424.15292-1-jacob-chen@iotwrt.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2b5c0479-0836-9e03-dfd7-75ed77f39512@xs4all.nl>
Date: Mon, 9 Oct 2017 14:43:23 +0200
MIME-Version: 1.0
In-Reply-To: <20171009090424.15292-1-jacob-chen@iotwrt.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

A patch adding an entry to MAINTAINERS is still missing.

Just post a separate patch for that.

Regards,

	Hans

On 09/10/17 11:04, Jacob Chen wrote:
> change in V11:
> - fix compile warning
> 
> change in V10:
> - move to rockchip/rga
> - changes according to comments
> - some style changes
> 
> change in V9:
> - remove protduff things
> - test with the latest v4l2-compliance
> 
> change in V8:
> - remove protduff things
> 
> change in V6,V7:
> - correct warning in checkpatch.pl
> 
> change in V5:
> - v4l2-compliance: handle invalid pxielformat
> - v4l2-compliance: add subscribe_event
> - add colorspace support
> 
> change in V4:
> - document the controls.
> - change according to Hans's comments
> 
> change in V3:
> - rename the controls.
> - add pm_runtime support.
> - enable node by default.
> - correct spelling in documents.
> 
> change in V2:
> - generalize the controls.
> - map buffers (10-50 us) in every cmd-run rather than in buffer-import to avoid get_free_pages failed on
> actively used systems.
> - remove status in dt-bindings examples.
> 
> Jacob Chen (4):
>   rockchip/rga: v4l2 m2m support
>   ARM: dts: rockchip: add RGA device node for RK3288
>   arm64: dts: rockchip: add RGA device node for RK3399
>   dt-bindings: Document the Rockchip RGA bindings
> 
>  .../devicetree/bindings/media/rockchip-rga.txt     |   33 +
>  arch/arm/boot/dts/rk3288.dtsi                      |   11 +
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   11 +
>  drivers/media/platform/Kconfig                     |   15 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/rockchip/rga/Makefile       |    3 +
>  drivers/media/platform/rockchip/rga/rga-buf.c      |  154 +++
>  drivers/media/platform/rockchip/rga/rga-hw.c       |  421 ++++++++
>  drivers/media/platform/rockchip/rga/rga-hw.h       |  437 +++++++++
>  drivers/media/platform/rockchip/rga/rga.c          | 1012 ++++++++++++++++++++
>  drivers/media/platform/rockchip/rga/rga.h          |  123 +++
>  11 files changed, 2222 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
>  create mode 100644 drivers/media/platform/rockchip/rga/Makefile
>  create mode 100644 drivers/media/platform/rockchip/rga/rga-buf.c
>  create mode 100644 drivers/media/platform/rockchip/rga/rga-hw.c
>  create mode 100644 drivers/media/platform/rockchip/rga/rga-hw.h
>  create mode 100644 drivers/media/platform/rockchip/rga/rga.c
>  create mode 100644 drivers/media/platform/rockchip/rga/rga.h
> 

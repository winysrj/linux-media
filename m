Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48622 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760505AbcLPJrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 04:47:12 -0500
Subject: Re: [PATCH v6 0/5] davinci: VPIF: add DT support
To: Kevin Hilman <khilman@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
References: <20161207183025.20684-1-khilman@baylibre.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?Q?Bartosz_Go=c5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d4b0501a-f83a-c8b1-e460-1ba50f68cca7@xs4all.nl>
Date: Fri, 16 Dec 2016 10:47:09 +0100
MIME-Version: 1.0
In-Reply-To: <20161207183025.20684-1-khilman@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/12/16 19:30, Kevin Hilman wrote:
> Prepare the groundwork for adding DT support for davinci VPIF drivers.
> This series does some fixups/cleanups and then adds the DT binding and
> DT compatible string matching for DT probing.
>
> The controversial part from previous versions around async subdev
> parsing, and specifically hard-coding the input/output routing of
> subdevs, has been left out of this series.  That part can be done as a
> follow-on step after agreement has been reached on the path forward.
> With this version, platforms can still use the VPIF capture/display
> drivers, but must provide platform_data for the subdevs and subdev
> routing.
>
> Tested video capture to memory on da850-lcdk board using composite
> input.

Other than the comment for the first patch this series looks good.

So once that's addressed I'll queue it up for 4.11.

Regards,

	Hans

>
> Changes since v5:
> - locking fix: updated comment around lock variable
> - binding doc: added example for
> - added reviewed-by tags from Laurent (thanks!)
>
> Changes since v4:
> - dropped controversial async subdev parsing support.  That can be
>   done as a follow-up step after the discussions have finalized on the
>     right approach.
>     - DT binding Acked by DT maintainer (Rob H.)
>     - reworked locking fix (suggested by Laurent)
>
> Changes since v3:
> - move to a single VPIF node, DT binding updated accordingly
> - misc fixes/updates based on reviews from Sakari
>
> Changes since v2:
> - DT binding doc: fix example to use correct compatible
>
> Changes since v1:
> - more specific compatible strings, based on SoC: ti,da850-vpif*
> - fix locking bug when unlocking over subdev s_stream
>
>
> Kevin Hilman (5):
>   [media] davinci: VPIF: fix module loading, init errors
>   [media] davinci: vpif_capture: remove hard-coded I2C adapter id
>   [media] davinci: vpif_capture: fix start/stop streaming locking
>   [media] dt-bindings: add TI VPIF documentation
>   [media] davinci: VPIF: add basic support for DT init
>
>  .../devicetree/bindings/media/ti,da850-vpif.txt    | 83 ++++++++++++++++++++++
>  drivers/media/platform/davinci/vpif.c              | 14 +++-
>  drivers/media/platform/davinci/vpif_capture.c      | 26 +++++--
>  drivers/media/platform/davinci/vpif_capture.h      |  2 +-
>  drivers/media/platform/davinci/vpif_display.c      |  6 ++
>  include/media/davinci/vpif_types.h                 |  1 +
>  6 files changed, 125 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>


Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43728 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756483AbcIGHvH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 03:51:07 -0400
Subject: Re: [PATCH v5 00/12] Add HSV format
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
        Antti Palosaari <crope@iki.fi>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fe770e24-a037-10cf-f078-81e72fe29cdd@xs4all.nl>
Date: Wed, 7 Sep 2016 09:51:00 +0200
MIME-Version: 1.0
In-Reply-To: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/16 16:33, Ricardo Ribalda Delgado wrote:
> HSV formats are extremely useful for image segmentation. This set of
> patches makes v4l2 aware of this kind of formats.
>
> Vivid changes have been divided to ease the reviewing process.
>
> We are working on patches for Gstreamer and OpenCV that will make use
> of these formats.
>
> We still need to decide if and how we will support HUE range 0-255

For this patch series (except for 10/12 which had a v2):

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

>
>
> Changelog:
> It is rebased on top of https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=sycc
>
> v5: Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
> -Redo "Local optimization for clamp" based on compiler output
>
> Suggested by Hans Verkuil <hverkuil@xs4all.nl> and
> - Start hsv encoding values at 128
> - Fix documentation
> - Change MAP_QUANTIZATION_DEFAULT
>
> v4:
> Suggested by Hans Verkuil <hverkuil@xs4all.nl> and
> - Rename YUV to YCBCR
> - Fix numerical error
>
> Suggested by Hans Verkuil <hverkuil@xs4all.nl> and
> 	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> -Implement hsv_encoding for supporting 0-255 range
>
>
> v3:
> -Fix wrong handling of some YUV formats when brightness != 128
>
> Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> -Remove unneeded empty lines on .rst file
> Thanks!
>
> Suggested by Hans Verkuil <hverkuil@xs4all.nl>
> -Rebase over master and docs-next
> -Introduce TPG_COLOR_ENC_LUMA for gray formats
> -CodeStyle
> Thanks!
>
> v2:
> Suggested by Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
> -Rebase on top of docs-next (port documentation to .rst)
>
> Ricardo Ribalda Delgado (12):
>   [media] videodev2.h Add HSV formats
>   [media] Documentation: Add HSV format
>   [media] Documentation: Add Ricardo Ribalda
>   [media] vivid: Code refactor for color encoding
>   [media] vivid: Add support for HSV formats
>   [media] vivid: Rename variable
>   [media] vivid: Introduce TPG_COLOR_ENC_LUMA
>   [media] vivid: Fix YUV555 and YUV565 handling
>   [media] vivid: Local optimization
>   [media] videodev2.h Add HSV encoding
>   [media] Documentation: Add HSV encodings
>   [media] vivid: Add support for HSV encoding
>
>  Documentation/media/uapi/v4l/hsv-formats.rst       |  19 +
>  Documentation/media/uapi/v4l/pixfmt-002.rst        |  12 +-
>  Documentation/media/uapi/v4l/pixfmt-003.rst        |  14 +-
>  Documentation/media/uapi/v4l/pixfmt-006.rst        |  41 +-
>  Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 159 ++++++++
>  Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
>  Documentation/media/uapi/v4l/v4l2.rst              |   9 +
>  Documentation/media/videodev2.h.rst.exceptions     |   4 +
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      | 411 ++++++++++++++-------
>  drivers/media/platform/vivid/vivid-core.h          |   3 +-
>  drivers/media/platform/vivid/vivid-ctrls.c         |  25 ++
>  drivers/media/platform/vivid/vivid-vid-cap.c       |  17 +-
>  drivers/media/platform/vivid/vivid-vid-common.c    |  68 ++--
>  drivers/media/platform/vivid/vivid-vid-out.c       |   1 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
>  include/media/v4l2-tpg.h                           |  24 +-
>  include/uapi/linux/videodev2.h                     |  36 +-
>  17 files changed, 664 insertions(+), 182 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
>

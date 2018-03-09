Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:38079 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751059AbeCIMpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 07:45:19 -0500
Subject: Re: [PATCH v5 0/2] media: video-i2c: add video-i2c driver support
To: Matt Ranostay <matt.ranostay@konsulko.com>,
        linux-media@vger.kernel.org
References: <20180308182141.28997-1-matt.ranostay@konsulko.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b6b62671-e5a9-c3c9-2303-11dbc48da7c8@xs4all.nl>
Date: Fri, 9 Mar 2018 13:45:17 +0100
MIME-Version: 1.0
In-Reply-To: <20180308182141.28997-1-matt.ranostay@konsulko.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

This is looking good. One request before I merge: please run the
'v4l2-compliance -s -f' utility and post the result here.

I don't think I've asked you to do that before (or if I did, I couldn't
find it in my mail archive).

It should run without failures.

Use the latest version from the git repo: https://git.linuxtv.org/v4l-utils.git/

./bootstrap.sh; ./configure; make; sudo make install

Thanks!

	Hans

On 08/03/18 19:21, Matt Ranostay wrote:
> Add support for video-i2c polling driver
> 
> Changes from v1:
> * Switch to SPDX tags versus GPLv2 license text
> * Remove unneeded zeroing of data structures
> * Add video_i2c_try_fmt_vid_cap call in video_i2c_s_fmt_vid_cap function
> 
> Changes from v2:
> * Add missing linux/kthread.h include that broke x86_64 build
> 
> Changes from v3:
> * Add devicetree binding documents
> * snprintf check added
> * switched to per chip support based on devicetree or i2c client id
> * add VB2_DMABUF to io_modes
> * added entry to MAINTAINERS file switched to per chip support based on devicetree or i2c client id
> 
> Changes from v4:
> * convert pointer from of_device_get_match_data() to long instead of int to avoid compiler warning
> 
> Matt Ranostay (2):
>   media: dt-bindings: Add bindings for panasonic,amg88xx
>   media: video-i2c: add video-i2c driver
> 
>  .../bindings/media/i2c/panasonic,amg88xx.txt       |  19 +
>  MAINTAINERS                                        |   6 +
>  drivers/media/i2c/Kconfig                          |   9 +
>  drivers/media/i2c/Makefile                         |   1 +
>  drivers/media/i2c/video-i2c.c                      | 558 +++++++++++++++++++++
>  5 files changed, 593 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt
>  create mode 100644 drivers/media/i2c/video-i2c.c
> 

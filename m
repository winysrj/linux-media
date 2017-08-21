Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34249 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdHUGMl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 02:12:41 -0400
Received: by mail-yw0-f174.google.com with SMTP id s143so86178318ywg.1
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 23:12:41 -0700 (PDT)
Received: from mail-yw0-f173.google.com (mail-yw0-f173.google.com. [209.85.161.173])
        by smtp.gmail.com with ESMTPSA id b79sm4343031ywh.65.2017.08.20.23.12.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Aug 2017 23:12:40 -0700 (PDT)
Received: by mail-yw0-f173.google.com with SMTP id s143so86178101ywg.1
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 23:12:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503091856-18294-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1503091856-18294-1-git-send-email-sakari.ailus@linux.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 21 Aug 2017 15:12:19 +0900
Message-ID: <CAAFQd5DJ8i_uaOHu3__8tMVQwMfuKbPzR9C9Ub4EBayT282FDw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add V4L2_BUF_TYPE_META_OUTPUT buffer type
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-api@vger.kernel.org, Yong Zhi <yong.zhi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sat, Aug 19, 2017 at 6:30 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi folks,
>
> Here's a non-RFC version of the META_OUTPUT buffer type patches.
>
> The V4L2_BUF_TYPE_META_OUTPUT buffer type complements the metadata buffer
> types support for OUTPUT buffers, capture being already supported. This is
> intended for similar cases than V4L2_BUF_TYPE_META_CAPTURE but for output
> buffers, e.g. device parameters that may be complex and highly
> hierarchical data structure. Statistics are a current use case for
> metadata capture buffers.
>
> Yong: could you take these to your IPU3 ImgU patchset, please? As that
> would be the first user, the patches would be merged with the driver
> itself.
>
> since RFC:
>
> - Fix make htmldocs build.
>
> - Fix CAPTURE -> OUTPUT in buffer.rst.
>
> - Added " for specifying how the device processes images" in the
>   documentation.
>
> Sakari Ailus (2):
>   v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
>   docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
>
>  Documentation/media/uapi/v4l/buffer.rst          |  3 +++
>  Documentation/media/uapi/v4l/dev-meta.rst        | 33 ++++++++++++++----------
>  Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
>  Documentation/media/videodev2.h.rst.exceptions   |  2 ++
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  2 ++
>  drivers/media/v4l2-core/v4l2-ioctl.c             | 25 ++++++++++++++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c         |  1 +
>  include/media/v4l2-ioctl.h                       | 17 ++++++++++++
>  include/uapi/linux/videodev2.h                   |  2 ++
>  9 files changed, 75 insertions(+), 13 deletions(-)

For the whole series:
Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz

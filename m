Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:33917 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdHCHPd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Aug 2017 03:15:33 -0400
Received: by mail-yw0-f179.google.com with SMTP id s143so3287878ywg.1
        for <linux-media@vger.kernel.org>; Thu, 03 Aug 2017 00:15:33 -0700 (PDT)
Received: from mail-yw0-f179.google.com (mail-yw0-f179.google.com. [209.85.161.179])
        by smtp.gmail.com with ESMTPSA id l145sm4965107ywe.10.2017.08.03.00.15.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Aug 2017 00:15:32 -0700 (PDT)
Received: by mail-yw0-f179.google.com with SMTP id s143so3287645ywg.1
        for <linux-media@vger.kernel.org>; Thu, 03 Aug 2017 00:15:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1497626061-2129-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1497626061-2129-1-git-send-email-sakari.ailus@linux.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 3 Aug 2017 16:15:11 +0900
Message-ID: <CAAFQd5CcmCzToaQTHbvT3W_g+rx0gksy=4G94BG5zJxFXoh4jw@mail.gmail.com>
Subject: Re: [RFC 0/2] Add V4L2_BUF_TYPE_META_OUTPUT buffer type
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Yong Zhi <yong.zhi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sat, Jun 17, 2017 at 12:14 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> The V4L2_BUF_TYPE_META_OUTPUT buffer type complements the metadata buffer
> types support for OUTPUT buffers, capture being already supported. This is
> intended for similar cases than V4L2_BUF_TYPE_META_CAPTURE but for output
> buffers, e.g. device parameters that may be complex and highly
> hierarchical data structure. Statistics are a current use case for
> metadata capture buffers.
>
> There's a warning related to references from make htmldocs; I'll fix that
> in v2 / non-RFC version.
>
> Sakari Ailus (2):
>   v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
>   docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
>
>  Documentation/media/uapi/v4l/buffer.rst          |  3 +++
>  Documentation/media/uapi/v4l/dev-meta.rst        | 32 ++++++++++++++----------
>  Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  2 ++
>  drivers/media/v4l2-core/v4l2-ioctl.c             | 25 ++++++++++++++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c         |  1 +
>  include/media/v4l2-ioctl.h                       | 17 +++++++++++++
>  include/uapi/linux/videodev2.h                   |  2 ++
>  8 files changed, 72 insertions(+), 13 deletions(-)

Is there by any chance an update on this series?

Best regards,
Tomasz

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38260 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752234AbdFPPwJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 11:52:09 -0400
Subject: Re: [RFC 0/2] Add V4L2_BUF_TYPE_META_OUTPUT buffer type
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com
References: <1497626061-2129-1-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <283ee3b2-f35c-f23f-6fdb-a8f0830f9b2c@xs4all.nl>
Date: Fri, 16 Jun 2017 17:52:03 +0200
MIME-Version: 1.0
In-Reply-To: <1497626061-2129-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/16/2017 05:14 PM, Sakari Ailus wrote:
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
>    v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
>    docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
> 
>   Documentation/media/uapi/v4l/buffer.rst          |  3 +++
>   Documentation/media/uapi/v4l/dev-meta.rst        | 32 ++++++++++++++----------
>   Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  2 ++
>   drivers/media/v4l2-core/v4l2-ioctl.c             | 25 ++++++++++++++++++
>   drivers/media/v4l2-core/videobuf2-v4l2.c         |  1 +
>   include/media/v4l2-ioctl.h                       | 17 +++++++++++++
>   include/uapi/linux/videodev2.h                   |  2 ++
>   8 files changed, 72 insertions(+), 13 deletions(-)
> 

I would very much appreciate it if you can also provide patches for v4l2-ctl
and v4l2-compliance. Should be quite easy, just follow what I did for the
META_CAPTURE support.

Regards,

	Hans

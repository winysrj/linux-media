Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57030 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750728AbdFNKrp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 06:47:45 -0400
Subject: Re: [PATCH v2 2/2] v4l: controls: Improve documentation for
 V4L2_CID_GAIN
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1497014507-1835-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497014507-1835-3-git-send-email-sakari.ailus@linux.intel.com>
Cc: mchehab@s-opensource.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <271d5cf7-9f2d-a2f8-c4b5-4d33fcc84fd2@xs4all.nl>
Date: Wed, 14 Jun 2017 12:47:40 +0200
MIME-Version: 1.0
In-Reply-To: <1497014507-1835-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/17 15:21, Sakari Ailus wrote:
> Elaborate the differences between V4L2_CID_GAIN and gain-type specific
> V4L2_CID_DIGITAL_GAIN and V4L2_CID_ANALOGUE_GAIN.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>


Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/media/uapi/v4l/control.rst | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
> index 51112ba..c1e6adb 100644
> --- a/Documentation/media/uapi/v4l/control.rst
> +++ b/Documentation/media/uapi/v4l/control.rst
> @@ -137,6 +137,12 @@ Control IDs
>  ``V4L2_CID_GAIN`` ``(integer)``
>      Gain control.
>  
> +    Primarily used to control gain on e.g. TV tuners but also on
> +    webcams. Most devices control only digital gain with this control
> +    but on some this could include analogue gain as well. Devices that
> +    recognise the difference between digital and analogue gain use
> +    controls ``V4L2_CID_DIGITAL_GAIN`` and ``V4L2_CID_ANALOGUE_GAIN``.
> +
>  ``V4L2_CID_HFLIP`` ``(boolean)``
>      Mirror the picture horizontally.
>  
> 

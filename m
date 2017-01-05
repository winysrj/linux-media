Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:40100 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752712AbdAEPXN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2017 10:23:13 -0500
Subject: Re: [PATCH v2 2/2] [media] v4l: Add 10/16-bits per channel YUV pixel
 formats
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1483547351-5792-1-git-send-email-ayaka@soulik.info>
 <1483547351-5792-3-git-send-email-ayaka@soulik.info>
 <20170105103037.GT3958@valkosipuli.retiisi.org.uk>
Cc: dri-devel@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        randy.li@rock-chips.com, linux-kernel@vger.kernel.org,
        daniel.vetter@intel.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
From: ayaka <ayaka@soulik.info>
Message-ID: <9a7e7ffd-27d5-0fff-2be5-03f14cc78683@soulik.info>
Date: Thu, 5 Jan 2017 23:22:26 +0800
MIME-Version: 1.0
In-Reply-To: <20170105103037.GT3958@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/05/2017 06:30 PM, Sakari Ailus wrote:
> Hi Randy,
>
> Thanks for the update.
>
> On Thu, Jan 05, 2017 at 12:29:11AM +0800, Randy Li wrote:
>> The formats added by this patch are:
>> 	V4L2_PIX_FMT_P010
>> 	V4L2_PIX_FMT_P010M
>> 	V4L2_PIX_FMT_P016
>> 	V4L2_PIX_FMT_P016M
>> Currently, none of driver uses those format, but some video device
>> has been confirmed with could as those format for video output.
>> The Rockchip's new decoder has supported those 10 bits format for
>> profile_10 HEVC/AVC video.
>>
>> Signed-off-by: Randy Li <ayaka@soulik.info>
>>
>> v4l2
>> ---
>>   Documentation/media/uapi/v4l/pixfmt-p010.rst  |  86 ++++++++++++++++
>>   Documentation/media/uapi/v4l/pixfmt-p010m.rst |  94 ++++++++++++++++++
>>   Documentation/media/uapi/v4l/pixfmt-p016.rst  | 126 ++++++++++++++++++++++++
>>   Documentation/media/uapi/v4l/pixfmt-p016m.rst | 136 ++++++++++++++++++++++++++
> You need to include the formats in pixfmt.rst in order to compile the
> documentation.
>
> $ make htmldocs
>
> And you'll find it in Documentation/output/media/uapi/v4l/v4l2.html .
>
> In Debian you'll need to install sphinx-common and python3-sphinx-rtd-theme
> .
OK, I would fix them in new version.
The view of byte order for P010 serial is left empty, it is a little 
hard for me to use flat-table to draw them. Is there possible to use 
something like latex to do this job?
>
> Regarding P010 and the rest --- I'm fine with that, considering also that
> NV12 was never a great name for a format...
>


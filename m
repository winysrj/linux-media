Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46458 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaAVWoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 17:44:46 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so68192eei.7
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 14:44:45 -0800 (PST)
Message-ID: <52E049DA.7010603@gmail.com>
Date: Wed, 22 Jan 2014 23:44:42 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com
Subject: Re: [RFCv2 PATCH 00/21] Add support for complex controls
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 01/20/2014 01:45 PM, Hans Verkuil wrote:
> This patch series adds support for complex controls (aka 'Properties') to
> the control framework. It is the first part of a larger patch series that
> adds support for configuration stores, motion detection matrix controls and
> support for 'Multiple Selections'.
>
> This patch series is based on this RFC:
>
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/71822
>
> A more complete patch series (including configuration store support and the
> motion detection work) can be found here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/propapi-doc
>
> This patch series is a revision of this series:
>
> http://www.spinics.net/lists/linux-media/msg71281.html
>
> Changes since RFCv1 are:
>
> - dropped configuration store support for now (there is no driver at the moment
>    that needs it).
> - dropped the term 'property', instead call it a 'control with a complex type'
>    or 'complex control' for short.
> - added DocBook documentation.
>
> The API changes required to support complex controls are minimal:
>
> - A new V4L2_CTRL_FLAG_HIDDEN has been added: any control with this flag (and
>    complex controls will always have this flag) will never be shown by control
>    panel GUIs. The only way to discover them is to pass the new _FLAG_NEXT_HIDDEN
>    flag to QUERYCTRL.

I had issues with using _HIDDEN for this at first but after thinking a 
bit more
it seems sensible.

> - A new VIDIOC_QUERY_EXT_CTRL ioctl has been added: needed to get the number of elements
>    stored in the control (rows by columns) and the size in byte of each element.
>    As a bonus feature a unit string has also been added as this has been requested
>    in the past. In addition min/max/step/def values are now 64-bit.
>
> - A new 'p' field is added to struct v4l2_ext_control to set/get complex values.
>
> - A helper flag V4L2_CTRL_FLAG_IS_PTR has been added to tell apps whether the
>    'value' or 'value64' fields of the v4l2_ext_control struct can be used (bit
>    is cleared) or if the 'p' pointer can be used (bit it set).
>
> There is one open item: if a complex control is a matrix, then it is possible
> to set only the first N elements of that matrix (starting at the first row).
> Currently the API will initialize the remaining elements to their default
> value. The idea was that if you have an array of, say, selection
> rectangles, then if you just set the first one the others will be automatically
> zeroed (i.e. set to unused). Without that you would be forced to set the whole
> array unless you are certain that they are already zeroed.
>
> It also has the advantage that when you set a control you know that all elements
> are set, even if you don't specify them all.
>
> Should I support the ability to set only the first N elements of a matrix at all?
>
> I see three options:
>
> 1) allow getting/setting only the first N elements and (when setting) initialize
>     the remaining elements to their default value.
> 2) allow getting/setting only the first N elements and leave the remaining
>     elements to their old value.
> 3) always set the full matrix.
>
> I am actually leaning towards 3 as that is the only unambiguous option. If there
> is a good use case in the future support for 1 or 2 can always be added later.

My feeling is that setting/getting only part of the matrix might be a useful
feature. Weren't you using struct v4l2_rect to select part of the matrix ?
Anyway, if there is no real need for {s,g}etting only part of the matrix yet
and adding it later won't be troublesome it seems reasonable to just start
with 3) for now.

Regards,
Sylwester

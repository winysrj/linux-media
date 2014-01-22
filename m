Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55782 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaAVWzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 17:55:25 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so73020ead.36
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 14:55:24 -0800 (PST)
Message-ID: <52E04C5A.1020505@gmail.com>
Date: Wed, 22 Jan 2014 23:55:22 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 04/21] videodev2.h: add initial support for complex
 controls.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390221974-28194-5-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2014 01:45 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Complex controls are controls that can be used for compound and array
> types. This allows for more complex datastructures to be used with the
                                           ^
(missing whitespace)

> control framework.
>
> Such controls always have the V4L2_CTRL_FLAG_HIDDEN flag set. Note that
> 'simple' controls can also set that flag.
>
> The existing V4L2_CTRL_FLAG_NEXT_CTRL flag will only enumerate controls
> that do not have the HIDDEN flag, so a new V4L2_CTRL_FLAG_NEXT_HIDDEN flag
> is added to enumerate hidden controls. Set both flags to enumerate any
> controls (hidden or not).
>
> Complex control types will start at V4L2_CTRL_COMPLEX_TYPES. In addition, any
> control that uses the new 'p' field or the existing 'string' field will have
> flag V4L2_CTRL_FLAG_IS_PTR set.
>
> While not strictly necessary, adding that flag makes life for applications
> a lot simpler. If the flag is not set, then the control value is set
> through the value or value64 fields of struct v4l2_ext_control, otherwise
> a pointer points to the value.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

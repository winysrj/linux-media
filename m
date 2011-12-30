Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52071 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1L3LXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 06:23:11 -0500
Received: by eekc4 with SMTP id c4so13509983eek.19
        for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 03:23:10 -0800 (PST)
Message-ID: <4EFD9F1B.6050209@gmail.com>
Date: Fri, 30 Dec 2011 12:23:07 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: "HeungJun, Kim" <riverful.kim@samsung.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <1325053428-2626-2-git-send-email-riverful.kim@samsung.com>
In-Reply-To: <1325053428-2626-2-git-send-email-riverful.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi HeungJun,

On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
> It adds the new CID for setting White Balance Preset. This CID is provided as
> menu type using the following items:
> 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
> 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
> 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
> 3 - V4L2_WHITE_BALANCE_CLOUDY,
> 4 - V4L2_WHITE_BALANCE_SHADE,

While at it, how about adding V4L2_WHITE_BALANCE_LED_LIGHT as well ?

--

Regards,
Sylwester

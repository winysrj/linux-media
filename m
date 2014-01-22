Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56114 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaAVWpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 17:45:50 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so70080ead.36
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 14:45:49 -0800 (PST)
Message-ID: <52E04A1A.2030000@gmail.com>
Date: Wed, 22 Jan 2014 23:45:46 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 01/21] v4l2-ctrls: increase internal min/max/step/def
 to 64 bit
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390221974-28194-2-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2014 01:45 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> While VIDIOC_QUERYCTRL is limited to 32 bit min/max/step/def values
> for controls, the upcoming VIDIOC_QUERY_EXT_CTRL isn't. So increase
> the internal representation to 64 bits in preparation.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:41315 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaAVWr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 17:47:57 -0500
Received: by mail-ee0-f47.google.com with SMTP id d49so69155eek.20
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 14:47:56 -0800 (PST)
Message-ID: <52E04A99.9060008@gmail.com>
Date: Wed, 22 Jan 2014 23:47:53 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 02/21] v4l2-ctrls: add unit string.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390221974-28194-3-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2014 01:45 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> The upcoming VIDIOC_QUERY_EXT_CTRL adds support for a unit string. This
> allows userspace to show the unit belonging to a particular control.
>
> This patch adds support for the unit string to the control framework.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

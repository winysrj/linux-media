Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53031 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaG2NJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 09:09:07 -0400
Message-id: <53D79CEB.2020208@samsung.com>
Date: Tue, 29 Jul 2014 15:08:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Zhaowei Yuan <zhaowei.yuan@samsung.com>, k.debski@samsung.com,
	m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	jtp.park@samsung.com, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] media: s5p_mfc: remove unnecessary calling to function
 video_devdata()
References: <1406088372-5240-1-git-send-email-zhaowei.yuan@samsung.com>
In-reply-to: <1406088372-5240-1-git-send-email-zhaowei.yuan@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/07/14 06:06, Zhaowei Yuan wrote:
> Since we have get vdev by calling video_devdata() at the beginning of
> s5p_mfc_open(), we should just use vdev instead of calling video_devdata()
> again in the following code.

Applied to my tree, thanks.

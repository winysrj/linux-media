Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1857 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3AYLw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 06:52:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 2/2 v3] vb2: Add support for non monotonic timestamps
Date: Fri, 25 Jan 2013 12:52:37 +0100
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, pawel@osciak.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1359109797-12698-1-git-send-email-k.debski@samsung.com> <1359109797-12698-3-git-send-email-k.debski@samsung.com>
In-Reply-To: <1359109797-12698-3-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301251252.37553.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri January 25 2013 11:29:57 Kamil Debski wrote:
> Not all drivers use monotonic timestamps. This patch adds a way to set the
> timestamp type per every queue.
> 
> In addition, set proper timestamp type in drivers that I am sure that use
> either MONOTONIC or COPY timestamps. Other drivers will correctly report
> UNKNOWN timestamp type instead of assuming that all drivers use monotonic
> timestamps.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

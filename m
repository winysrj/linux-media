Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4448 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2GUJvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 05:51:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v6] media: coda: Add driver for Coda video codec.
Date: Sat, 21 Jul 2012 11:50:15 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	s.hauer@pengutronix.de, p.zabel@pengutronix.de
References: <1342782515-24992-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1342782515-24992-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207211150.15296.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri July 20 2012 13:08:35 Javier Martin wrote:
> Coda is a range of video codecs from Chips&Media that
> support H.264, H.263, MPEG4 and other video standards.
> 
> Currently only support for the codadx6 included in the
> i.MX27 SoC is added. H.264 and MPEG4 video encoding
> are the only supported capabilities by now.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> Reviewed-by: Philipp Zabel<p.zabel@pengutronix.de>
> ---
> Changes since v5:
>  - Fixed some v4l2-compliance issues.

Some or all? Can you give me the 'v4l2-compliance -v1' output?

Regards,

	Hans

>  - Attended most of Sylwester's tips.

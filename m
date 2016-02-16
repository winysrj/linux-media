Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58129 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932539AbcBPN4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 08:56:17 -0500
Message-ID: <1455630974.7377.4.camel@pengutronix.de>
Subject: Re: [PATCH 06/12] media/platform: convert drivers to use the new
 vb2_queue dev field
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Date: Tue, 16 Feb 2016 14:56:14 +0100
In-Reply-To: <1455626587-8051-7-git-send-email-hverkuil@xs4all.nl>
References: <1455626587-8051-1-git-send-email-hverkuil@xs4all.nl>
	 <1455626587-8051-7-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Dienstag, den 16.02.2016, 13:43 +0100 schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Stop using alloc_ctx and just fill in the device pointer.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>

Patches 1 and 12 and the coda part
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
and for coda
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

best regards
Philipp


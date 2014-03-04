Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3868 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbaCDLgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 06:36:10 -0500
Message-ID: <5315BA83.5080500@xs4all.nl>
Date: Tue, 04 Mar 2014 12:35:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 7/7] v4l: ti-vpe: Add selection API in VPE driver
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393922965-15967-1-git-send-email-archit@ti.com> <1393922965-15967-8-git-send-email-archit@ti.com> <53159F7D.8020707@xs4all.nl> <5315B822.7010005@ti.com>
In-Reply-To: <5315B822.7010005@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/14 12:25, Archit Taneja wrote:
> I had a minor question about the selection API:
> 
> Are the V4L2_SET_TGT_CROP/COMPOSE_DEFAULT and the corresponding
> 'BOUNDS' targets supposed to be used with VIDIOC_S_SELECTION? If so,
> what's the expect behaviour?

No, those are read only in practice. So only used with G_SELECTION, never
with S_SELECTION.

Regards,

	Hans

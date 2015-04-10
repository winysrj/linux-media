Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57938 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbbDJJuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 05:50:11 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NML00JPX4U64P40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Apr 2015 10:54:06 +0100 (BST)
Message-id: <55279CCE.90707@samsung.com>
Date: Fri, 10 Apr 2015 11:50:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4 2/4] v4l: of: Instead of zeroing bus_type and bus field
 separately, unify this
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
 <1428614706-8367-3-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1428614706-8367-3-git-send-email-sakari.ailus@iki.fi>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/15 23:25, Sakari Ailus wrote:
> Zero the entire struct starting from bus_type. As more fields are added, no
> changes will be needed in the function to reset their value explicitly.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62926 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbbDJJwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 05:52:13 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NML00GP94XRA140@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Apr 2015 10:56:16 +0100 (BST)
Message-id: <55279D47.3020608@samsung.com>
Date: Fri, 10 Apr 2015 11:52:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4 4/4] smiapp: Use v4l2_of_alloc_parse_endpoint()
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
 <1428614706-8367-5-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1428614706-8367-5-git-send-email-sakari.ailus@iki.fi>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/15 23:25, Sakari Ailus wrote:
> Instead of parsing the link-frequencies property in the driver, let
> v4l2_of_alloc_parse_endpoint() do it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56009 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2DBM4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 08:56:54 -0400
Received: by vbbff1 with SMTP id ff1so1650613vbb.19
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 05:56:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333100487-32484-1-git-send-email-Ying.liu@freescale.com>
References: <1333100487-32484-1-git-send-email-Ying.liu@freescale.com>
Date: Mon, 2 Apr 2012 08:56:53 -0400
Message-ID: <CABMb9Gshv0WXPv47JBdYBqRiOEPsg=CbfxbKskazURPWsm+wqw@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] V4L: OV5642:remove redundant code to set
 cropping w/h
From: Chris Lalancette <clalancette@gmail.com>
To: Liu Ying <Ying.liu@freescale.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	g.liakhovetski@gmx.de, hechtb@gmail.com,
	laurent.pinchart@ideasonboard.com, sfr@canb.auug.org.au,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 30, 2012 at 5:41 AM, Liu Ying <Ying.liu@freescale.com> wrote:
> From: Liu Ying <Ying.Liu@freescale.com>
>
> This patch contains code change only to remove redundant
> code to set priv->crop_rect.width/height in probe function.

Yeah, there is no need to do this twice.  You can add an:

Acked-by: Chris Lalancette <clalancette@gmail.com>

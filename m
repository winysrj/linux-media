Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36112 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab2EJUIg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 16:08:36 -0400
Date: Thu, 10 May 2012 14:08:34 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: marvell-ccic: (cosmetic) remove redundant variable
 assignment
Message-ID: <20120510140834.496c9959@lwn.net>
In-Reply-To: <Pine.LNX.4.64.1205081853430.7085@axis700.grange>
References: <Pine.LNX.4.64.1205081853430.7085@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 8 May 2012 18:56:15 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> The "ret = 0" assignment in mcam_vidioc_s_fmt_vid_cap() is redundant,
> because at that location "ret" is anyway guaranteed to be == 0.

True enough.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon

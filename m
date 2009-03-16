Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:37483 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZCPUnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 16:43:01 -0400
Date: Mon, 16 Mar 2009 13:42:59 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] pxa_camera: Redesign DMA handling
In-Reply-To: <87hc1tdzv2.fsf@free.fr>
Message-ID: <Pine.LNX.4.58.0903161331420.28292@shell2.speakeasy.net>
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-3-git-send-email-robert.jarzmik@free.fr>
 <1236986240-24115-4-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903161153200.4409@axis700.grange> <87hc1tdzv2.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009, Robert Jarzmik wrote:
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> > What is QIF? Do you mean Quick Capture Interface - QCI? I also see CIF
> > used in the datasheet, probably, for "Capture InterFace," but I don't see
> > QIF anywhere. Also, please explain the first time you use the
> > abbreviation. Also fix it in the commit message to patch 1/4.
> OK, will replace with QCI, my bad.

In video capture, QIF and CIF usually refer to image size.  CIF would be
320x240 for NTSC and QIF or QCIF would be 160x120.

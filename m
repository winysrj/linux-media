Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:59882 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab2HXNeU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 09:34:20 -0400
Date: Fri, 24 Aug 2012 15:34:20 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 3/3] mt9v022: set y_skip_top field to zero
Message-ID: <20120824153420.66806bf1@wker>
In-Reply-To: <Pine.LNX.4.64.1208241323030.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
	<1345799431-29426-4-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1208241323030.20710@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Aug 2012 13:23:22 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Fri, 24 Aug 2012, Anatolij Gustschin wrote:
> 
> > Set "y_skip_top" to zero and remove comment as I do not see this
> > line corruption on two different mt9v022 setups. The first read-out
> > line is perfectly fine.
> 
> On what systems have you checked this?

On camera systems from ifm, both using mt9v022.

Anatolij

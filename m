Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f135.google.com ([209.85.221.135]:38701 "EHLO
	mail-qy0-f135.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZEUJf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 05:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0905121649420.5087@axis700.grange>
References: <Pine.LNX.4.64.0905121649420.5087@axis700.grange>
Date: Thu, 21 May 2009 18:30:52 +0900
Message-ID: <aec7e5c30905210230g6cdac25w68189b1d2c16086e@mail.gmail.com>
Subject: Re: [PATCH 0/3] Convert SuperH camera-enabled platforms to soc-camera
	as platform_device
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 13, 2009 at 12:13 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Now that soc-camera compatibility patch is in the mainline, we can convert
> all platforms to the new scheme. This patch series converts SuperH boards.
> Unfortunately, the first patch has to also (slightly) modify two camera
> drivers, but that looks like a minor inconvenience to me, at least when
> compared to my original convert-all-at-once mega-patch.

I've tried capturing with these patches applied to next-20090520.
Works fine on Migo-R. The boot output looks ok on ap325 as well
(ov772x detected), have not tried capturing with that board though.
Thanks for your help!

Acked-by: Magnus Damm <damm@igel.co.jp>

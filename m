Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:58926 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbZAWEYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 23:24:05 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2400394fgg.17
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 20:24:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ur62u4qh5.wl%morimoto.kuninori@renesas.com>
References: <ur62u4qh5.wl%morimoto.kuninori@renesas.com>
Date: Fri, 23 Jan 2009 13:24:03 +0900
Message-ID: <aec7e5c30901222024k3600b6b6t718998b945461a40@mail.gmail.com>
Subject: Re: [PATCH] sh_mobile_ceu_camera: NV12/21/16/61 are added only once.
From: Magnus Damm <magnus.damm@gmail.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 23, 2009 at 9:28 AM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
> NV12/21/16/61 had been added every time
> UYVY/VYUY/YUYV/YVYU appears on get_formats.
> This patch modify this problem.

That's one way to do it. Every similar driver has to do the same thing. Yuck.

Or we could have a better translation framework that does OR for us,
using for instance bitmaps.

/ magnus

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47477 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030275Ab2CFNaS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 08:30:18 -0500
MIME-Version: 1.0
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8909@MEP-EXCH.meprolight.com>
References: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8906@MEP-EXCH.meprolight.com>
	<Pine.LNX.4.64.1203061406500.9300@axis700.grange>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8909@MEP-EXCH.meprolight.com>
Date: Tue, 6 Mar 2012 10:30:15 -0300
Message-ID: <CAOMZO5Ct_f49j3L4TV1LhHyTAikyx7jTrMgt4aXiMWzPP8g_FA@mail.gmail.com>
Subject: Re: mx3-camera
From: Fabio Estevam <festevam@gmail.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 6, 2012 at 10:22 AM, Alex Gershgorin <alexg@meprolight.com> wrote:

> In i.MX35 (arch/arm/mach-imx/clock-imx35.c) it looks like this:
>
> _REGISTER_CLOCK(NULL, "csi", csi_clk)

Yes, I will submit a patch to fix this.

Regards,

Fabio Estevam

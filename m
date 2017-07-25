Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35541 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750778AbdGYJiK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 05:38:10 -0400
Subject: Re: linux and sony pregius cmos sensors
To: Philippe De Muyter <phdm@macq.eu>, linux-media@vger.kernel.org
References: <20170725083659.GA27375@frolo.macqel>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1f71995f-c62d-a8be-a877-10c82b22d1f1@xs4all.nl>
Date: Tue, 25 Jul 2017 11:38:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170725083659.GA27375@frolo.macqel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/17 10:36, Philippe De Muyter wrote:
> Hi all,
> 
> I currently investigate using sony pregius cmos sensor (imx264, e.g.)
> on a imx (tegra or imx6) board.  I see that many camera vendors already
> sell USB3 or IP cameras based on such chips, but is there support (or
> currently in development drivers) in linux kernel for those chips ?

Not in the mainline kernel. However, you might want to google this since
it may be supported by third-party (android) kernels.

Usually the code quality of those is awful, but it can be a starting point.

Regards,

	Hans

> 
> IIRC, they don't have a MIPI-CSI2 interface but a LVDS interface.
> Fortunately there is ia chip from a FPGA vendor that can convert LVDS
> to MIPI-CSI2.
> 
> Any advice or info ?
> 
> TIA
> 
> Philippe
> 

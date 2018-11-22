Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48927 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389228AbeKWDHy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 22:07:54 -0500
Message-ID: <1542904065.16720.2.camel@pengutronix.de>
Subject: Re: 'bad remote port parent' warnings
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Thu, 22 Nov 2018 17:27:45 +0100
In-Reply-To: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
References: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-11-20 at 10:10 -0200, Fabio Estevam wrote:
> Hi,
> 
> On a imx6q-wandboard running linux-next 20181120 there the following warnings:
> 
> [    4.327794] video-mux 20e0000.iomuxc-gpr:ipu1_csi0_mux: bad remote
> port parent
> [    4.336118] video-mux 20e0000.iomuxc-gpr:ipu2_csi1_mux: bad remote
> port parent
> 
> Is there anything we should do to prevent this from happening?

There are empty endpoint nodes (without remote-endpoint property)
labeled ipu1_csi[01]_mux_from_parallel_sensor in the i.MX6 device trees
for board DT implementers' convenience. See commit 2539f517acbdc ("ARM:
dts: imx6qdl: Add video multiplexers, mipi_csi, and their connections").

We had a discussion about this issue in February when this caused a
probing error: https://patchwork.kernel.org/patch/10234469/

We could demote the warning to a debug message, make the wording a bit
less misleading (there is no bad remote port parent, there is just no
remote endpoint at all), or we could just accept the error message for
old DTBs and mark these empty endpoint nodes with the /omit-if-no-ref/
keyword to let dtc remove them if they are unused.

regards
Philipp

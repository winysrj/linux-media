Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40235 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeKFATg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:19:36 -0500
Message-ID: <1541429966.10574.18.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx: csi: fix enum_mbus_code for unknown mbus
 format codes
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 05 Nov 2018 15:59:26 +0100
In-Reply-To: <c178383b-39cd-fca4-28a4-5e3691c7d53e@gmail.com>
References: <20180208144749.10558-1-p.zabel@pengutronix.de>
         <79024ebb-bb01-876a-9da9-4c65d3298112@gmail.com>
         <a578997e-f8e7-a663-97c1-eefe1141a772@xs4all.nl>
         <c178383b-39cd-fca4-28a4-5e3691c7d53e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Fri, 2018-02-09 at 17:43 -0800, Steve Longerbeam wrote:
[...]
> I *think* by implementing init_cfg in the CSI, it will prevent the
> NULL deref in csi_enum_mbus_code(). However I think this patch
> is a good idea in any case.

Ack on both. Can we still get this patch applied?

regards
Philipp

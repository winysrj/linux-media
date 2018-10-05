Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35185 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbeJERUK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:20:10 -0400
Message-ID: <1538734920.3545.15.camel@pengutronix.de>
Subject: Re: [PATCH v4 09/11] media: imx-csi: Move crop/compose reset after
 filling default mbus fields
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 05 Oct 2018 12:22:00 +0200
In-Reply-To: <20181004185401.15751-10-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
         <20181004185401.15751-10-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-10-04 at 11:53 -0700, Steve Longerbeam wrote:
> If caller passes un-initialized field type V4L2_FIELD_ANY to CSI
> sink pad, the reset CSI crop window would not be correct, because
> the crop window depends on a valid input field type. To fix move
> the reset of crop and compose windows to after the call to
> imx_media_fill_default_mbus_fields().
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

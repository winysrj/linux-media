Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41323 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbeB0IfB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 03:35:01 -0500
Message-ID: <1519720500.3402.4.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx: add 8-bit grayscale support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de,
        Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
Date: Tue, 27 Feb 2018 09:35:00 +0100
In-Reply-To: <773d7cd2-5372-e1db-5605-82dcdee5453c@xs4all.nl>
References: <20180122161632.16915-1-p.zabel@pengutronix.de>
         <773d7cd2-5372-e1db-5605-82dcdee5453c@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, 2018-02-15 at 15:43 +0100, Hans Verkuil wrote:
> Hi Philipp,
> 
> Can you let me know if/when I can merge this? It looks good, so when the other
> patch is merged, then this can be merged as well.

Thank you for the reminder, the required patch is now merged into
v4.16-rc3, commit 6d36b7fec60e ("gpu: ipu-cpmem: add 8-bit grayscale
support to ipu_cpmem_set_image").

regards
Philipp

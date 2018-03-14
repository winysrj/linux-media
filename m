Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38332 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbeCNHx1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 03:53:27 -0400
Date: Wed, 14 Mar 2018 06:36:51 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Seiderer <ps.report@gmx.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] media: staging/imx: fill vb2_v4l2_buffer sequence entry
Message-ID: <20180314053651.GB12280@kroah.com>
References: <20180313200054.31305-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313200054.31305-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 13, 2018 at 09:00:54PM +0100, Peter Seiderer wrote:
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 5 +++++
>  1 file changed, 5 insertions(+)

I know I don't take patches with an empty changelog description, but
other maintainers might be much more forgiving... :)

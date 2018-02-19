Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59935 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbeBSOYI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 09:24:08 -0500
Message-ID: <1519050231.3408.21.camel@pengutronix.de>
Subject: Re: [PATCH] staging: imx-media-vdic: fix inconsistent IS_ERR and
 PTR_ERR
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Feb 2018 15:23:51 +0100
In-Reply-To: <4305212e-5946-0bb3-1624-ec23a0f37708@embeddedor.com>
References: <20180124004340.GA25212@embeddedgus>
         <5e53d6d8-d336-da37-fe12-0638904e1799@gmail.com>
         <4305212e-5946-0bb3-1624-ec23a0f37708@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On Wed, 2018-02-14 at 14:57 -0600, Gustavo A. R. Silva wrote:
> Hi all,
> 
> I was just wondering about the status of this patch.

It is en route as commit dcd71a9292b1 ("staging: imx-media-vdic: fix
inconsistent IS_ERR and PTR_ERR") in Hans' for-v4.17a branch:
  git://linuxtv.org/hverkuil/media_tree.git for-v4.17a

regards
Philipp

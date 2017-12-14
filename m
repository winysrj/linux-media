Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50708 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753305AbdLNRFe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:05:34 -0500
Date: Thu, 14 Dec 2017 15:05:27 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Dhaval Shah <dhaval23031987@gmail.com>
Cc: hyun.kwon@xilinx.com, laurent.pinchart@ideasonboard.com,
        michal.simek@xilinx.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
Message-ID: <20171214150527.00dca6cc@vento.lan>
In-Reply-To: <20171208123537.18718-1-dhaval23031987@gmail.com>
References: <20171208123537.18718-1-dhaval23031987@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  8 Dec 2017 18:05:37 +0530
Dhaval Shah <dhaval23031987@gmail.com> escreveu:

> SPDX-License-Identifier is used for the Xilinx Video IP and
> related drivers.
> 
> Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>

Hi Dhaval,

You're not listed as one of the Xilinx driver maintainers. I'm afraid that,
without their explicit acks, sent to the ML, I can't accept a patch
touching at the driver's license tags.

Sorry,
Mauro

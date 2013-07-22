Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58287 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab3GVJhh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 05:37:37 -0400
Message-ID: <51ECFD4C.8020407@ti.com>
Date: Mon, 22 Jul 2013 15:07:16 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	<devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] media: i2c: adv7343: make the platform data members
 as array
References: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com> <1374301266-26726-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1374301266-26726-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 July 2013 11:51 AM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch makes the platform data members as array wherever
> possible, so as this makes easier while collecting the data
> in DT case and read the entire array at once.
> 
> This patch also makes appropriate changes to board-da850-evm.c
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: linux-arm-kernel@lists.infradead.org

For the board-da850-evm.c change:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar


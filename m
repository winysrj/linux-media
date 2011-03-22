Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:51735 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1CVM1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 08:27:20 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 22 Mar 2011 17:57:00 +0530
Subject: RE: [PATCH v17 13/13] davinci: dm644x EVM: add support for VPBE
 display
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C47D7C2@dbde02.ent.ti.com>
References: <1300197595-5188-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1300197595-5188-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 15, 2011 at 19:29:55, Hadli, Manjunath wrote:
> This patch adds support for V4L2 video display to DM6446 EVM.
> Support for SD and ED modes is provided, along with Composite
> and Component outputs.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  arch/arm/mach-davinci/board-dm644x-evm.c    |  108 ++++++++++++++++++++++++++-
>  arch/arm/mach-davinci/dm644x.c              |    4 +-
>  arch/arm/mach-davinci/include/mach/dm644x.h |    3 +-

The changes adding the SoC support should be folded
into patch 12/13.

Thanks,
Sekhar


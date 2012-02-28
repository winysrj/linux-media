Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36425 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964818Ab2B1Oig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 09:38:36 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id q1SEcYO5026688
	for <linux-media@vger.kernel.org>; Tue, 28 Feb 2012 08:38:35 -0600
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH 1/4] davinci: vpif: add check for genuine interrupts in
 the isr
Date: Tue, 28 Feb 2012 14:38:31 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B6317D6C67@DBDE01.ent.ti.com>
References: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
 <1327503934-28186-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1327503934-28186-2-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On Wed, Jan 25, 2012 at 20:35:31, Hadli, Manjunath wrote:
> add a condition to in the isr to check for interrupt ownership and

"to" is misplaced here?

> channel number to make sure we do not service wrong interrupts.
>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>

I think it will be nice to expand on the "why" this patch
is required a little bit.

What is the usage case where you can get wrong interrupts?
What exactly happens if you service wrong interrupts?

Explaining these in the commit message will help the maintainers
take a call on the criticality of this patch (whether it should
be queued in the current -rc cycle or not).

Thanks,
Sekhar


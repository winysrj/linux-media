Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1KXSFf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 13:05:35 -0500
Message-ID: <4ECE8764.60800@redhat.com>
Date: Thu, 24 Nov 2011 16:05:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RESEND] davinci: dm646x: move vpif related code to driver
 core header from platform
References: <1321110362-6699-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321110362-6699-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-11-2011 13:06, Manjunath Hadli escreveu:
> move vpif related code for capture and display drivers
> from dm646x platform header file to vpif_types.h as these definitions
> are related to driver code more than the platform or board.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>

Manju,

Why are you re-sending a patch?

My understanding is that you're maintaining the davinci patches, so it is
up to you to put those patches on your tree and send me a pull request when
they're done. So, please, don't pollute the ML re-sending emails that
are for yourself to handle.

Regards,
Mauro.


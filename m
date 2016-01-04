Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:39837 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbcADIjr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 03:39:47 -0500
Subject: Re: [PATCH] [media] si2165: Refactoring for si2165_writereg_mask8()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <568020CC.1060004@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <568A2FB9.8040806@gentoo.org>
Date: Mon, 4 Jan 2016 09:39:21 +0100
MIME-Version: 1.0
In-Reply-To: <568020CC.1060004@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.12.2015 um 18:33 schrieb SF Markus Elfring:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 27 Dec 2015 18:23:57 +0100
> 
> This issue was detected by using the Coccinelle software.
> 
> 1. Let us return directly if a call of the si2165_readreg8()
>    function failed.
> 
> 2. Reduce the scope for the local variables "ret" and "tmp" to one branch
>    of an if statement.
> 
> 3. Delete the jump label "err" then.
> 
> 4. Return the value from a call of the si2165_writereg8() function
>    without using an extra assignment for the variable "ret" at the end.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

The patch looks fine.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Regards
Matthias

PS: I am going to switch to regmap, but this change is not yet polished
and until now does not touch this function.


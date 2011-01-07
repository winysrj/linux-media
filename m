Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64949 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1AGNvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 08:51:36 -0500
Date: Fri, 7 Jan 2011 16:51:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] av7110: make array offset unsigned
Message-ID: <20110107135122.GI1717@bicker>
References: <20110106194059.GC1717@bicker>
 <4D270A9F.7080104@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D270A9F.7080104@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 07, 2011 at 01:44:15PM +0100, Andreas Oberritter wrote:
> Nack. You're changing an interface to userspace. Please add a check to
> av7110_ca.c instead.
> 

Ok.  I've done that and resent the patch.

But just for my own understanding, why is it wrong to change an int to
an unsigned int in the userspace API?  Who would notice?  (I'm still
quite a newbie at system programming).

regards,
dan carpenter


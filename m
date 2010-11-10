Return-path: <mchehab@pedra>
Received: from smtp.gentoo.org ([140.211.166.183]:53445 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592Ab0KJTp2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 14:45:28 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: IX2505V: i2c transfer error code ignored
Date: Wed, 10 Nov 2010 20:42:22 +0100
Cc: Malcolm Priestley <tvboxspy@gmail.com>
References: <201011071457.14929.zzam@gentoo.org> <1289155850.4638.7.camel@tvboxspy>
In-Reply-To: <1289155850.4638.7.camel@tvboxspy>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011102042.22556.zzam@gentoo.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 07 November 2010, Malcolm Priestley wrote:
> On Sun, 2010-11-07 at 14:57 +0100, Matthias Schwarzott wrote:
> > Hello Malcolm!
> > 
> > It seems that ix2505v driver ignores a i2c error in
> > ix2505v_read_status_reg. This looks like a typing error using (ret = 1)
> > instead of correct (ret == 1).
> > 
> > The attached patch fixes this.
> 
> Hi Matthias,
> 
> Thanks for picking that up.
> 
> Acked-by: Malcolm Priestley <tvboxspy@gmail.com>
> 

I forgot the SOB, so here it is:
Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Regards
Matthias

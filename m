Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:52150 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3GKA3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 20:29:42 -0400
Received: by mail-ee0-f54.google.com with SMTP id t10so5199546eei.13
        for <linux-media@vger.kernel.org>; Wed, 10 Jul 2013 17:29:41 -0700 (PDT)
Message-ID: <1373502575.14147.1.camel@maxim-laptop>
Subject: Re: rc: ene_ir: few fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-media@vger.kernel.org
Date: Thu, 11 Jul 2013 03:29:35 +0300
In-Reply-To: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
References: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any update?

Best regards,
Maxim Levitsky


On Mon, 2013-07-08 at 03:22 +0300, Maxim Levitsky wrote: 
> Hi,
> 
> Could you consider merging few fixes to my driver:
> 
> 1. Fix accidently introduced error, that is the hardware is a bit unusual
> in the way that it needs the interrupt number, and one of the recent patches
> moved the irq number read to be too late for that.
> 
> 2. I just now played with my remote that wakes the system, and noticed that
> it wakes the system even if I disable the wake bit.
> Just disable the device if wake is disabled, and this fixes the issue.
> 
> 3. I noticed that debug prints from my driver don't work anymore,
> and this is due to conversion to pr_dbg, which is in my opinion too restructive in
> enabling it.
> If you allow, I want to use pr_info instead.
> 
> patch #1 should go to stable as well, as it outright breaks my driver.
> 
> PS: I am very short on time, and I will be free in about month, after I pass
> another round of exams.
> 
> Best regards,
> 	Maxim Levitsky
> 

-- 
Best regards,
        Maxim Levitsky

Visit my blog: http://maximlevitsky.wordpress.com
Warning: Above blog contains rants.


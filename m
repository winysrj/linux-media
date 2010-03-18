Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61050 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab0CROJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 10:09:47 -0400
Received: by bwz1 with SMTP id 1so2080117bwz.21
        for <linux-media@vger.kernel.org>; Thu, 18 Mar 2010 07:09:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BA1F9C6.3020807@motama.com>
References: <4BA10639.3000407@motama.com> <4BA1F9C6.3020807@motama.com>
Date: Thu, 18 Mar 2010 10:09:45 -0400
Message-ID: <829197381003180709t26f76b38y7e641b8c12a2d33d@mail.gmail.com>
Subject: Re: Problems with ngene based DVB cards (Digital Devices Cine S2 Dual
	DVB-S2 , Mystique SaTiX S2 Dual)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Besse <besse@motama.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 18, 2010 at 6:00 AM, Andreas Besse <besse@motama.com> wrote:
> Hello,
>
> We are now able to reproduce the problem faster and easier (using the
> patched version of szap-s2 and the scripts included in the tar.gz :
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17334
> and
> http://cache.gmane.org//gmane/linux/drivers/video-input-infrastructure/17334-001.bin
> )

This is pretty interesting.  I'm doing some ngene work over the next
few weeks, so I will see if I can reproduce the behavior you are
seeing here.

I noticed  that you are manually setting the "one_adapter=0" modprobe
setting.  Does this have any bearing on the test results?

Dvein



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

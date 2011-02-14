Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:8654 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1BNIFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 03:05:20 -0500
Date: Mon, 14 Feb 2011 09:05:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mark Zimmerman <markzimm@frii.com>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
Subject: Re: [corrected get-bisect results]: DViCO FusionHDTV7 Dual Express
 I2C  write failed
Message-ID: <20110214090509.7b340214@endymion.delvare>
In-Reply-To: <20110213144758.GA79915@io.frii.com>
References: <20101207190753.GA21666@io.frii.com>
	<20110212152954.GA20838@io.frii.com>
	<20110213144758.GA79915@io.frii.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mark,

On Sun, 13 Feb 2011 07:47:59 -0700, Mark Zimmerman wrote:
> Clearly my previous bisection went astray; I think I have a more
> sensible result this time.
> 
> qpc$ git bisect good
> 44835f197bf1e3f57464f23dfb239fef06cf89be is the first bad commit
> commit 44835f197bf1e3f57464f23dfb239fef06cf89be
> Author: Jean Delvare <khali@linux-fr.org>
> Date:   Sun Jul 18 16:52:05 2010 -0300
> 
>     V4L/DVB: cx23885: Check for slave nack on all transactions
>     
>     Don't just check for nacks on zero-length transactions. Check on
>     other transactions too.
>     
>     Signed-off-by: Jean Delvare <khali@linux-fr.org>
>     Signed-off-by: Andy Walls <awalls@md.metrocast.net>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

I'm sorry for the trouble :( I should probably refrain from writing
patches for media drivers I don't own.

-- 
Jean Delvare

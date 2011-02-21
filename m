Return-path: <mchehab@pedra>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:33414 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab1BUN5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 08:57:13 -0500
Date: Mon, 21 Feb 2011 15:57:09 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: balbi@ti.com, David Cohen <dacohen@gmail.com>,
	linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
Message-ID: <20110221135709.GG23087@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
 <1298283649-24532-2-git-send-email-dacohen@gmail.com>
 <AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
 <20110221123049.GC23087@legolas.emea.dhcp.ti.com>
 <AANLkTinc=ye2qZJ1esSta=xEGz_iEr73eg3qEES2S5P7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinc=ye2qZJ1esSta=xEGz_iEr73eg3qEES2S5P7@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Mon, Feb 21, 2011 at 03:51:25PM +0200, Alexey Dobriyan wrote:
> > I rather have the split done and kill the circular dependency.
> 
> It's not circular for starters.

how come ? wait.h depends on sched and sched.h depends on wait.h

-- 
balbi

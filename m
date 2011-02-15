Return-path: <mchehab@pedra>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:45550 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754752Ab1BOLx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 06:53:57 -0500
Date: Tue, 15 Feb 2011 13:53:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: Thomas Weber <weber@corscience.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, balbi@ti.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-omap@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
Message-ID: <20110215115349.GQ2570@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297068547-10635-1-git-send-email-weber@corscience.de>
 <4D5A6353.7040907@maxwell.research.nokia.com>
 <20110215113717.GN2570@legolas.emea.dhcp.ti.com>
 <4D5A672A.7040000@samsung.com>
 <4D5A6874.1080705@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5A6874.1080705@corscience.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Tue, Feb 15, 2011 at 12:50:12PM +0100, Thomas Weber wrote:
> Hello Felipe,
> 
> in include/linux/wait.h
> 
> #define wake_up(x)            __wake_up(x, TASK_NORMAL, 1, NULL)

aha, now I get it, so shouldn't the real fix be including <linux/sched.h>
on <linux/wait.h>, I mean, it's <linuux/wait.h> who uses a symbol
defined in <linux/sched.h>, right ?

-- 
balbi

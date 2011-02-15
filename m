Return-path: <mchehab@pedra>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:40759 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363Ab1BOLrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 06:47:17 -0500
Date: Tue, 15 Feb 2011 13:47:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: balbi@ti.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
Message-ID: <20110215114710.GP2570@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297068547-10635-1-git-send-email-weber@corscience.de>
 <4D5A6353.7040907@maxwell.research.nokia.com>
 <20110215113717.GN2570@legolas.emea.dhcp.ti.com>
 <4D5A672A.7040000@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5A672A.7040000@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hi,

On Tue, Feb 15, 2011 at 12:44:42PM +0100, Sylwester Nawrocki wrote:
> > Are we using the same tree ? I don't see anything related to TASK_* on
> 
> Please have a look at definition of macro wake_up. This where those
> TASK_* flags are used.

$ git grep -e TASK_ drivers/media/video/omap*.[ch]
$ 

???

-- 
balbi

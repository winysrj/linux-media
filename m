Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50000 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaGILqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 07:46:07 -0400
Date: Wed, 9 Jul 2014 13:46:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Anil Belur <askb23@gmail.com>
Cc: m.chehab@samsung.com, dan.carpenter@oracle.com,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: nokia_h4p: nokia_core.c - removed
 IRQF_DISABLED macro
Message-ID: <20140709114605.GB22777@amd.pavel.ucw.cz>
References: <1404885998-10981-1-git-send-email-askb23@gmail.com>
 <1404885998-10981-2-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404885998-10981-2-git-send-email-askb23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 2014-07-09 11:36:38, Anil Belur wrote:
> From: Anil Belur <askb23@gmail.com>
> 
> - this patch removes the IRQF_DISABLED macro, as this is
>   deprecated/noop.
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

I wonder if it would maek sense to do

./include/linux/interrupt.h:#define IRQF_DISABLED	0

to make it extra clear that it is nop now?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

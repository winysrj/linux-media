Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40251 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbaDCVrA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 17:47:00 -0400
Date: Thu, 3 Apr 2014 23:46:56 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	james.hogan@imgtec.com
Subject: Re: [GIT PULL for v3.15-rc1] media updates
Message-ID: <20140403214656.GA4662@hardeman.nu>
References: <20140403131143.69f324c7@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140403131143.69f324c7@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 03, 2014 at 01:11:43PM -0300, Mauro Carvalho Chehab wrote:
>Hi Linus,
>
>Please pull from:
>  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
...
>James Hogan (27):
...
>      [media] media: rc: add sysfs scancode filtering interface
>      [media] media: rc: change 32bit NEC scancode format
...
>      [media] rc-main: add generic scancode filtering

Umm...we (mostly James and I, but you as well) have been discussing on
the linux-media whether those patches shouldn't be reverted...this pull
request seems to have overlooked that discussion...or have I missed
something?

-- 
David Härdeman

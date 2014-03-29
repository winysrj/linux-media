Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38327 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaC2QPm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 12:15:42 -0400
Date: Sat, 29 Mar 2014 17:15:40 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Subject: Re: [PATCH 1/3] rc-main: Revert generic scancode filtering support
Message-ID: <20140329161540.GB13387@hardeman.nu>
References: <1395868113-17950-1-git-send-email-james.hogan@imgtec.com>
 <1395868113-17950-2-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395868113-17950-2-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 26, 2014 at 09:08:31PM +0000, James Hogan wrote:
>This reverts commit b8c7d915087c ([media] rc-main: add generic scancode
>filtering), and removes certain parts of commit 6bea25af147f ([media]
>rc-main: automatically refresh filter on protocol change) where generic
>filtering is taken into account when refreshing filters on a protocol
>change, but that code cannot be reached any longer since the filter mask
>will always be zero if the s_filter callback is NULL.

I think it'd be a more complete fix to make sure the sysfs files aren't
even there if there's no hw support. See the patchset I've just
posted...

Regards,
David


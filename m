Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:42324 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757743AbaFSJFm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 05:05:42 -0400
Date: Thu, 19 Jun 2014 11:05:40 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Niels Laukens <niels@dest-unreach.be>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
	Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Subject: Re: [PATCH 1/2] drivers/media/rc/ir-nec-decode : add toggle feature
Message-ID: <20140619090540.GC13952@hardeman.nu>
References: <53A29E5A.9030304@dest-unreach.be>
 <53A29E79.2000304@dest-unreach.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A29E79.2000304@dest-unreach.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 19, 2014 at 10:25:29AM +0200, Niels Laukens wrote:
>Made the distinction between repeated key presses, and a single long
>press. The NEC-protocol does not have a toggle-bit (cfr RC5/RC6), but
>has specific repeat-codes.

Not all NEC remotes use repeat codes. Some just transmit the full code
at fixed intervals...IIRC, Pioneer remotes is (was?) one example... 

>This patch identifies a repeat code, and skips the scancode calculations
>and the rc_keydown() in that case. In the case of a full code, it makes
>sure that the rc_keydown() is regarded as a new event by using the
>toggle feature.

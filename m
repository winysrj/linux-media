Return-path: <linux-media-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:49915 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbbKZPWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2015 10:22:49 -0500
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-media@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Thu, 26 Nov 2015 08:22:48 -0700
Date: Thu, 26 Nov 2015 07:23:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: reservation.h: build error with lockdep disabled
Message-ID: <20151126152317.GL26643@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20151126134340.GB8644@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151126134340.GB8644@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2015 at 01:43:40PM +0000, Russell King - ARM Linux wrote:
> As of 3c3b177a9369 ("reservation: add suppport for read-only access
> using rcu") linux/reservation.h uses lockdep macros:
> 
> +#define reservation_object_held(obj) lockdep_is_held(&(obj)->lock.base)
> 
> This results in build errors when lockdep is disabled as lockdep_is_held()
> is only available when lockdep is enabled.  This has been reported today
> to break the etnaviv kernel driver, which we're hoping to submit for 4.5.
> 
> As this gets used with rcu_dereference_protected(), eg:
> 
> static inline struct reservation_object_list *
> reservation_object_get_list(struct reservation_object *obj)
> {
>         return rcu_dereference_protected(obj->fence,
>                                          reservation_object_held(obj));
> }
> 
> I'm guessing that it's not going to be a simple case of making it always
> return true or always return false.
> 
> Any ideas how to solve this?

The usual approach is something like this:

#ifdef CONFIG_PROVE_LOCKING
#define reservation_object_held(obj) lockdep_is_held(&(obj)->lock.base)
#else
#define reservation_object_held(obj) true
#endif

							Thanx, Paul


Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:59888 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbbKZNnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2015 08:43:55 -0500
Date: Thu, 26 Nov 2015 13:43:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: reservation.h: build error with lockdep disabled
Message-ID: <20151126134340.GB8644@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As of 3c3b177a9369 ("reservation: add suppport for read-only access
using rcu") linux/reservation.h uses lockdep macros:

+#define reservation_object_held(obj) lockdep_is_held(&(obj)->lock.base)

This results in build errors when lockdep is disabled as lockdep_is_held()
is only available when lockdep is enabled.  This has been reported today
to break the etnaviv kernel driver, which we're hoping to submit for 4.5.

As this gets used with rcu_dereference_protected(), eg:

static inline struct reservation_object_list *
reservation_object_get_list(struct reservation_object *obj)
{
        return rcu_dereference_protected(obj->fence,
                                         reservation_object_held(obj));
}

I'm guessing that it's not going to be a simple case of making it always
return true or always return false.

Any ideas how to solve this?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

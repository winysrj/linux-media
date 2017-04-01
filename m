Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36900 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751267AbdDAJki (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Apr 2017 05:40:38 -0400
Date: Sat, 1 Apr 2017 10:39:00 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Patrice.chotard@st.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv6 01/10] media: add CEC notifier support
Message-ID: <20170401093900.GX7909@n2100.armlinux.org.uk>
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
 <20170331122036.55706-2-hverkuil@xs4all.nl>
 <20170331204629.GV7909@n2100.armlinux.org.uk>
 <dabb03d5-1631-aab3-259e-7f02ad60f571@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dabb03d5-1631-aab3-259e-7f02ad60f571@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 01, 2017 at 11:22:03AM +0200, Hans Verkuil wrote:
> On 31/03/17 22:46, Russell King - ARM Linux wrote:
> > On Fri, Mar 31, 2017 at 02:20:27PM +0200, Hans Verkuil wrote:
> >> +struct cec_notifier *cec_notifier_get(struct device *dev)
> >> +{
> >> +	struct cec_notifier *n;
> >> +
> >> +	mutex_lock(&cec_notifiers_lock);
> >> +	list_for_each_entry(n, &cec_notifiers, head) {
> >> +		if (n->dev == dev) {
> >> +			mutex_unlock(&cec_notifiers_lock);
> >> +			kref_get(&n->kref);
> > 
> > Isn't this racy?  What stops one thread trying to get the notifier
> > while another thread puts the notifier?
> > 
> 
> Both get and put take the global cec_notifiers_lock mutex.

No, that doesn't help:

Thread 0			Thread 1
mutex_lock()
list_for_each_entry()
if()
mutex_unlock()
				mutex_lock()
				kref_put()
					list_del()
					kfree()
				mutex_unlock()
kref_get()

So, it's possible that kref_get() can be called on kfree'd memory.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

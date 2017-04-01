Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:52131 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751095AbdDAJWH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Apr 2017 05:22:07 -0400
Subject: Re: [PATCHv6 01/10] media: add CEC notifier support
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
 <20170331122036.55706-2-hverkuil@xs4all.nl>
 <20170331204629.GV7909@n2100.armlinux.org.uk>
Cc: linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Patrice.chotard@st.com, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dabb03d5-1631-aab3-259e-7f02ad60f571@xs4all.nl>
Date: Sat, 1 Apr 2017 11:22:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170331204629.GV7909@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/03/17 22:46, Russell King - ARM Linux wrote:
> On Fri, Mar 31, 2017 at 02:20:27PM +0200, Hans Verkuil wrote:
>> +struct cec_notifier *cec_notifier_get(struct device *dev)
>> +{
>> +	struct cec_notifier *n;
>> +
>> +	mutex_lock(&cec_notifiers_lock);
>> +	list_for_each_entry(n, &cec_notifiers, head) {
>> +		if (n->dev == dev) {
>> +			mutex_unlock(&cec_notifiers_lock);
>> +			kref_get(&n->kref);
> 
> Isn't this racy?  What stops one thread trying to get the notifier
> while another thread puts the notifier?
> 

Both get and put take the global cec_notifiers_lock mutex.

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:53274 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758490AbcLPSU7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 13:20:59 -0500
Date: Fri, 16 Dec 2016 13:20:57 -0500 (EST)
Message-Id: <20161216.132057.1771215556712298530.davem@davemloft.net>
To: gvrose8192@gmail.com
Cc: henrik@austad.us, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, haustad@cisco.com,
        linux-media@vger.kernel.org, alsa-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [TSN RFC v2 0/9] TSN driver for the kernel
From: David Miller <davem@davemloft.net>
In-Reply-To: <1481911964.3572.1.camel@gmail.com>
References: <1481911153-549-1-git-send-email-henrik@austad.us>
        <1481911964.3572.1.camel@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Greg <gvrose8192@gmail.com>
Date: Fri, 16 Dec 2016 10:12:44 -0800

> On Fri, 2016-12-16 at 18:59 +0100, henrik@austad.us wrote:
>> From: Henrik Austad <haustad@cisco.com>
>> 
>> 
>> The driver is directed via ConfigFS as we need userspace to handle
>> stream-reservation (MSRP), discovery and enumeration (IEEE 1722.1) and
>> whatever other management is needed. This also includes running an
>> appropriate PTP daemon (TSN favors gPTP).
> 
> I suggest using a generic netlink interface to communicate with the
> driver to set up and/or configure your drivers.
> 
> I think configfs is frowned upon for network drivers.  YMMV.

Agreed.

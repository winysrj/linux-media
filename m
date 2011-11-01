Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab1KANl2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Nov 2011 09:41:28 -0400
Message-ID: <4EAFF719.4020301@redhat.com>
Date: Tue, 01 Nov 2011 14:41:45 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] v4l2-event: Remove pending events from fh event queue
 when unsubscribing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

hverkuil wrote:

 > > This patch fixes these dangling pointers in the available queue by removing
 > > all matching pending events on unsubscription.
 >
 > The idea is fine, but the implementation is inefficient.
 >
 > Instead of the list_for_each_entry_safe you can just do:
 >
 >	for (i = 0; i < sev->in_use; i++) {
 >		list_del(&sev->events[sev_pos(sev, i)].list);
 >		fh->navailable--;
 >	}
 >
 > It's untested, but this should do the trick.

Agreed, I've modified my patch to use this construction instead.

Regards,

Hans

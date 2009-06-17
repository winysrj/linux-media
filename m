Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36291 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZFQG6p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 02:58:45 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5H6wm3o027900
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 02:58:48 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5H6wSNe005395
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 02:58:34 -0400
Received: from localhost.localdomain (vpn-10-20.str.redhat.com [10.32.10.20])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5H6wR9Z015402
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 02:58:27 -0400
Message-ID: <4A38947E.5060405@redhat.com>
Date: Wed, 17 Jun 2009 09:00:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Convert cpia driver to v4l2, drop parallel port version support?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently have been bying second hand usb webcams left and right
one of them (a creative unknown model) uses the cpia1 chipset, and
works with the v4l1 driver currently in the kernel.

One of these days I would like to convert it to a v4l2 driver using
gspca as basis, this however will cause us to use parallel port support
(that or we need to keep the old code around for the parallel port
version).

I personally think that loosing support for the parallel port
version is ok given that the parallel port itslef is rapidly
disappearing, what do you think ?

Regards,

Hans

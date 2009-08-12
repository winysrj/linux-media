Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38253 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbZHLHxD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 03:53:03 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n7C7r3Ei027869
	for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 03:53:03 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7C7r2Sw017291
	for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 03:53:02 -0400
Received: from localhost.localdomain (vpn-12-6.rdu.redhat.com [10.11.12.6])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n7C7r1JF002570
	for <linux-media@vger.kernel.org>; Wed, 12 Aug 2009 03:53:02 -0400
Message-ID: <4A827613.2060908@hhs.nl>
Date: Wed, 12 Aug 2009 09:58:11 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: linuxtv.org wiki: V4L2_Userspace_Library hopelessly out of date
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Can someone please kill:
http://linuxtv.org/wiki/index.php/V4L2_Userspace_Library

It still talks about the old complex proxy device and daemon
using plans for a V4L2_Userspace_Library, now that we have
libv4l this is pretty much obsolete.

Yes having a new wiki page for libv4l would be great! Sorry
-ENOTIME, but anyone can do this, the README of libv4l should
make for a good start.

Regards,

Hans

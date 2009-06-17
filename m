Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54479 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbZFQGwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 02:52:31 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5H6qYwh026363
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 02:52:34 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5H6qY5r004290
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 02:52:34 -0400
Received: from localhost.localdomain (vpn-10-20.str.redhat.com [10.32.10.20])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5H6qWCS014754
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 02:52:33 -0400
Message-ID: <4A38931C.2060506@redhat.com>
Date: Wed, 17 Jun 2009 08:54:20 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: How to handle v4l1 -> v4l2 driver transition
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've recently been working on adding support for cams with the
ov511(+) and ov518(+) to the gspca ov519 driver. I'm happy to
announce that work is finished, see:
http://linuxtv.org/hg/~hgoede/gspca

And the pull request I just send. This does lead to the question
what to do with the existing  in kernel v4l1 ov511 driver, which
claims to support these 2 bridges too (but since the decompression
code has been removed actually only works with the 511 in uncompressed
mode).

It is clear that the ov518 usb-id's should be removed from the ov511
driver. But that still leaves the ov511 support, we could just completely
remove the ov511 driver, as the code in gspca should cover all supported
devices (and his been tested with a few).

However the downside of removing it is that people who used to have
a working ov511 setup now will need to have a (very recent) libv4l
to keep their setup working.

So I guess that the best way forward is to mark the driver as deprecated
now and remove it in say 2 releases?

Regards,

Hans

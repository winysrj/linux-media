Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([67.18.66.25]:56492 "EHLO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab3KATma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Nov 2013 15:42:30 -0400
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway07.websitewelcome.com (Postfix) with ESMTP id 487E1C8252757
	for <linux-media@vger.kernel.org>; Fri,  1 Nov 2013 13:54:31 -0500 (CDT)
Message-ID: <5273F8F2.5070901@sensoray.com>
Date: Fri, 01 Nov 2013 11:54:42 -0700
From: Pete Eberlein <pete@sensoray.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: viro@ZenIV.linux.org.uk, mchehab@redhat.com
Subject: videobuf mmap deadlock
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch "videobuf_vm_{open,close} race fixes" 
https://linuxtv.org/patch/18365/ introduced a deadlock in 3.11.

My driver uses videobuf_vmalloc initialized with ext_lock set to NULL.
My driver's mmap function calls videobuf_mmap_mapper
videobuf_mmap_mapper calls videobuf_queue_lock on q
videobuf_mmap_mapper calls  __videobuf_mmap_mapper
  __videobuf_mmap_mapper calls videobuf_vm_open
videobuf_vm_open calls videobuf_queue_lock on q (introduced by above patch)
deadlocked

This is not an issue if ext_lock is non-NULL, since videobuf_queue_lock 
is a no-op in that case.

Did I do something wrong, or is this a valid regression?

Regards,
Pete Eberlein

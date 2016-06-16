Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38578 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbcFPQGp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 12:06:45 -0400
Subject: Re: [PATCH 1/3] drivers/media/dvb-core/en50221: use kref to manage
 struct dvb_ca_private
To: Max Kellermann <max@duempel.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5762CE93.3080404@osg.samsung.com>
Date: Thu, 16 Jun 2016 10:06:43 -0600
MIME-Version: 1.0
In-Reply-To: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2016 02:15 PM, Max Kellermann wrote:
> Don't free the object until the file handle has been closed.  Fixes
> use-after-free bug which occurs when I disconnect my DVB-S received
> while VDR is running.

Which file handle? /dev/dvb---

There seems to be a problem in the driver release routine:
dvb_ca_en50221_release() routine:

	kfree(ca->slot_info);
	dvb_unregister_device(ca->dvbdev);
	kfree(ca);

I think this should be since ioctl references slot info

	dvb_unregister_device(ca->dvbdev);
	kfree(ca->slot_info);
	kfree(ca);

I think dvb_ca_en50221_release() and dvb_ca_en50221_io_do_ioctl()
should serialize access to ca. dvb_ca_en50221_io_do_ioctl() holds
the ioctl_mutex, however, dvb_ca_en50221_release() could happen while
ioctl is in progress. Maybe you can try fixing those first.

As I mentioned in my review on your 3/3 patch, adding a kref here
adds more refcounted objects to the mix. You want to avoid that.

thanks,
-- Shuah

Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:60443 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbcFPShs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 14:37:48 -0400
Date: Thu, 16 Jun 2016 20:37:45 +0200
From: Max Kellermann <max@duempel.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/media/dvb-core/en50221: use kref to manage
 struct dvb_ca_private
Message-ID: <20160616183745.GA3727@swift.blarg.de>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <5762CE93.3080404@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5762CE93.3080404@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016/06/16 18:06, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> On 06/15/2016 02:15 PM, Max Kellermann wrote:
> > Don't free the object until the file handle has been closed.  Fixes
> > use-after-free bug which occurs when I disconnect my DVB-S received
> > while VDR is running.
> 
> Which file handle? /dev/dvb---

I don't know which one triggers it.  I get crashes with VDR, and VDR
opens all of them (ca0, demux0, frontend0), but won't release the file
handles even if they become defunct.  Only restarting the VDR process
leads to recovery (or crash).

> I think dvb_ca_en50221_release() and dvb_ca_en50221_io_do_ioctl()
> should serialize access to ca. dvb_ca_en50221_io_do_ioctl() holds
> the ioctl_mutex, however, dvb_ca_en50221_release() could happen while
> ioctl is in progress. Maybe you can try fixing those first.

True, there are LOTS of race conditions in the DVB code.  I see them
everywhere.  But that's orthogonal to my patch, isn't it?

> As I mentioned in my review on your 3/3 patch, adding a kref here
> adds more refcounted objects to the mix. You want to avoid that.

Mauro asked me to add the kref.  What is your suggestion to fix the
use-after-free bug?

I have a problem here, as mentioned in my last email: I don't know how
all of this is supposed to be, how it was designed; all I see is bugs
inside strange code, and I have to guess the previous author's
intentions and try to do the best to fix the code.

Max

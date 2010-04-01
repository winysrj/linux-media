Return-path: <linux-media-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44923 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0DAMIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 08:08:17 -0400
Message-ID: <4BB48CA3.1070109@s5r6.in-berlin.de>
Date: Thu, 01 Apr 2010 14:08:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl>
In-Reply-To: <201004011001.10500.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On the DVB side there seem to be only two sources that use the BKL:
> 
> linux/drivers/media/dvb/bt8xx/dst_ca.c: lock_kernel();
> linux/drivers/media/dvb/bt8xx/dst_ca.c: unlock_kernel();

This is from an incomplete conversion from .ioctl to .unlocked_ioctl (no
conversion really, only a BKL push-down).

> linux/drivers/media/dvb/dvb-core/dvbdev.c:      lock_kernel();
> linux/drivers/media/dvb/dvb-core/dvbdev.c:              unlock_kernel();
> linux/drivers/media/dvb/dvb-core/dvbdev.c:      unlock_kernel();

This is from when the BKL was pushed down into drivers' open() methods.
To remove BKL from open(), check for possible races with module
insertion.  (A driver's module_init has to have set up everything that's
going to be used by open() before the char device is being registered.)

Apart from those two BKL uses in media/dvb/, there are also
  - remaining .ioctl that need to be checked for possible concurrency
    issues, then converted to .unlocked_ioctl,
  - remaining .llseek uses (all implicit) which need to be checked
    whether they should be no_llseek() (accompanied by nonseekable_open)
    or generic_file_llseek() or default_llseek().
-- 
Stefan Richter
-=====-==-=- -=-- ----=
http://arcgraph.de/sr/

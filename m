Return-path: <linux-media-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44944 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0DAMMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 08:12:48 -0400
Message-ID: <4BB48DB3.9010304@s5r6.in-berlin.de>
Date: Thu, 01 Apr 2010 14:12:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl> <4BB48CA3.1070109@s5r6.in-berlin.de>
In-Reply-To: <4BB48CA3.1070109@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
>> linux/drivers/media/dvb/dvb-core/dvbdev.c:      lock_kernel();
>> linux/drivers/media/dvb/dvb-core/dvbdev.c:              unlock_kernel();
>> linux/drivers/media/dvb/dvb-core/dvbdev.c:      unlock_kernel();
> 
> This is from when the BKL was pushed down into drivers' open() methods.
> To remove BKL from open(), check for possible races with module
> insertion.  (A driver's module_init has to have set up everything that's
> going to be used by open() before the char device is being registered.)

Last sentence was supposed to mean:  Before the char device is being
registered, a driver's module_init has to have set up everything that's
going to be used by openers of the file.

(Traditionally, the BKL serialized open() with module initialization,
which was not obvious to driver writers because it happened deep in the
core kernel.)
-- 
Stefan Richter
-=====-==-=- -=-- ----=
http://arcgraph.de/sr/

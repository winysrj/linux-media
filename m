Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35842 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab0DCOTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Apr 2010 10:19:55 -0400
Message-ID: <4BB74E77.7010703@s5r6.in-berlin.de>
Date: Sat, 03 Apr 2010 16:19:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: V4L-DVB drivers and BKL
References: <201004011001.10500.hverkuil@xs4all.nl> <4BB4A7C6.40207@redhat.com>
In-Reply-To: <4BB4A7C6.40207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
>> On the DVB side there seem to be only two sources that use the BKL:
>>
>> linux/drivers/media/dvb/bt8xx/dst_ca.c: lock_kernel();
>> linux/drivers/media/dvb/bt8xx/dst_ca.c: unlock_kernel();
>> linux/drivers/media/dvb/dvb-core/dvbdev.c:      lock_kernel();
>> linux/drivers/media/dvb/dvb-core/dvbdev.c:              unlock_kernel();
>> linux/drivers/media/dvb/dvb-core/dvbdev.c:      unlock_kernel();
>>
>> At first glance it doesn't seem too difficult to remove them, but I leave
>> that to the DVB experts.
> 
> The main issue is at dvbdev, since it is used by all devices. We need to get rid
> of it.

Get rid of its lock_kernel in open and its locked ioctl, or of the
dvbdev 'library' itself?

> That's said, Stefan Richter sent a patch meant to reduce the issues with
> DVB. Unfortunately, I haven't seen any comments on it. It would be really important
> to test his approach.

I will attempt to continue with this (convert more drivers if not all,
in a properly organized patch series for review), though it won't happen
overnight as I'm chronically short of spare time.  I.e. if others step
in, even better.
-- 
Stefan Richter
-=====-==-=- -=-- ---==
http://arcgraph.de/sr/

Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:5995 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804Ab1AKNO2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 08:14:28 -0500
Subject: Re: [GIT PATCHES FOR 2.6.38] Implement core priority handling
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201101110921.36394.hverkuil@xs4all.nl>
References: <201101110921.36394.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 08:15:14 -0500
Message-ID: <1294751714.2075.13.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-01-11 at 09:21 +0100, Hans Verkuil wrote:
> This implements core support for priority handling. This is basically the same
> as my RFCv3 patch series, except without some of the driver changes (I want to
> do that for 2.6.39) and with the single fix to patch 05/16 I posted to the list.
> 
> Currently the only drivers this affects are ivtv (which is the only user of
> v4l2_fh at the moment) and vivi.
> 
> I will probably also adapt cx18 this weekend since as it stands now it is possible
> for a lower prio process to change controls for a higher prio process. To fix
> this requires core prio handling anyway, so let's get this in for 2.6.38 so
> people can start using it.

Have fun.  I have no pending cx18 patches that would possibly conflict.

off topic:
I'm still working on a software UART driver pet project.  Satisfying the
Linux tty subsystem's internal interface requirements, and understanding
tty subsystem internal behaviors and locking, is shaping up to be more
work than writing the soft-uart itself.

Regards,
Andy



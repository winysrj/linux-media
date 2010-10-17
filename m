Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:7052 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab0JQXpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 19:45:18 -0400
Subject: Re: [GIT PATCHES FOR 2.6.36] Fix msp3400 regression causing mute
 audio
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Shane Shrybman <shrybman@teksavvy.com>,
	ivtv-devel@ivtvdriver.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <201010171243.39520.hverkuil@xs4all.nl>
References: <201010171243.39520.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 19:44:54 -0400
Message-ID: <1287359094.2320.13.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-10-17 at 12:43 +0200, Hans Verkuil wrote:
> Hi Mauro,
> 
> I hope you can fast-track this to Linus! It's a nasty regression. From the log:
> 
> "The switch to the new control framework caused a regression where the audio was
> no longer unmuted after the carrier scan finished.
> 
> The original code attempted to set the volume control to its current value in
> order to have the set-volume control code to be called that handles the volume
> and muting. However, the framework will not call that code unless the new volume
> value is different from the old.

> Thanks to Andy Walls for bisecting this and to Shane Shrybman for reporting it!"

Hans,

Thanks for the prompt fix.

Regards,
Andy



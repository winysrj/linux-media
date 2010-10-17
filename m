Return-path: <mchehab@pedra>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:37450 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757371Ab0JQRDd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 13:03:33 -0400
Subject: Re: [GIT PATCHES FOR 2.6.36] Fix msp3400 regression causing mute
	audio
From: Shane Shrybman <shrybman@teksavvy.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	ivtv-devel@ivtvdriver.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <201010171243.39520.hverkuil@xs4all.nl>
References: <201010171243.39520.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 17 Oct 2010 12:53:44 -0400
Message-Id: <1287334424.3593.3.camel@mars>
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
> 
> Instead we now call msp_s_ctrl directly.
> 
> It is a bit of a hack: we really need a v4l2_ctrl_refresh_ctrl function for this
> (or something along those lines).
> 
> Thanks to Andy Walls for bisecting this and to Shane Shrybman for reporting it!"
> 
> I've tested this with my PVR-350 and the audio is now working properly again.
> 

I've done a quick test of this patch on 2.6.36-rc8 and confirm it fixes
the no audio issue.

Thanks very much Andy and Hans.

Shane



Return-path: <mchehab@gaivota>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3847 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab1ACTpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 14:45:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [RFCv2 PATCH 07/10] radio-mr800: remove autopm support.
Date: Mon, 3 Jan 2011 20:44:22 +0100
Cc: linux-media@vger.kernel.org
References: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl> <910fe6472dfab87e56c5fa6245c233ff4f0d7ea9.1294078230.git.hverkuil@xs4all.nl> <AANLkTikzj92f35VmrGTyPSN4yc4v53O3yGtL4ujL-tKu@mail.gmail.com>
In-Reply-To: <AANLkTikzj92f35VmrGTyPSN4yc4v53O3yGtL4ujL-tKu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101032044.22187.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, January 03, 2011 20:09:03 David Ellingsworth wrote:
> From my understanding, auto power management is for automatically
> suspending and resuming a driver whenever it is idle. Obviously this
> is a bad for this type of driver as it would turn off the radio
> whenever it was idle. It is not necessary to remove suspend/resume
> support in order to drop auto power management from this driver.

You are completely correct. The mr800 conversion was quick and dirty and
was meant to demonstrate how to add priority support in this driver.

The final version will only remove the autopm, not the suspend/resume.

Regards,

	Hans

> In
> fact doing so would be a mistake in my opinion. The current
> suspend/resume cycle ensures the radio if off during suspend, and
> restores it's last state during resume. These changes would leave the
> radio in it's current state, consuming power if it were on, while the
> system is suspended. This is a drastic deviation from the current
> behavior and would most likely not be appreciated by users that expect
> the device to go off during suspend and back on after resume. I NACK
> this change due to the complete removal of suspend/resume support.
> 
> Regards,
> 
> David Ellingsworth
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

Return-path: <mchehab@gaivota>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59029 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1ACTJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 14:09:04 -0500
Received: by gwj20 with SMTP id 20so6272845gwj.19
        for <linux-media@vger.kernel.org>; Mon, 03 Jan 2011 11:09:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <910fe6472dfab87e56c5fa6245c233ff4f0d7ea9.1294078230.git.hverkuil@xs4all.nl>
References: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
	<1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
	<910fe6472dfab87e56c5fa6245c233ff4f0d7ea9.1294078230.git.hverkuil@xs4all.nl>
Date: Mon, 3 Jan 2011 14:09:03 -0500
Message-ID: <AANLkTikzj92f35VmrGTyPSN4yc4v53O3yGtL4ujL-tKu@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 07/10] radio-mr800: remove autopm support.
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

>From my understanding, auto power management is for automatically
suspending and resuming a driver whenever it is idle. Obviously this
is a bad for this type of driver as it would turn off the radio
whenever it was idle. It is not necessary to remove suspend/resume
support in order to drop auto power management from this driver. In
fact doing so would be a mistake in my opinion. The current
suspend/resume cycle ensures the radio if off during suspend, and
restores it's last state during resume. These changes would leave the
radio in it's current state, consuming power if it were on, while the
system is suspended. This is a drastic deviation from the current
behavior and would most likely not be appreciated by users that expect
the device to go off during suspend and back on after resume. I NACK
this change due to the complete removal of suspend/resume support.

Regards,

David Ellingsworth

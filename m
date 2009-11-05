Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1733 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbZKENS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 08:18:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: matti.j.aaltonen@nokia.com
Subject: Re: A driver for TI WL1273 FM Radio
Date: Thu, 5 Nov 2009 14:18:28 +0100
Cc: Linux-Media <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com> <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com> <1256283953.5953.148.camel@masi.ntc.nokia.com>
In-Reply-To: <1256283953.5953.148.camel@masi.ntc.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051418.28467.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 October 2009 09:45:53 m7aalton wrote:
> Hi.
> 
> I have written a driver for the TI WL1273 FM Radio but it's not yet
> quite ready for up-streaming because of its interface. Now I've started
> to change the interface to v4l2 and I'm following Eduardo Valentin's
> Si4713 TX driver as an example. However, WL1273 radio has RX and TX so
> there are things that Eduardo's driver doesn't cover. For example: the
> driver needs a mode switch for switching between TX and RX. Should that
> be implemented as an extended control or should there be a new IOCTL
> added to the v4l2 API? etc...

So if I understand this correctly, then this device can only transmit or
receive, but not both at the same time?

If that's the case, then I wonder if it isn't enough to let it depend on
whether VIDIOC_S_AUDOUT or VIDIOC_S_AUDIO was called last.

> Also I've added some things to the ivtv-radio tool. Should I try to
> "up-stream" those as well?

Perhaps we should take the opportunity to merge this tool as v4l2-radio
into the v4l2-apps/util directory of the master v4l-dvb repository.

It would be really nice if it can be used to test the transmitter
features and RDS receiver as well, i.e. extending and improving this tool.

I like having such fairly low-level and easy to debug utilities. They are
a great tool to verify the proper functioning of hardware like this.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

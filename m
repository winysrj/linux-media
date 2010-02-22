Return-path: <linux-media-owner@vger.kernel.org>
Received: from letter.sics.se ([193.10.64.6]:60965 "EHLO letter.sics.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0BVLMc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 06:12:32 -0500
From: "Frej Drejhammar" <frej@sics.se>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Chroma gain configuration
In-Reply-To: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	(Devin Heitmueller's message of "Sun, 21 Feb 2010 23:07:07 -0500")
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
Date: Mon, 22 Feb 2010 12:04:13 +0100
Message-ID: <tz8iq9pjzv6.fsf@dront.sics.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'm asking because it seems a bit strange that someone would introduce
> a v4l2 standard control to disable the AGC but not have the ability to
> manually set the gain once it was disabled.

As the person who introduced V4L2_CID_CHROMA_AGC for cx2388x I can
explain that part. The AGC was actually introduced when only a manual
gain setting was available and the AGC was disabled. The addition of the
V4L2_CID_CHROMA_AGC allowed the AGC to be enabled by default, which is
probably what most users want, but still have a way to set chroma gain
manually. The cx88 driver allows you to set the UV-gain using the
V4L2_CID_SATURATION control when the AGC is disabled.

Regards,

--Frej

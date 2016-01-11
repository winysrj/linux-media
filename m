Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f193.google.com ([209.85.217.193]:34734 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbcAKREP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 12:04:15 -0500
MIME-Version: 1.0
In-Reply-To: <56938265.6050803@xs4all.nl>
References: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com>
	<1450794122-31293-3-git-send-email-ulrich.hecht+renesas@gmail.com>
	<56938265.6050803@xs4all.nl>
Date: Mon, 11 Jan 2016 18:04:13 +0100
Message-ID: <CAO3366xyEq-B+kFCS3DKZHLpZ31ZJgSKMMfUkO0Naw_c5u8Oug@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: adv7604: update timings on change of input signal
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent <laurent.pinchart@ideasonboard.com>,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, William Towle <william.towle@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 11, 2016 at 11:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> If you detect a change in timings, then send the V4L2_EVENT_SOURCE_CHANGE event and leave
> it to the app to query the new timings. Never do this in the driver itself.
>
> The reason is that this will pull the rug out from under the application: the app thinks
> it is using timings A but the driver is using timings B. Instead, tell the app that the
> timings have changed and let the app handle this.

Thank you for your review.  It appears that code to that effect is in
the driver already, and all that is necessary to make it work (on the
adv7604 side) is the interrupt enablement ("[PATCH v2] adv7604: add
direct interrupt handling"), which I will resend RSN.

CU
Uli

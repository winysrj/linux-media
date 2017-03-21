Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:47380 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757495AbdCURFR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 13:05:17 -0400
Subject: Re: CEC button pass-through
To: Eric Nelson <eric@nelint.com>
References: <22e92133-6a64-ffaf-a41f-5ae9b19f24e5@nelint.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <53fd17db-af5d-335b-0337-e5aeffd12305@xs4all.nl>
Date: Tue, 21 Mar 2017 18:05:11 +0100
MIME-Version: 1.0
In-Reply-To: <22e92133-6a64-ffaf-a41f-5ae9b19f24e5@nelint.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2017 05:49 PM, Eric Nelson wrote:
> Hi Hans,
> 
> Thanks to your work and those of Russell King, I have an i.MX6
> board up and running with the new CEC API, but I'm having
> trouble with a couple of sets of remote control keys.

What is your exact setup? Your i.MX6 is hooked up to a TV? And you
use the TV's remote control?

> In particular, the directional keys 0x01-0x04 (Up..Right)
> and the function keys 0x71-0x74 (F1-F4) don't appear
> to be forwarded.
> 
> Running cec-ctl with the "-m" or "-M" options shows that they're
> simply not being received.

Other keys appear fine with cec-ctl -M?

Try to select CEC version 1.4 (use option --cec-version-1.4).

With CEC 2.0 you can set various RC profiles, and (very unlikely) perhaps
your TV actually understands that.

The default CEC version cec-ctl selects is 2.0.

Note that the CEC framework doesn't do anything with the RC profiles
at the moment.

> 
> I'm not sure if I'm missing a flag somewhere to tell my television
> that we support these keys, or if I'm missing something else.
> 
> I'm using the --record option at the moment. Using --playback
> seems to restrict the keys to an even smaller set (seems to
> block numeric keys).
> 
> Do you have any guidance about how to trace this?

cec-ctl -M monitors all messages, so it is weird you don't see them.

> I am seeing these keys when using Pulse8/libCEC code and
> the vendor driver and am in a position to trace the messages
> using that setup if it helps.

Regards,

	Hans

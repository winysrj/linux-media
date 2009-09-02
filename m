Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZIBRl7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 13:41:59 -0400
Message-ID: <4A9EAF07.3040303@hhs.nl>
Date: Wed, 02 Sep 2009 19:44:39 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com>
In-Reply-To: <4A9E9E08.7090104@onelan.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/02/2009 06:32 PM, Simon Farnsworth wrote:
> Hello,
>
> I'm in the process of reworking Xine's input_v4l to use libv4l2, so that
>    it gets the benefit of all the work done on modern cards and webcams,
> and I've hit a stumbling block.
>
> I have a Hauppauge HVR1600 for NTSC and ATSC support, and it appears to
> simply not work with libv4l2, due to lack of mmap support. My code works
> adequately (modulo a nice pile of bugs) with a HVR1110r3, so it appears
> to be driver level.
>
> Which is the better route to handling this; adding code to input_v4l to
> use libv4lconvert when mmap isn't available, or converting the cx18
> driver to use mmap?
>

Or modify libv4l2 to also handle devices which can only do read. There have
been some changes to libv4l2 recently which would make doing that feasible.

> If it's a case of converting the cx18 driver, how would I go about doing
> that? I have no experience of the driver, so I'm not sure what I'd have
> to do - noting that if I break the existing read() support, other users
> will get upset.

I don't believe that modifying the driver is the answer, we need to either
fix this at the libv4l or xine level.

I wonder though, doesn't the cx18 offer any format that xine can handle
directly?

As stated libv4l2 currently does not support devices that cannot do read,
what this comes down to in practice (or should, if not that is a bug), is
that it passes all calls directly to the driver. So if the driver has any
pixfmt's xine can handle directly things should work fine.

Regards,

Hans

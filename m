Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZIDGTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 02:19:51 -0400
Message-ID: <4AA0B22D.3080703@hhs.nl>
Date: Fri, 04 Sep 2009 08:22:37 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl>	 <4A9F89AD.7030106@onelan.com> <4A9F9006.6020203@hhs.nl>	 <4A9F98BA.3010001@onelan.com> <4A9F9C5F.9000007@onelan.com>	 <4A9FA681.5070100@hhs.nl> <1252034082.7203.15.camel@palomino.walls.org>
In-Reply-To: <1252034082.7203.15.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/04/2009 05:14 AM, Andy Walls wrote:
> The V4L2 spec for the read() call seems unlcear to me:
>
> "Return Value
> On success, the number of bytes read is returned. It is not an error if
> this number is smaller than the number of bytes requested, or the amount
> of data required for one frame. This may happen for example because
> read() was interrupted by a signal. On error, -1 is returned, and the
> errno variable is set appropriately. In this case the next read will
> start at the beginning of a new frame."
>
> To me, the spec only says the remainder of a frame is thrown away when
> read() exits with an error.
>

It does seem to say that yes, as said in a previous mail of me, this part
of the spec needs some fixing. It seems to try and describe the queuing
that happens inside the driver in too much detail and leaves out other
much me important bits about how read() on video devices behaves.

>
> BTW, should select() return "data available", if less than one whole
> frame is available?  It can happen if the buffers we give to the CX23418
> firmware don't exactly match the YUV framesize.  The V4l2 spec for the
> read() call seems to imply that read() should block (or return with
> EAGAIN) until at least one whole frame is available.  Is that correct?

I agree that waiting until at least one whole frame is available. Is the
correct behaviour.

Regards,

Hans

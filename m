Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZJDPcr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 11:32:47 -0400
Message-ID: <4AC8C117.6060406@redhat.com>
Date: Sun, 04 Oct 2009 17:36:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: James Blanford <jhblanford@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Race in gspca main or missing lock in stv06xx subdriver?
References: <20090914111757.543c7e77@blackbart.localnet.prv> <20090915124106.35ad1382@tele>
In-Reply-To: <20090915124106.35ad1382@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Sorry for jumping into this discussion a bit late, I was swamped
with other stuff and did not have time to look into this before.

On 09/15/2009 12:41 PM, Jean-Francois Moine wrote:
> On Mon, 14 Sep 2009 11:17:57 -0400
> James Blanford<jhblanford@gmail.com>  wrote:
>
>> Howdy folks,
>>
>> I have my old quickcam express webcam working, with HDCS1000
>> sensor, 046d:840. It's clearly throwing away every other frame.  What
>> seems to be happening is, while the last packet of the previous frame
>> is being analyzed by the subdriver, the first packet of the next frame
>> is assigned to the current frame buffer.  By the time that packet is
>> analysed and sent back to the main driver, it's frame buffer has been
>> completely filled and marked as "DONE."  The entire frame is then
>> marked for "DISCARD."  This does _not_ happen with all cams using this
>> subdriver.
>>

<snip>

>
> Hi James,
>
> I think you may have found a big problem, and this one should exist in
> all drivers!
>
> As I understood, you say that the URB completion routine (isoc_irq) may
> be run many times at the same time.
>

That was what I understood too, and I could not believe it, so I thought
James had made some sort of mistake with his analyses, because it
we can have multiple URB completion routines run at the same time, no
matter how good out locking it, we've already lost, as then:

> For other drivers, the problem remains: the image fragments could be
> received out of order.
>

As Jean-Francois very correctly pointed out, but no worries. The handling of
isoc irq's is serialised elsewhere in the kernel, the issue of what James is
seeing is much simpler.

When we call gspca_frame_add, it returns a pointer to the frame passed in,
unless we call it with LAST_PACKET, when it will return a pointer to a
new frame in to whoch store the frame data for the next frame. So whenever
calling:
gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, len);
we should do this as:
frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, len);

So that any further data got from of the pkt we are handling in pkt_scan, goes
to the next frame.

We are not doing this in stv06xx.c pkt_scan method, which the cause of what
James is seeing. So I started checking all drivers, and we are not doing this
either in ov519.c when handling an ov518 bridge. So now the framerate of my
3 ov518 test cams has just doubled. Thanks James!

I'll send a patch with the fix in a separate mail.

Regards,

Hans

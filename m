Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44789 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0G2RgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 13:36:11 -0400
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: awalls@md.metrocast.net, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
In-Reply-To: <BTlN5mEJjFB@christoph>
References: <BTlN5mEJjFB@christoph>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 20:35:46 +0300
Message-ID: <1280424946.32069.11.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 19:15 +0200, Christoph Bartelmus wrote: 
> Hi Maxim,
> 
> on 29 Jul 10 at 19:26, Maxim Levitsky wrote:
> > On Thu, 2010-07-29 at 11:38 -0400, Andy Walls wrote:
> >> On Thu, 2010-07-29 at 17:41 +0300, Maxim Levitsky wrote:
> >>> On Thu, 2010-07-29 at 09:23 +0200, Christoph Bartelmus wrote:
> >>>> Hi Maxim,
> >>>>
> >>>> on 29 Jul 10 at 02:40, Maxim Levitsky wrote:
> >>>> [...]
> >>>>> In addition to comments, I changed helper function that processes
> >>>>> samples so it sends last space as soon as timeout is reached.
> >>>>> This breaks somewhat lirc, because now it gets 2 spaces in row.
> >>>>> However, if it uses timeout reports (which are now fully supported)
> >>>>> it will get such report in middle.
> >>>>>
> >>>>> Note that I send timeout report with zero value.
> >>>>> I don't think that this value is importaint.
> >>>>
> >>>> This does not sound good. Of course the value is important to userspace
> >>>> and 2 spaces in a row will break decoding.
> >>>>
> >>>> Christoph
> >>>
> >>> Could you explain exactly how timeout reports work?
> >>>
> >>> Lirc interface isn't set to stone, so how about a reasonable compromise.
> >>> After reasonable long period of inactivity (200 ms for example), space
> >>> is sent, and then next report starts with a pulse.
> >>> So gaps between keypresses will be maximum of 200 ms, and as a bonus I
> >>> could rip of the logic that deals with remembering the time?
> >>>
> >>> Best regards,
> >>> Maxim Levitsky
> 
> > So, timeout report is just another sample, with a mark attached, that
> > this is last sample? right?
> 
> No, a timeout report is just an additional hint for the decoder that a  
> specific amount of time has passed since the last pulse _now_.
> 
> [...]
> > In that case, lets do that this way:
> >
> > As soon as timeout is reached, I just send lirc the timeout report.
> > Then next keypress will start with pulse.
> 
> When timeout reports are enabled the sequence must be:
> <pulse> <timeout> <space> <pulse>
> where <timeout> is optional.
> 
> lircd will not work when you leave out the space. It must know the exact  
> time between the pulses. Some hardware generates timeout reports that are  
> too short to distinguish between spaces that are so short that the next  
> sequence can be interpreted as a repeat or longer spaces which indicate  
> that this is a new key press.

Let me give an example to see if I got that right.


Suppose we have this sequence of reports from the driver:

500 (pulse)
200000 (timeout)
100000000 (space)
500 (pulse)


Is that correct that time between first and second pulse is
'100200000' ?

Best regards,
Maxim Levitsky


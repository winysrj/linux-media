Return-path: <mchehab@localhost>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38759 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283Ab1GFBFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2011 21:05:31 -0400
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com> <201107050926.38639.hverkuil@xs4all.nl> <4E12FEA3.6010500@redhat.com> <201107051520.17361.hverkuil@xs4all.nl> <b1f62aa0-bcc1-497f-843f-7c4473f75f73@email.android.com> <4E139D50.4050406@redhat.com>
In-Reply-To: <4E139D50.4050406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l: add macro for 1080p59_54 preset
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 05 Jul 2011 21:05:34 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com
Message-ID: <76f37109-8b9b-4bd6-aee8-0d4f75cc0dc2@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>Em 05-07-2011 16:02, Andy Walls escreveu:
>> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> I can work on the proposal this week for that. The only reason the
>fps
>>> hasn't been added
>>> yet is that I never had the time to do the research on how to
>represent
>>> the fps reliably
>>> for all CEA/VESA formats. Hmm, pixelclock / total_framesize should
>>> always work, of course.
>>>
>>> We can add a flags field as well (for interlaced vs progressive and
>>> perhaps others such as
>>> normal vs reduced blanking).
>>>
>>> That leaves the problem with GTF/CVT. I'll get back to that
>tomorrow. I
>>> have ideas, but
>>> I need to discuss it first.
>>>
>>> Regards,
>>>
>>> 	Hans
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>linux-media"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> For fps you could use horizontal_line_freq/lines_per_frame.
>> 
>> However, all of the non-integer fps numbers I have seen in this email
>chain all seem to be multiples of 29.97002997 Hz. So maybe you could
>just use the closest integer rate with a flag labeled
>"ntsc_bw_timing_hack" to indicate the fractional rates. :) 
>
>CEA-861 has some other timings that are not 60 Hz * 1000/1001. Yet,
>v4l2_fract
>is capable of handling any of such timings, as, whatever frequency
>taken, it
>needs to be a fractional number. Btw, even some userspace libraries
>prefer to
>represent fps using a fraction, instead of a float, to avoid rounding
>issues.
>
>> 
>> That 29.97 Hz number comes from the NTSC decision in 1953(!) to
>change the horizontal line freq to 4.5 MHz/286.  Note that
>> 
>> (4.5 MHz/286)/525 = 30 * (1000/1001) = 29.97002997 Hz
>
>One of the rationale for that decision was to avoid flicking issues
>with cathodic 
>ray monitors and fluorescent lamps.
> 
>> It is interesting to see one of the most ingenious analog hacks in TV
>history (to achieve color and B&W backward compatabilty while staying
>in the 10% tolerance of the old B&W receivers) being codified in
>digital standards over 50 years later. It boggles the mind...
>
>Yes. Bad (and good) API decisions will stay forever.
>
>Cheers,
>Mauro.

Oops, yes I see the 60.054 Hz rate corresponds to a 262 line field (524 line frame) at the standard NTSC line rate.

Weird stuff.

Regards,
Andy

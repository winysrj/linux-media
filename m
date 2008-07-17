Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HHAY7F001934
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 13:10:34 -0400
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HHAJ7v010644
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 13:10:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Date: Thu, 17 Jul 2008 19:10:01 +0200
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200807171848.51033.hverkuil@xs4all.nl>
	<alpine.LFD.1.10.0807171254060.20641@bombadil.infradead.org>
In-Reply-To: <alpine.LFD.1.10.0807171254060.20641@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171910.01863.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
	attribute for?persistent video4linux device nodes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thursday 17 July 2008 18:57:49 Mauro Carvalho Chehab wrote:
> On Thu, 17 Jul 2008, Hans Verkuil wrote:
> > On Thursday 17 July 2008 18:44:23 Hans Verkuil wrote:
> >> On Thursday 17 July 2008 18:40:47 Mauro Carvalho Chehab wrote:
> >>> On Thu, 17 Jul 2008, Hans Verkuil wrote:
> >>>> On Wednesday 25 June 2008 00:59:51 Brandon Philips wrote:
> >>>>> On 00:34 Tue 24 Jun 2008, Trent Piepho wrote:
> >>>>>> On Mon, 23 Jun 2008, Brandon Philips wrote:
> >>>>>>> +	for (i = 0; i < 32; i++) {
> >>>>>>> +		if (used & (1 << i))
> >>>>>>> +			continue;
> >>>>>>> +		return i;
> >>>>>>> +	}
> >>>>>>
> >>>>>> 	i = ffz(used);
> >>>>>> 	return i >= 32 ? -ENFILE : i;
> >>>>>
> >>>>> Err. Right :D  Tested and pushed.
> >>>>>
> >>>>> Mauro-
> >>>>>
> >>>>> Updated http://ifup.org/hg/v4l-dvb to have Trent's improvement.
> >>>>>
> >>>>> Cheers,
> >>>>>
> >>>>> 	Brandon
> >>>>
> >>>> Hi Mauro,
> >>>>
> >>>> I think you missed this pull request from Brandon. Can you merge
> >>>> this?
> >>>
> >>> Yes, I missed that one.
> >>>
> >>> Yet, I didn't like the usage of "32" magic numbers on those
> >>> parts:
> >>>
> >>> -       if (num >= VIDEO_NUM_DEVICES)
> >>> +
> >>> +       if (num >= 32) {
> >>> +               printk(KERN_ERR "videodev: %s num is too
> >>> large\n", __func__);
> >>>
> >>> +       return i >= 32 ? -ENFILE : i;
> >>>
> >>>
> >>> It seems better to use VIDEO_NUM_DEVICES as the maximum limit on
> >>> both usages of "32".
> >>>
> >>> Brandon,
> >>>
> >>> Could you fix and re-send me a pull request?
> >>
> >> Mauro, Brandon,
> >>
> >> If you do not mind, then I'll do this. I'm working on videodev.c
> >> anyway (making it compatible with kernels <2.6.19) so it's easy
> >> for me to do merge this and make the necessary adjustment. And I
> >> can test it with a 2.6.18 kernel at the same time.
>
> For me, it is OK if you want to touch on it.
>
> > Correction, the 32 refers to the number of bits in an u32, not to
> > VIDEO_NUM_DEVICES. So I think you can just merge this patch as is.
> > It does not conflict with my videodev.c changes (amazingly), so it
> > is no problem if you merge this change.
>
> Hmm... If I understood the patch, if you change VIDEO_NUM_DEVICES to
> a higher number, you'll still be limited on 32 max devices, right?

No. The value of 32 refers to the maximum number of devices 
(/dev/vbiX, /dev/videoX, etc) created for ONE driver instance. E.g. my 
first ivtv card can create up to 32 devices, my second bttv card can 
create up to 32 devices, etc. etc.

The maximum currently in use is probably ivtv with 9 devices for a 
PVR-350 card. So we are safe with 32.

VIDEO_NUM_DEVICES refers to the TOTAL number of video4linux devices 
created. I have some future plans to enlarge that and possibly also 
getting rid of how the minor numbers are allocated. Currently this is 
very unfair with a range of 64 for radio devices and an equal number of 
video devices, although each ivtv card creates 3 video devices against 
one radio device (and 5 for a PVR-350 card!). Much better to just pick 
the first free minor number.

Regards,

	Hans

> If I'm right, then, IMO,  we should use VIDEO_NUM_DEVICES and put a
> notice that increasing this number will require changing some static
> var from u32 to u64.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

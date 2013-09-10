Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:6368 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3IJJRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 05:17:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v1 16/19] v4l: Add encoding camera controls.
Date: Tue, 10 Sep 2013 11:17:01 +0200
Cc: Kamil Debski <k.debski@samsung.com>,
	"'Pawel Osciak'" <posciak@chromium.org>,
	linux-media@vger.kernel.org,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <04c001cead3a$f8ea0dc0$eabe2940$%debski@samsung.com> <522D9065.3040209@samsung.com>
In-Reply-To: <522D9065.3040209@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201309101117.01044.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 9 September 2013 11:09:57 Sylwester Nawrocki wrote:
> On 09/09/2013 11:00 AM, Kamil Debski wrote:
> [...]
> >>>> We have QP controls separately for H264, H263 and MPEG4. Why is that?
> >>>> Which one should I use for VP8? Shouldn't we unify them instead?
> >>>
> >>> I can't quite remember the details, so I've CCed Kamil since he added
> >> those controls.
> >>> At least the H264 QP controls are different from the others as they
> >>> have a different range. What's the range for VP8?
> >>
> >> Yes, it differs, 0-127.
> >> But I feel this is pretty unfortunate, is it a good idea to multiply
> >> controls to have one per format when they have different ranges
> >> depending on the selected format in general? Perhaps a custom handler
> >> would be better?
> >>
> >>> I'm not sure why the H263/MPEG4 controls weren't unified: it might be
> >>> that since the
> >>> H264 range was different we decided to split it up per codec. But I
> >>> seem to remember that there was another reason as well.
> > 
> > We had a discussion about this on linux-media mailing list. It can be found
> > here:
> > http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/32606
> > In short, it is a mix of two reasons: one - the valid range is different for
> > different formats and second - implementing controls which have different
> > min/max values depending on format was not easy.
> 
> Hmm, these seem pretty vague reasons. And since some time we have support
> for dynamic control range update [1].

I don't think we should change this. We chose to go with separate controls,
and we should stick with that. We might do it differently today, but it's
not a big deal.

Regards,

	Hans

> 
> > On the one hand I am thinking that now, when we have more codecs, it would
> > be better
> > to have a single control, on the other hand what about backward
> > compatibility?
> > Is there a graceful way to merge H263 and H264 QP controls?
> 
> [1] https://patchwork.linuxtv.org/patch/16436/
> 
> --
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

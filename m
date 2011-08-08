Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3246 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1HHGXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 02:23:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Media Subsystem Workshop 2011
Date: Mon, 8 Aug 2011 08:22:50 +0200
Cc: workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E398381.4080505@redhat.com> <4E398940.4020409@redhat.com>
In-Reply-To: <4E398940.4020409@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108080822.50912.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, August 03, 2011 19:45:36 Mauro Carvalho Chehab wrote:
> Em 03-08-2011 14:21, Mauro Carvalho Chehab escreveu:
> > As already announced, we're continuing the planning for this year's 
> > media subsystem workshop.
> > 
> > To avoid overriding the main ML with workshop-specifics, a new ML
> > was created:
> > 	workshop-2011@linuxtv.org
> > 
> > I'll also be updating the event page at:
> > 	http://www.linuxtv.org/events.php
> > 
> > Over the one-year period, we had 242 developers contributing to the
> > subsystem. Thank you all for that! Unfortunately, the space there is
> > limited, and we can't affort to have all developers there. 
> > 
> > Due to that some criteria needed to be applied to create a short list
> > of people that were invited today to participate. 
> > 
> > The main criteria were to select the developers that did significant 
> > contributions for the media subsystem over the last 1 year period, 
> > measured in terms of number of commits and changed lines to the kernel
> > drivers/media tree.
> > 
> > As the used criteria were the number of kernel patches, userspace-only 
> > developers weren't included on the invitations. It would be great to 
> > have there open source application developers as well, in order to allow 
> > us to tune what's needed from applications point of view. 
> > 
> > So, if you're leading the development of some V4L and/or DVB open-source 
> > application and wants to be there, or you think you can give good 
> > contributions for helping to improve the subsystem, please feel free 
> > to send us an email.
> > 
> > With regards to the themes, we're received, up to now, the following 
> > proposals:
> > 
> > ---------------------------------------------------------+----------------------
> > THEME                                                    | Proposed-by:
> > ---------------------------------------------------------+----------------------
> > Buffer management: snapshot mode                         | Guennadi
> > Rotation in webcams in tablets while streaming is active | Hans de Goede
> > V4L2 Spec – ambiguities fix                              | Hans Verkuil
> > V4L2 compliance test results                             | Hans Verkuil
> > Media Controller presentation (probably for Wed, 25)     | Laurent Pinchart
> > Workshop summary presentation on Wed, 25                 | Mauro Carvalho Chehab
> 
> In time: it should be, instead Tue Oct, 25. Sorry for the typo.

So the presentation and summary are on Tuesday, but when is the workshop
itself? Is it on the Monday or the Sunday?

It would be nice to know so I can plan my stay in Prague and my planning
with the other conferences going on at the same time.

Regards,

	Hans

> 
> > ---------------------------------------------------------+----------------------
> > 
> > From my side, I also have the following proposals:
> > 
> > 1) DVB API consistency - what to do with the audio and video DVB API's 
> > that conflict with V4L2 and (somewhat) with ALSA?
> > 
> > 2) Multi FE support - How should we handle a frontend with multiple 
> > delivery systems like DRX-K frontend?
> > 
> > 3) videobuf2 - migration plans for legacy drivers
> > 
> > 4) NEC IR decoding - how should we handle 32, 24, and 16 bit protocol
> > variations?
> > 
> > Even if you won't be there, please feel free to propose themes for 
> > discussion, in order to help us to improve even more the subsystem.
> > 
> > Thank you!
> > Mauro
> 
> Rémi, thanks for pointing it!
> 
> Thanks!
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

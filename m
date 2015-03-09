Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37344 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbCJHCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 03:02:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] uvcvideo: Don't call vb2 mmap and get_unmapped_area with queue lock held
Date: Tue, 10 Mar 2015 01:52:02 +0200
Message-ID: <8389917.WAzPk9jDDo@avalon>
In-Reply-To: <871tkye8g3.fsf@nemi.mork.no>
References: <1424111134-22413-1-git-send-email-laurent.pinchart@ideasonboard.com> <87k2z9558i.fsf@nemi.mork.no> <871tkye8g3.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bjørn,

(it took me half an hour to figure out how to write ø on my keyboard :-))

On Monday 09 March 2015 12:06:36 Bjørn Mork wrote:
> Bjørn Mork <bjorn@mork.no> writes:
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:
> >> Bjørn, does this fix the circular locking dependency you have reported in
> >> "[v3.19-rc7] possible circular locking dependency in uvc_queue_streamoff"
> >> ? The report mentions involves locks, so I'm not 100% this patch will fix
> >> the issue.
> > 
> > Sorry, I forgot all about that report after firing it off...  Should
> > have followed it up with some more details.
> > 
> > Grepping my logs now I cannot find this warning at all after the one I
> > reported.  I see it once before (while running 3.19-rc6).  So it is
> > definitely not easily reproducible.  And I have a bad feeling the
> > trigger might involve completely unrelated USB issues...
> > 
> > In any case, thanks for the patch.  I will test it for a while and let
> > you know if the same warning shows ut with it.  But based on the rare
> > occurence, I don't think I ever will be able to positively confirm that
> > the warning is gone.
> 
> FWIW, I have not seen the warning after applying this patch, so it
> appears to fix the problem.  Thanks.

You're welcome.

> If I'm wrong, then I'm sure Murphy will tell us as soon as I send this
> email :-)

I'd be happy to prove Murphy wrong for once.

-- 
Regards,

Laurent Pinchart


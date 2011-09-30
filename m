Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1I3L2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 07:28:30 -0400
Message-ID: <4E85A7DC.50708@redhat.com>
Date: Fri, 30 Sep 2011 08:28:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 0/7] V4L menu reorganization
References: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-09-2011 06:01, Hans Verkuil escreveu:
> Hi all,
> 
> This is the second version of my patch series reorganizing the V4L menu.
> It's based on the latest v3.2 staging tree.
> 
> Changes to v1:
> 
> - Remove unnecessary USB dependency.
> - Reorganize the radio menu as well.
> 
> I did not sort the drivers alphabetically (yet). I'm not quite sure whether
> that's really a good idea, and we can always do that later.

I still think that we need to sort things alphabetically, or to not sort
things at all, as any other sort criteria would be just a random criteria.

E. g. on a non-alphabetical criteria, what should come first between bttv,
saa7134, ivtv and cx88? Except by the alphabetical order, any order between 
them will be just a random criteria, as people will argue that driver "foo"
should be the first one, probably because they have more hardware of that
type ;)

In my case, I would vote for saa7134 as I currently have more hardware of
that type. A few years ago, my vote would be for cx88. I bet you'll vote
for ivtv ;)

> This series is meant for v3.2, but I won't make a pull request until
> Guennadi's pull request is merged first. I'm sure I will have to redo my
> patches once his series is in.

Ok.
> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


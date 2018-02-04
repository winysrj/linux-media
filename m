Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49696 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeBDNUb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Feb 2018 08:20:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: MEDIA_IOC_G_TOPOLOGY and pad indices
Date: Sun, 04 Feb 2018 15:20:55 +0200
Message-ID: <2768029.GcpMBOxS6Y@avalon>
In-Reply-To: <7773f8ac-32b8-4199-4b4c-05657dd0bb37@xs4all.nl>
References: <336b3d54-6c59-d6eb-8fd8-e0a9677c7f5f@xs4all.nl> <2979437.fEFkWIelBg@avalon> <7773f8ac-32b8-4199-4b4c-05657dd0bb37@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday, 4 February 2018 15:16:26 EET Hans Verkuil wrote:
> On 02/04/2018 02:13 PM, Laurent Pinchart wrote:
> > On Sunday, 4 February 2018 15:06:42 EET Hans Verkuil wrote:
> >> Hi Mauro,
> >> 
> >> I'm working on adding proper compliance tests for the MC but I think
> >> something is missing in the G_TOPOLOGY ioctl w.r.t. pads.
> >> 
> >> In several v4l-subdev ioctls you need to pass the pad. There the pad is
> >> an index for the corresponding entity. I.e. an entity has 3 pads, so the
> >> pad argument is [0-2].
> >> 
> >> The G_TOPOLOGY ioctl returns a pad ID, which is > 0x01000000. I can't use
> >> that in the v4l-subdev ioctls, so how do I translate that to a pad index
> >> in my application?
> >> 
> >> It seems to be a missing feature in the API. I assume this information is
> >> available in the core, so then I would add a field to struct media_v2_pad
> >> with the pad index for the entity.
> >> 
> >> Next time we add new public API features I want to see compliance tests
> >> before accepting it. It's much too easy to overlook something, either in
> >> the design or in a driver or in the documentation, so this is really,
> >> really needed IMHO.
> > 
> > I agree with you, and would even like to go one step beyond by requiring
> > an implementation in a real use case, not just in a compliance or test
> > tool.
> > 
> > On the topic of the G_TOPOLOGY API, it's pretty clear it was merged too
> > hastily. We could try to fix it, but given all the issues we haven't
> > solved yet, I believe a new version of the API would be better.
> 
> It's actually not too bad as an API speaking as an end-user. It's simple and
> efficient. But this pad issue is a real problem.

We have other issues such as connector support and entities function vs. types 
that we have never solved. The G_TOPOLOGY ioctl moves in the right direction 
but has clearly been merged too early. It might be possible to fix it, I 
haven't checked yet, but I really don't want to see this mistake being 
repeated in the future.

-- 
Regards,

Laurent Pinchart

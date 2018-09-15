Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44889 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726446AbeIONtW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 09:49:22 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] media-ctl: rework and merge mc_nextgen_test features
Message-ID: <b29b6c04-1089-c58d-3335-a31a87f856bc@xs4all.nl>
Date: Sat, 15 Sep 2018 10:31:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Mauro,

We currently have two competing utilities for controlling media devices:
media-ctl and mc_nextgen_test, each with features that the other doesn't
have. That's obviously not good.

I would like to work on adding the missing pieces for the new G_TOPOLOGY
API to media-ctl. As part of that I would really like to turn media-ctl
into C++ (like the other V4L2/CEC utilities) so I can use the v4l2-info.cpp
and media-info.cpp helpers. This will ensure consistent naming conventions
throughout our utilities, which I think is a good thing. With C++ you can
also use the standard STL maps, lists, vectors, etc. which are ideal for
processing a media topology.

One thing that I really dislike about the media-ctl syntax is the use of
characters that require quotes ('->' being the main offender). I would like
to add an alternative syntax that avoids this.

I'm thinking that ' to ' (note the spaces) is a good alternative to '->'.
Question: does '->' already require spaces? Or is 'pad1->pad2' equivalent
to 'pad1 -> pad2'? I haven't dug into the parsing code yet.

I'm a bit confused by this syntax:

        entity          = entity-number | ( '"' entity-name '"' ) ;

Shouldn't this be:

        entity          = entity-number | entity-name ;

The first syntax suggests that all entity-names must be written as "name",
and that can't be right. Just checking if the entity string starts with
0-9 is enough. If you want to allow entity names to start with 0-9 as
well (a bad idea IMHO), then you can be fancier and check if the entity
string matches either [0-9]+ or 0[xX][0-9]+.

Assuming that brackets around the entity name are indeed not needed, then
the only other annoying syntax is for rectangles: (left,top)/wxh.

The () also need to be quoted. I was wondering if the () around left,top are
needed at all. Wouldn't left,top/WxH be sufficient? Rectangles are prefixed by
crop: or compose:, so it's easy to know when you have to parse a rectangle.

I think that with these changes in place you can setup pipelines without
having to care about escaping or quoting special characters.

My plan is to first convert media-ctl to C++ (with minimum changes) and
start using v4l2-info.cpp and media-info.cpp to ensure consistent naming.

The next step is to support an easier alternative syntax, and finally
G_TOPOLOGY support will be added to media-ctl so it has the same feature
set as mc_nextgen_test.

Hopefully by the time that's done we'll also have properties, so that will
be added as well.

I am uncertain what to do with libmediactl.c. It is only used by media-ctl,
and it is never installed either. I am inclined to first make something
that works, and then think about creating a proper library. Splitting off
the parsing in a separate source is a good idea regardless, so I was
planning to do that anyway.

Any objections? Ideas? Comments?

Regards,

	Hans

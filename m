Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:54466 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2LKNQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 08:16:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: RFC: First draft of guidelines for submitting patches to linux-media
Date: Tue, 11 Dec 2012 14:15:31 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201212101407.09338.hverkuil@xs4all.nl>
In-Reply-To: <201212101407.09338.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212111415.31483.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 10 December 2012 14:07:09 Hans Verkuil wrote:
> Hi all,
> 
> As discussed in Barcelona I would write a text describing requirements for new
> drivers and what to expect when submitting patches to linux-media.
> 
> This is a first rough draft and nothing is fixed yet.
> 
> I have a few open questions:
> 
> 1) Where to put it? One thing I would propose that we improve is to move the
> dvb and video4linux directories in Documentation/ to Documentation/media to
> correctly reflect the drivers/media structure. If we do that, then we can put
> this document in Documentation/media/SubmittingMediaPatches.
> 
> Alternatively, this is something we can document in our wiki.
> 
> 2) Are there DVB requirements as well for new drivers? We discussed a list of
> V4L2 requirements in Barcelona, but I wonder if there is a similar list that
> can be made for DVB drivers. Input on that will be welcome.
> 
> 3) This document describes the situation we will have when the submaintainers
> take their place early next year. So please check if I got that part right.
> 
> 4) In Barcelona we discussed 'tags' for patches to help organize them. I've
> made a proposal for those in this document. Feedback is very welcome.
> 
> 5) As discussed in Barcelona there will be git tree maintainers for specific
> platforms, but we didn't really go into detail who would be responsible for
> which platform. If you want to maintain a particular platform, then please
> let me know.
> 
> 6) The patchwork section is very short at the moment. It should be extended
> when patchwork gets support to recognize the various tags.
> 
> 7) Anything else that should be discussed here?

How to submit patches for a stable kernel.

I can never remember, and I'm sure I'm not the only one :-)

Regards,

	Hans

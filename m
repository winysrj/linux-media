Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:32412 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1ISIhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 04:37:01 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/2] Patches for TVP7002
Date: Mon, 19 Sep 2011 10:32:48 +0200
Cc: mats.randgaard@tandberg.com, linux-media@vger.kernel.org,
	sudhakar.raj@ti.com, Hans Verkuil <hans.verkuil@cisco.com>
References: <1280823484-21664-1-git-send-email-mats.randgaard@tandberg.com> <4E7632F6.204@redhat.com>
In-Reply-To: <4E7632F6.204@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109191032.48771.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday, September 18, 2011 20:05:42 Mauro Carvalho Chehab wrote:
> Em 03-08-2010 05:18, mats.randgaard@tandberg.com escreveu:
> > From: Mats Randgaard <mats.randgaard@tandberg.com>
> > 
> > The patch "TVP7002: Changed register values" depends on http://www.mail-
archive.com/linux-media@vger.kernel.org/msg20769.html
> 
> Hmm... those patches still apply over the latest development tree.
> I didn't saw any comments about it. Are they still applicable?

Yes, they are still applicable.

Weird, we all must have lost track of these two patches.

Regards,

	Hans

> 
> > 
> > Mats Randgaard (2):
> >   TVP7002: Return V4L2_DV_INVALID if any of the errors occur.
> >   TVP7002: Changed register values.
> > 
> >  drivers/media/video/tvp7002.c |   14 ++++----------
> >  1 files changed, 4 insertions(+), 10 deletions(-)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Return-path: <mchehab@gaivota>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1317 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1ABLZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jan 2011 06:25:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC: Move the deprecated et61x251 and sn9c102 to staging
Date: Sun, 2 Jan 2011 12:25:21 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>
References: <201101012053.00372.hverkuil@xs4all.nl> <4D20565B.9090307@redhat.com>
In-Reply-To: <4D20565B.9090307@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101021225.22104.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sunday, January 02, 2011 11:41:31 Mauro Carvalho Chehab wrote:
> Em 01-01-2011 17:53, Hans Verkuil escreveu:
> > The subject says it all:
> > 
> > If there are no objections, then I propose that the deprecated et61x251 and
> > sn9c102 are moved to staging for 2.6.38 and marked for removal in 2.6.39.
> 
> Nack.
> 
> There are several USB ID's on sn9c102 not covered by gspca driver yet.

Why are these drivers marked deprecated then?

> It seems to me that et61x251 will also stay there for a long time, as there are
> just two devices supported by gspca driver, while et61x251 supports 25.
> 
> Btw, we currently have a conflict with this USB ID:
> 	USB_DEVICE(0x102c, 0x6151),
> 
> Both etoms and et61x251 support it, and there's no #if to disable it on one
> driver, if both drivers are compiled. We need to disable it either at gspca_etoms
> or at et61x251, in order to avoid users of having a random experience with this
> device.

Surely such devices should be removed from et61x251 or sn9c102 as soon as they are
added to gspca?

Regards,

	Hans

> > 
> > If there are no objections, then I'll make a patch for this.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> Cheers,
> Mauro
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

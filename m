Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:34672 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab3EWKX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 06:23:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [v3] media: davinci: kconfig: fix incorrect selects
Date: Thu, 23 May 2013 12:23:12 +0200
Cc: Paul Bolle <pebolle@tiscali.nl>, Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org
References: <1363079692-16683-1-git-send-email-nsekhar@ti.com> <1368439554.1350.49.camel@x61.thuisdomein> <CA+V-a8vOJocJttwQBnNA-sn2qWtAvgzQ96OGNbJ8NvVV_tt7uA@mail.gmail.com>
In-Reply-To: <CA+V-a8vOJocJttwQBnNA-sn2qWtAvgzQ96OGNbJ8NvVV_tt7uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231223.12721.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 13 May 2013 12:41:26 Prabhakar Lad wrote:
> Hi Paul,
> 
> On Mon, May 13, 2013 at 3:35 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Prabhakar,
> >
> > On Mon, 2013-05-13 at 15:27 +0530, Prabhakar Lad wrote:
> >> Good catch! the dependency can be dropped now.
> >
> > Great.
> >
> >> Are you planning to post a patch for it or shall I do it ?
> >
> > I don't mind submitting that trivial patch.
> >
> > However, it's probably better if you do that. I can only state that this
> > dependency is now useless, because that is simply how the kconfig system
> > works. But you can probably elaborate why it's OK to not replace it with
> > another (negative) dependency. That would make a more informative commit
> > explanation.
> >
> Posted the patch fixing it https://patchwork.linuxtv.org/patch/18395/

Prabhakar,

Is this for 3.10 or 3.11?

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52248 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab0DZRes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 13:34:48 -0400
Received: by vws13 with SMTP id 13so5739vws.19
        for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 10:34:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BD596AD.60707@infradead.org>
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl>
	 <201004211144.19591@orion.escape-edv.de>
	 <u2ka3ef07921004251057t36a6f9c3pe54a40fad3e8f515@mail.gmail.com>
	 <4BD596AD.60707@infradead.org>
Date: Mon, 26 Apr 2010 10:34:47 -0700
Message-ID: <i2ma3ef07921004261034qb090722dg930f5ef30e2a489d@mail.gmail.com>
Subject: Re: av7110 and budget_av are broken!
From: VDR User <user.vdr@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Oliver Endriss <o.endriss@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	e9hack <e9hack@googlemail.com>, linux-media@vger.kernel.org,
	Douglas Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 26, 2010 at 6:35 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> You need to ask Douglas about -hg issues. He is the actual maintainer of that tree.
> It is probably a good idea to merge also from fixes.git tree, but this may make
> his sync process more complicated, so, it is up to him to decide how to do it.
>
> I still thinking on having a better way to have those fixes patches merged earlier
> on -git, but I'll need to have some time to do some scripting and test some things.

I think any progress to keep these trees in better sync is a good idea.

>> I don't actually know anyone who bothers with the git
>> tree for obvious reasons
>
> About half of the developers are submitting git requests, so it seems that
> there are people using it.

I'd expect that a portion of developers prefer git, but I was
referring to end-users -- the guys who do the majority of testing imo.
 I don't know any end-users with any intention of using the git tree.
Actually, there are quite a few who stopped updating their hg tree and
prefer to use older known working drivers because of the sync
problems/broken drivers not being fixed.  From a developer standpoint
it may be decent but to an end-user it's just turned into a big mess.
Oh well, who needs all those testers anyways? ;)

Cheers

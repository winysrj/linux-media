Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0DZNfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 09:35:50 -0400
Message-ID: <4BD596AD.60707@infradead.org>
Date: Mon, 26 Apr 2010 10:35:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: VDR User <user.vdr@gmail.com>
CC: Oliver Endriss <o.endriss@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	e9hack <e9hack@googlemail.com>, linux-media@vger.kernel.org,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: av7110 and budget_av are broken!
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl>	 <201004211144.19591@orion.escape-edv.de> <u2ka3ef07921004251057t36a6f9c3pe54a40fad3e8f515@mail.gmail.com>
In-Reply-To: <u2ka3ef07921004251057t36a6f9c3pe54a40fad3e8f515@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VDR User wrote:
> On Wed, Apr 21, 2010 at 2:44 AM, Oliver Endriss <o.endriss@gmx.de> wrote:
>>> It's merged in Mauro's fixes tree, but I don't think those pending patches
>>> have been pushed upstream yet. Mauro, can you verify this? They should be
>>> pushed to 2.6.34!
>> What about the HG driver?
>> The v4l-dvb HG repository is broken for 7 weeks...
> 
> It doesn't make any sense why someone would break a driver and then
> leave it that way for such a long period of time.  Yes, please fix the
> HG repository. 

You need to ask Douglas about -hg issues. He is the actual maintainer of that tree.
It is probably a good idea to merge also from fixes.git tree, but this may make
his sync process more complicated, so, it is up to him to decide how to do it.

I still thinking on having a better way to have those fixes patches merged earlier
on -git, but I'll need to have some time to do some scripting and test some things.

> I don't actually know anyone who bothers with the git
> tree for obvious reasons

About half of the developers are submitting git requests, so it seems that
there are people using it.

-- 

Cheers,
Mauro

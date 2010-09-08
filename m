Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0IHPX7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 11:23:59 -0400
Message-ID: <4C87AA7E.60200@redhat.com>
Date: Wed, 08 Sep 2010 12:23:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 0/6] Large scancode handling
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
In-Reply-To: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 08-09-2010 04:41, Dmitry Torokhov escreveu:
> Hi Mauro,
> 
> I guess I better get off my behind and commit the changes to support large
> scancodes, or they will not make to 2.6.37 either... There isn't much
> changes, except I followed David's suggestion and changed boolean index
> field into u8 flags field. Still, please glance it over once again and
> shout if you see something you do not like.
> 
> Jiri, how do you want to handle the changes to HID? I could either push
> them through my tree together with the first patch or you can push through
> yours once the first change hits mainline.
> 
> Mauro, the same question goes for media/IR patch.

It seems easier if you apply them on your tree. I'm sure we won't have any
major conflicts, if we don't apply the big ir->rc renaming patch. I'll postpone
such patch to be applied after the merge upstream.

The patches look sane to me.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro

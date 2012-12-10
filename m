Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab2LJSny (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 13:43:54 -0500
Date: Mon, 10 Dec 2012 16:43:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC: First draft of guidelines for submitting patches to
 linux-media
Message-ID: <20121210164327.6303290d@redhat.com>
In-Reply-To: <50C61FC4.7090100@iki.fi>
References: <201212101407.09338.hverkuil@xs4all.nl>
	<50C60620.2010603@googlemail.com>
	<201212101727.29074.hverkuil@xs4all.nl>
	<20121210153816.0d4d9b64@redhat.com>
	<50C61FC4.7090100@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Dec 2012 19:45:40 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 12/10/2012 07:38 PM, Mauro Carvalho Chehab wrote:
> > Yeah, the issue is that both reviewed, non-reviewed and rejected/commented
> > patches go into the very same queue, forcing me to revisit each patch again,
> > even the rejected/commented ones, and the previous versions of newer patches.
> >
> > By giving rights and responsibilities to the sub-maintainers to manage their
> > stuff directly at patchwork, those patches that tend to stay at patchwork for
> > a long time will likely disappear, and the queue will be cleaner.
> 
> Is there any change module maintainer responsibility of patch could do 
> what ever he likes to given patch in patchwork?
> 
> I have looked it already many times but I can drop only my own patches. 
> If someone sends patch to my driver X and I pick it up my GIT tree I 
> would like to mark it superseded for patchwork (which is not possible 
> currently).

Patchwork's ACL is very limited. It has 3 types there:
	- People (every email it detects);
	- User (the ones that created a password);
	- Project maintainers;

A "people" can't do anything special, except be promoted to "users", by
setting a password for him.

An "user" can only set his emails, enable/disable opt-out/opt-in, set his
primary project and the number of patches per page.

The Project maintainers can do everything in the project.

It would be great to have a feature there allowing the user to change the
status of their own patches, and to let the project maintainers to delegate
a patch to an user[1].

[1] well, I think it can delegate it right now, but only a project
maintainer can change the patch status, so, delegation doesn't work
if the "delegated user" is not a project owner.

Regards,
Mauro

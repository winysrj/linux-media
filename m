Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36310 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab2LJRqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 12:46:17 -0500
Message-ID: <50C61FC4.7090100@iki.fi>
Date: Mon, 10 Dec 2012 19:45:40 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC: First draft of guidelines for submitting patches to linux-media
References: <201212101407.09338.hverkuil@xs4all.nl> <50C60620.2010603@googlemail.com> <201212101727.29074.hverkuil@xs4all.nl> <20121210153816.0d4d9b64@redhat.com>
In-Reply-To: <20121210153816.0d4d9b64@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/10/2012 07:38 PM, Mauro Carvalho Chehab wrote:
> Yeah, the issue is that both reviewed, non-reviewed and rejected/commented
> patches go into the very same queue, forcing me to revisit each patch again,
> even the rejected/commented ones, and the previous versions of newer patches.
>
> By giving rights and responsibilities to the sub-maintainers to manage their
> stuff directly at patchwork, those patches that tend to stay at patchwork for
> a long time will likely disappear, and the queue will be cleaner.

Is there any change module maintainer responsibility of patch could do 
what ever he likes to given patch in patchwork?

I have looked it already many times but I can drop only my own patches. 
If someone sends patch to my driver X and I pick it up my GIT tree I 
would like to mark it superseded for patchwork (which is not possible 
currently).

regards
Antti

-- 
http://palosaari.fi/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:55020 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab3GIGd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jul 2013 02:33:29 -0400
Message-ID: <51DBAEB6.8000004@schinagl.nl>
Date: Tue, 09 Jul 2013 08:33:26 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Jonathan McCrohan <jmccrohan@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: dtv-scan-tables updates
References: <51DB4759.603@gmail.com>
In-Reply-To: <51DB4759.603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-07-13 01:12, Jonathan McCrohan wrote:
> Hi Oliver,
>
> I was just taking a look around github, and noticed that some people
> have forked their own versions of dtv-scan-tables on there.
*sigh*
>
> There appear to be some worthwhile contributions there that have not
> been upstreamed. [1],[2],[3],[4],[5]
Will investigate those and see whats there
>
> It might be a good idea to contact the authors in question to ask if
> they are okay with their contributions being upstreamed. It might also
> be an idea to set up an 'official' github mirror of the dtv-scan-tables
> tree. It might make it easier for contributors to upstream their work
> using github's pull request workflow rather than dealing with
> git-send-email etc?
I agree that its much easier to deal with, especially for external 
parties that are unfamiliar with git. I suppose the windows tools make 
it much easier for people to do things, without them even knowing what 
they do? I never used them so can't be sure.

>
> Just an idea.
Its not a bad idea, and we're not directly dealing with actual code, so 
the dtv changes could be done that way. Now its time for people to 
disagree and tell us why it's a bad idea :)
>
> Jon
>
> [1]
> https://github.com/hiroshiyui/dvb-apps/commit/c2e3b732cae849a151c27929204c20ac40b920d0.patch
>
> [2]
> https://github.com/vlalov/dtv-scan-tables/commit/682aca38813e6731c5305fe6eb3aa9c05b2eb931.patch
>
> [3]
> https://github.com/crazycat69/dtv-scan-tables/commit/5966b7da708753130c815cb078875b58b18d9ddf.patch
>
> [4]
> https://github.com/crazycat69/dtv-scan-tables/commit/1c1942782c10016709189bb3675fc06fdf684609.patch
>
> [5]
> https://github.com/crazycat69/dtv-scan-tables/commit/d826071cbdf09d8f3090af148b72a5af820b75bb.patch
>


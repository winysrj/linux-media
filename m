Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:37189 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0ALQTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2010 11:19:21 -0500
Received: by qyk32 with SMTP id 32so2476243qyk.4
        for <linux-media@vger.kernel.org>; Tue, 12 Jan 2010 08:19:20 -0800 (PST)
To: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab\@infradead.org" <mchehab@infradead.org>,
	"hverkuil\@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH - v4 1/4] V4L-vpfe_capture-remove-clock and platform code
References: <1263252977-27457-1-git-send-email-m-karicheri2@ti.com>
	<1263252977-27457-2-git-send-email-m-karicheri2@ti.com>
	<1263252977-27457-3-git-send-email-m-karicheri2@ti.com>
	<1263252977-27457-4-git-send-email-m-karicheri2@ti.com>
	<87skackwia.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162DF9E7C@dlee06.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Tue, 12 Jan 2010 08:19:18 -0800
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40162DF9E7C@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Tue\, 12 Jan 2010 08\:40\:44 -0600")
Message-ID: <87tyurgut5.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

[...]

>>
>>Also, this doesn't accuratly reflect the changes done in the patch.
>>
>>Here the clock configuration isn't moved, it's removed.  You should
>>mention it being removed here and added to platform-specific code in
>>subsequent patches.
>>
>>Sorry to be so nit-picky about the comments, but having a well-written
>>and descriptive changelog is extremely importanty.  For the benefit of
>>reading the git history later, and also for those of us less familiar
>>with the details of these drivers, we rely heavily on a good changelog.
>>
>
> [MK] I think you are being too picky on these comments :( 

Part of my role is to be picky.  ;)

> Besides this was gone through several reviews and I was wondering
> why you chose to ignore these comments earlier. It was now being
> sent for merge, not for review.

I did not do a detailed review in the earlier versions because I was
leaving this to be thoroughly reviewed by linux-media folks.

However, with all the clock issues, I decided to give it a more
thorough review, and I found the changelogs to not be helpful in
understanding the patches.

The linux-media maintainers are certainly free to merge the stuff with
the current confusing changelog, but I would not recommend it.

> This is really not helping the upstream merge :(

Well, it may be taking a bit longer, but it is helping the quality of
the changes that are eventually merged upstream.

> Anyways, I will make these changes and send again.

Thanks,

Kevin

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41033 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468AbbFEKaZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 06:30:25 -0400
Message-ID: <55717A36.7010808@xs4all.nl>
Date: Fri, 05 Jun 2015 12:30:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [ATTN 0/9] SDR transmitter API
References: <1432660090-19574-1-git-send-email-crope@iki.fi> <557170D9.3010607@xs4all.nl> <55717910.7050002@iki.fi>
In-Reply-To: <55717910.7050002@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/05/2015 12:25 PM, Antti Palosaari wrote:
> On 06/05/2015 12:50 PM, Hans Verkuil wrote:
>> Hi Antti,
>>
>> FYI: don't use ATTN as prefix: patchwork doesn't pick that up as a patch,
>> and if it doesn't appear there, then it is likely to be forgotten.
>>
>> Can you repost it with the correct prefix? It's so much easier to process
>> for me if it ends up in patchwork...
> 
> Which is correct prefix?

Just [PATCH] is enough.

> 
> Earlier I used PATCH RFC, but then I saw that ATTN:
> [ANN] Report on the San Jose V4L/DVB mini-summit
> http://www.spinics.net/lists/linux-media/msg76281.html
> 
> - Add 'ATTN' inside pull request subject line tp indicate that Mauro's 
> (or some other maintainer's) attention is required. Should be limited to 
> api changes, dependencies.
> 
> OK, it speaks only pull request, but that was patchset having API changes...

ATTN is only for urgent pull requests for the current rc kernel, it doesn't
apply to patches.

[PATCH RFC] means that it is not yet ready to be merged, but just [PATCH] indicates
that it should be OK to merge (at least according to the submitter!).

Regards,

	Hans

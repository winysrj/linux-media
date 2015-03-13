Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39916 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116AbbCMV7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 17:59:12 -0400
Message-ID: <55035DA4.2020903@xs4all.nl>
Date: Fri, 13 Mar 2015 22:59:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 00/21] marvell-ccic: drop and fix formats
References: <1426061428-47019-1-git-send-email-hverkuil@xs4all.nl> <20150313172801.6bc4bf75@lwn.net>
In-Reply-To: <20150313172801.6bc4bf75@lwn.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

On 03/13/2015 10:28 PM, Jonathan Corbet wrote:
> On Wed, 11 Mar 2015 09:10:24 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> After some more testing I realized that the 422P format produced
>> wrong colors and I couldn't get it to work. Since it never worked and
>> nobody complained about it (and it is a fairly obscure format as well)
>> I've dropped it.
> 
> I'm not sure how that format came in anymore; I didn't add it.  No
> objections to its removal.

It came in with the patches from Marvell.

>> I also tested RGB444 format for the first time, and that had wrong colors
>> as well, but that was easy to fix. Finally there was a Bayer format
>> reported, but it was never implemented. So that too was dropped.
> 
> The RGB444 change worries me somewhat; that was the default format on the
> XO1 and worked for years.  I vaguely remember some discussions about the
> ordering of the colors there, but that was a while ago.  Did you test it
> with any of the Sugar apps?

I've tested with the 'Record' app, and that picks a YUV format, not RGB444.
Are there other apps that I can test with where you can select the capture
format?

> In the end, correctness is probably the right way to go (it usually is!),
> but I'd hate to get a regression report from somebody who is crazy enough
> to put current kernels on those machines.  Fortunately, such people
> should be rare.
> 
> Bayer sort-of worked once, honest.  I added it for some academic who
> wanted to do stuff, and was never really able to close the loop on
> getting it working correctly.  It might be worth removing the alleged
> support from ov7670 as well.

I might give it try to get it to work. I'm in the process of adding Bayer
support to the vivid driver, which makes it easier to test. I'll see if
I have some time this weekend.

> In any case, for all of them:
> 
> Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks!

	Hans


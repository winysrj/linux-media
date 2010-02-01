Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab0BATLw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 14:11:52 -0500
Message-ID: <4B67276D.1020909@redhat.com>
Date: Mon, 01 Feb 2010 17:11:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Douglas Schilling Landgraf <dougsland@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [hg:v4l-dvb] firedtv: do not DMA-map stack addresses
References: <E1NbzwQ-00009q-Tx@mail.linuxtv.org> <4B672345.6070203@s5r6.in-berlin.de>
In-Reply-To: <4B672345.6070203@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

Stefan Richter wrote:
>> The patch number 14077 was added via Douglas Schilling Landgraf <dougsland@redhat.com>
>> to http://linuxtv.org/hg/v4l-dvb master development tree.
> [...]
>> [dougsland@redhat.com: patch backported to hg tree]
> 
> I don't know how you prefer to organize your trees, but:
> In this particular case it could have been simpler if you had first
> inserted an hg:v4l-dvb only patch which simply reverts the divergence of
> firedtv in hg from mainline git.
> 
> This divergence was introduced by some kind of hg->git export mistake.
> That's not a big issue but it may cause another mistake when the next
> hg->git export happens.

We've replaced our procedures on our trees recently. Until last year,
I was applying the patches at -hg and then converting to -git.

This year, we're just doing the reverse: the patches got added at -git:
	http://git.linuxtv.org/v4l-dvb.git

And then backported to -hg.  The backport is double-checked by an script
that detects code differences between those two trees, after removing any
backported patches.

I had 3 patches from you pending to apply, probably due to some import
troubles at -hg. Those patches got added this week at -git. That's why
you're now seeing those backport emails.

Unfortunately, I hadn't any time yet to replace the git hook to some 
hook that sends a message to the patch author/sob's. 

Cheers,
Mauro

-- 

Cheers,
Mauro

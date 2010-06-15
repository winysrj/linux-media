Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56713 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab0FOAAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 20:00:52 -0400
Message-ID: <4C16C2C2.6000503@gmail.com>
Date: Mon, 14 Jun 2010 17:01:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Edward Shishkin <edward.shishkin@gmail.com>,
	linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8]reiserfs:stree.c Fix variable set but not used.
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-2-git-send-email-justinmattock@gmail.com> <4C1699AA.3000900@gmail.com> <4C169D71.90800@gmail.com> <4C16A372.6020604@gmail.com> <4C16B236.7080506@gmail.com> <tkrat.d7bea45e7dbad972@s5r6.in-berlin.de>
In-Reply-To: <tkrat.d7bea45e7dbad972@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2010 04:07 PM, Stefan Richter wrote:
> On 14 Jun, Justin P. Mattock wrote:
>> On 06/14/2010 02:47 PM, Edward Shishkin wrote:
>>> Whitespaces should be removed.
>>> I recommend quilt package for managing patches:
>>> "quilt refresh --strip-trailing-whitespace" is your friend..
>>
>> o.k. I resent this.. fixed the whitespace(hopefully)
>> and add your Acked to it.
>> as for quilt I'll have to look into that..
>> (using a lfs system, so if the sourcecode is easy
>> to deal with(build), then it's a good but if it becomes
>> a nightmare maybe not!!).
>
> Since you appear to generate the patches with git, you can use "git diff
> --check [...]" for some basic whitespace checks (additions of trailing
> space, additions of space before tab).  For more extensive checks, try
> "git diff [...] | scripts/checkpatch.pl -".  Check this before you
> commit.  If you committed already, "git commit --amend [-a] [...]" lets
> you alter the very last commit of course.


Thanks for the info on this, copied it
down in my book of commands...

Justin P. Mattock

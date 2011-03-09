Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44302 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab1CIPTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 10:19:25 -0500
Received: by eyx24 with SMTP id 24so169968eyx.19
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2011 07:19:24 -0800 (PST)
Subject: Re: Simultaneous recordings from one frontend
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: =?iso-8859-1?Q?Pascal_J=FCrgens?=
	<lists.pascal.juergens@googlemail.com>
In-Reply-To: <20110309154737.3a567af8@borg.bxl.tuxicoman.be>
Date: Wed, 9 Mar 2011 16:19:21 +0100
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4DC80B41-4BE9-4FAC-9D31-D58548F5CF3E@googlemail.com>
References: <B7991825-5F55-4AA0-AB7B-BB2A968F7464@googlemail.com> <20110309154737.3a567af8@borg.bxl.tuxicoman.be>
To: Guy Martin <gmsoft@tuxicoman.be>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear Guy,

I compiled your tool and from what I see, it demuxes the ts into separate streams for each program.
While it's a very handy thing to have, I'm actually looking for something slightly different.

I'm sorry if I didn't describe it very clearly.

What I'm looking to do is to record ONE and the same program into two different files, but start and stop at distinct points in time.

This means that the recording schedule would look something like this:

Program "arte":
file1		(start 11:55)--------------------(end 13:05) ...
file2		                    start(start 12:55)--------------------(end 14:05) ...

So far, Brice Dubost has already hinted that mumudb is able to stream the same program to a unicast port on a loopback device, and I've been able to do multiple simultaneous recording this way.

However, I'm still curious to see if there are other options :)

Thanks,
Pascal

On Mar 9, 2011, at 3:47 PM, Guy Martin wrote:

> 
> Hi Pascal,
> 
> I've written a very small program that does just that :
> https://svn.tuxicoman.be/listing.php?repname=dvbsplit
> It's a quick hack, there is probably a better way to do this but at
> least it works :)
> 
> To get the sources : "svn checkout
> https://svn.tuxicoman.be/svn/dvbsplit/trunk dvbsplit". Check the readme
> for compilation.
> 
> You'll need to tune to the right TP with `{stc}zap -r`, then start it
> and it will dump everything in the directory.
> 
> HTH,
>  Guy


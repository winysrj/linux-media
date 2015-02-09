Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52689 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbbBIGnq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 01:43:46 -0500
Date: Mon, 9 Feb 2015 07:43:02 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: nick <xerofoify@gmail.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media:firewire:Remove unneeded function
 definition,avc_tuner_host2ca in firedtv-avc.c
Message-ID: <20150209074302.79876412@kant>
In-Reply-To: <54D80CCC.5030700@gmail.com>
References: <1423423437-31949-1-git-send-email-xerofoify@gmail.com>
	<20150209005500.104d20a6@kant>
	<54D80CCC.5030700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Feb 08 nick wrote:
> On 2015-02-08 06:55 PM, Stefan Richter wrote:
> > I still am missing research on the question whether or not the Common
> > Interface serving part of the driver needs to send Host2CA commands.  If
> > yes, we implement it and use the function.  If not, we remove the
> > function.  As long as we are not sure, I prefer to leave the #if-0'd code
> > where it is.  It documents how the command is formed, and we don't have
> > any other documentation (except perhaps the git history).
[...]
> Stefan,
> I looked in the history with git log -p 154907957f939 and all I got 
> for this function was 
>  Wed Feb 11 21:21:04 CET 2009
>     firedtv: avc: header file cleanup
>     
>         Remove unused constants and declarations.
>         Move privately used constants into .c files.

The function was added a few commits before this one, by "firesat: update
isochronous interface, add CI support".

> Clearly this states to remove unused declarations and avc_tuner_host2ca is unused.
> Can you explain to me then why it's still needed to be around if there no callers
> of it?

See above; in this instance

	#if 0
	dead code
	#endif

stands in for

	/*
	 * pseudo code
	 */
-- 
Stefan Richter
-=====-===== --=- -=--=
http://arcgraph.de/sr/

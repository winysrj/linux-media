Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59814 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab0AMLdo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 06:33:44 -0500
Subject: Re: [PATCH 1/1] media: video/cx18, fix potential null dereference
From: Andy Walls <awalls@radix.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4B4C5CEF.5060601@gmail.com>
References: <1263113806-7532-1-git-send-email-jslaby@suse.cz>
	 <1263253709.4116.1.camel@palomino.walls.org>  <4B4C5CEF.5060601@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Jan 2010 06:32:27 -0500
Message-Id: <1263382347.3057.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-01-12 at 12:28 +0100, Jiri Slaby wrote:
> On 01/12/2010 12:48 AM, Andy Walls wrote:
> > On Sun, 2010-01-10 at 09:56 +0100, Jiri Slaby wrote:
> >> Stanse found a potential null dereference in cx18_dvb_start_feed
> >> and cx18_dvb_stop_feed. There is a check for stream being NULL,
> >> but it is dereferenced earlier. Move the dereference after the
> >> check.
> >>
> >> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > 
> > Reviewed-by: Andy Walls <awalls@radix.net>
> > Acked-by: Andy Walls <awalls@radix.net>
> 
> You definitely know the code better, have you checked that it can happen
> at all? I mean may demux->priv be NULL?

I'm wasn't sure, and that's the one reason I didn't NAK the patch.
I can tell you no one has ever reported an Ooops or Bug due to that
condition.


I know the cx18 code very well.  However, I am less familiar with the
dvb core code and any bad behavior that may exist there.  When relying
on data structures the dvb core accesses I would have to research what
could happen in the dvb core to possibly generate that condition.

Since I'm busy this week with work related to my day job (nothing to do
with Linux), it was easiest to let the NULL check stay in for now.

If you don't mind a delay of until Sunday or so to get the patch applied
to the V4L-DVB tree, I can take the patch and work it in my normal path
through Mauro.  Let me know.

Regards,
Andy



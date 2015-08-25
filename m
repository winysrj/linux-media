Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59905 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbbHYUCe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 16:02:34 -0400
Date: Tue, 25 Aug 2015 17:02:28 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	shuahkh@osg.samsung.com
Subject: Re: [PATCH v7 00/44] MC next generation patches
Message-ID: <20150825170228.1baaa1cb@recife.lan>
In-Reply-To: <CAKocOOOjJ3iuWTJv2qNt4=3m01YVVN444COtZ_e4ETXH=_XEbg@mail.gmail.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<CAKocOOOjJ3iuWTJv2qNt4=3m01YVVN444COtZ_e4ETXH=_XEbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2015 13:11:06 -0600
Shuah Khan <shuahkhan@gmail.com> escreveu:

> On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > The latest version of this patch series is at:
> >         http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=mc_next_gen
> >
> > The latest version of the userspace tool to test it is at:
> >         http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=mc-next-gen
> >
> > The initial patches of this series are the same as the ones at the
> >         "[PATCH v6 0/8] MC preparation patches"
> > plus Javier patch series:
> >         "[PATCH 0/4] [media] Media entity cleanups and build fixes"
> > Addressing some of the concerns from Laurent:
> >         Javier media_entity_id() patches got reordered;
> >         all "elements" occurrences were replaced by "objects"
> >
> 
> Do you have new media-ctl graphs that are based on these changes you
> can share with us?

No, I don't. I do have the output from my tree. The problem is that
media-ctl is not being able of creating the dot graph. I didn't
have any time yet to check why, but
> It would be nice to see before and after graphs from media-ctl.

Now that we're starting to represent properly the DVB entities, the
number of graph elements are too high. The au0828 demux has 256
ports. On each port, there are two outputs (one via demux interface
and another one via the DVB interface). All those entities are
connected to the demux interface, and all DVR ts output entities
linked to the dvr interface.

A dot graph with the number of entities and interfaces would be 
useless, except if one would print it on an A0 paper, and change
the graph type to neato.

Regards,
Mauro

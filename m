Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48716 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0BVXiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:38:18 -0500
Received: by pwj8 with SMTP id 8so3173935pwj.19
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 15:38:17 -0800 (PST)
Date: Mon, 22 Feb 2010 15:38:08 -0800
From: Brandon Philips <brandon@ifup.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
Message-ID: <20100222233808.GD4013@jenkins.home.ifup.org>
References: <4B55445A.10300@infradead.org>
 <4B5B30E4.7030909@redhat.com>
 <20100222225426.GC4013@jenkins.home.ifup.org>
 <201002230026.59712.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002230026.59712.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 00:26 Tue 23 Feb 2010, Hans Verkuil wrote:
> On Monday 22 February 2010 23:54:26 Brandon Philips wrote:
> > On 18:24 Sat 23 Jan 2010, Hans de Goede wrote:
> > > >lib/
> > > >	libv4l1/
> > > >	libv4l2/
> > > >	libv4lconvert/
> > > >utils/
> > > >	v4l2-dbg
> > > >	v4l2-ctl
> > > >	cx18-ctl
> > > >	ivtv-ctl
> > > >contrib/
> > > >	test/
> > > >	everything else
> > > >
> > 
> >   git clone git://ifup.org/philips/create-v4l-utils.git
> >   cd create-v4l-utils/
> >   ./convert.sh 
> > 
> > You should now have v4l-utils.git which should have this directory
> > struture. If we need to move other things around let me know and I can
> > tweak name-filter.sh
> > 
> > Thoughts? Let me know how we should proceed with dropping v4l2-apps
> > from v4l-dvb.
> > 
> > Re: code style cleanup. I think we should do that once we drop
> > v4l2-apps/ from v4l-dvb and make the new v4l-utils.git upstream.
> 
> Question: shouldn't we merge dvb-apps and v4l-utils? The alevtv tool was
> merged into dvb-apps, but while that tool supports dvb, it also supports
> v4l2. Just like we merged dvb and v4l in a single repository, so I think we
> should also merge the tools to a media-utils repository.
> 
> It remains a fact of life that dvb and v4l are connected and trying to
> artificially keep them apart does not make much sense to me.

Easy to do but who should be the maintainer of the dvb things?

According to the wiki[1] these tools are without a maintainer. So, if
no one cares about them enough to make releases why merge them and
clutter up the git tree with dead code?

Cheers,

	Brandon

[1] http://www.linuxtv.org/wiki/index.php/LinuxTV_dvb-apps

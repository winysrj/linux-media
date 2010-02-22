Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f174.google.com ([209.85.222.174]:40994 "EHLO
	mail-pz0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab0BVXAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:00:30 -0500
Received: by pzk4 with SMTP id 4so401104pzk.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 15:00:29 -0800 (PST)
Date: Mon, 22 Feb 2010 14:54:26 -0800
From: Brandon Philips <brandon@ifup.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
Message-ID: <20100222225426.GC4013@jenkins.home.ifup.org>
References: <4B55445A.10300@infradead.org>
 <4B57B6E4.2070500@infradead.org>
 <20100121024605.GK4015@jenkins.home.ifup.org>
 <201001210834.28112.hverkuil@xs4all.nl>
 <4B5B30E4.7030909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5B30E4.7030909@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18:24 Sat 23 Jan 2010, Hans de Goede wrote:
> >lib/
> >	libv4l1/
> >	libv4l2/
> >	libv4lconvert/
> >utils/
> >	v4l2-dbg
> >	v4l2-ctl
> >	cx18-ctl
> >	ivtv-ctl
> >contrib/
> >	test/
> >	everything else
> >

  git clone git://ifup.org/philips/create-v4l-utils.git
  cd create-v4l-utils/
  ./convert.sh 

You should now have v4l-utils.git which should have this directory
struture. If we need to move other things around let me know and I can
tweak name-filter.sh

Thoughts? Let me know how we should proceed with dropping v4l2-apps
from v4l-dvb.

Re: code style cleanup. I think we should do that once we drop
v4l2-apps/ from v4l-dvb and make the new v4l-utils.git upstream.

Cheers,

	Brandon

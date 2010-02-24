Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44622 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0BXOcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 09:32:16 -0500
Received: by pvb32 with SMTP id 32so898797pvb.19
        for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 06:32:15 -0800 (PST)
Date: Wed, 24 Feb 2010 06:32:02 -0800
From: Brandon Philips <brandon@ifup.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
Message-ID: <20100224143202.GE20308@jenkins.stayonline.net>
References: <4B57B6E4.2070500@infradead.org>
 <20100121024605.GK4015@jenkins.home.ifup.org>
 <201001210834.28112.hverkuil@xs4all.nl>
 <4B5B30E4.7030909@redhat.com>
 <20100222225426.GC4013@jenkins.home.ifup.org>
 <4B839687.4090205@redhat.com>
 <4B83F635.9030501@infradead.org>
 <4B83F97A.60103@redhat.com>
 <4B84799E.4000202@infradead.org>
 <4B8521CF.7090500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8521CF.7090500@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13:55 Wed 24 Feb 2010, Hans de Goede wrote:
> On 02/24/2010 01:58 AM, Mauro Carvalho Chehab wrote:
> >Hans de Goede wrote:
> >The better here is to have the latest kernel headers copied on the tree.
> >This way, it is possible to compile libv4l2 with an older kernel version and
> >later upgrade the kernel, if needed, or to use a fast machine to compile
> >it, and then use it on another machine.
> >
> 
> If possible I would like to avoid this, afaik no other userspace
> utility packages are doing this.

Off the top of my head I know ethtool does this. It greatly simplifies
the work of maintaing the package:

  http://git.kernel.org/?p=network/ethtool/ethtool.git;a=blob;f=ethtool-copy.h;h=09dd5480ff3488214ab67ad04459541314291f79;hb=HEAD

> Where necessary libv4l currently has code snippets like:
> 
> #ifndef V4L2_PIX_FMT_SPCA501
> #define V4L2_PIX_FMT_SPCA501 v4l2_fourcc('S','5','0','1') /* YUYV per line */
> #endif

I don't think this is less work than copying the header file from the
Kernel. Test building under all versions of the Kernel headers that
exist to make sure something isn't missed isn't possible. It really is
easier just to sync the header file up.

> The reason for this is that I want to avoid carrying a copy of a dir
> from some other tree, with all getting stale and needing sync all
> the time issues that come with that, not to mention chicken and egg
> problems in the case of new formats which simultaneously need to be
> added to both libv4l and the kernel.

Worst case is that if it is stale then it won't build since it depends
on fancy new feature XYZ. But, at least it won't build on all systems
instead of randomly breaking based on installed kernel headers
version.

> For example often I add support for V4L2_PIX_FMT_NEW_FOO to libv4l, before it
> hits any official v4l-dvb kernel tree, with the:

Please don't add features to releases before they are merged with
Linus. It would suck to ship a copy of libv4l that has a different
idea of structs or constants then the upstream Kernel.

> Approach this works fine, if I were to carry an include tree copy, that would
> now need to become a patched include tree copy, and with the next sync I then
> need to ensure that any needed patches are either already in the sync source,
> or applied again.

Or just fix it upstream with #ifdef __KERNEL__ tags once and for all,
right?

Cheers,

	Brandon

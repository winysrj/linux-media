Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53295 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0EXHYJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 03:24:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: Setting up a GIT repository on linuxtv.org
Date: Mon, 24 May 2010 09:25:57 +0200
Cc: "'Andy Walls'" <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
References: <1274635044.2275.11.camel@localhost> <001001cafb0f$f6d95580$e48c0080$%osciak@samsung.com>
In-Reply-To: <001001cafb0f$f6d95580$e48c0080$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005240925.57725.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Monday 24 May 2010 09:08:51 Pawel Osciak wrote:
> >Andy Walls wrote:
> >Hi,
> >
> >I'm a GIT idiot, so I need a little help on getting a properly setup
> >repo at linuxtv.org.  Can someone tell me if this is the right
> >procedure:
> >
> >$ ssh -t awalls@linuxtv.org git-menu
> >
> >        (clone linux-2.6.git naming it v4l-dvb  <-- Is this right?)
> >
> >$ git clone \
> >
> >	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git \
> >	
> >        v4l-dvb
> 
> If I understand correctly, you won't be working on that repository directly
> (i.e. no working directory on the linuxtv server, only push/fetch(pull),
> and the actual work on your local machine), you should make it a bare
> repository by passing a --bare option to clone.

There's a slight misunderstanding here. The ssh command runs the git-menu 
application on the server. It doesn't open an interactive shell. The git clone 
command is then run locally, where a working directory is needed.

-- 
Regards,

Laurent Pinchart

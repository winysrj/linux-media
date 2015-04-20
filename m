Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:58270 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbbDTIaB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 04:30:01 -0400
Date: Mon, 20 Apr 2015 10:29:56 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Jemma Denson <jdenson@gmail.com>, linux-media@vger.kernel.org,
	Jannis <jannis-lists@kripserver.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] Add support for TechniSat Skystar S2
Message-ID: <20150420102956.7f9faaa7@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <20150420082047.GA10269@linuxtv.org>
References: <201504122132.t3CLW6fQ018555@jemma-pc.denson.org.uk>
	<552B62EF.8050705@gmail.com>
	<20150417110630.554290f5@dibcom294.coe.adi.dibcom.com>
	<20150419231943.6df7312b@lappi3.parrot.biz>
	<20150420082047.GA10269@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes,

On Mon, 20 Apr 2015 10:20:47 +0200 Johannes Stezenbach <js@linuxtv.org>
wrote:

> (add Mauro)
> 
> On Sun, Apr 19, 2015 at 11:19:43PM +0200, Patrick Boettcher wrote:
> > On Fri, 17 Apr 2015 11:06:30 +0200
> > Patrick Boettcher <patrick.boettcher@posteo.de> wrote:
> > > http://git.linuxtv.org/cgit.cgi/pb/media_tree.git/ cx24120-v2
> > 
> > Jannis pointed out, that my repository on linuxtv.org was not
> > fetchable...
> > 
> > I put one onto github, this should work:
> > 
> > https://github.com/pboettch/linux.git cx24120-v2
> > 
> > It is the same commits as I was pushing to the linuxtv.org .
> 
> Patrick, can you point out why your repository is
> not fetchable?  Any error messages?

In the meantime I recreated it from scratch (using git-menu I did
delete -> clone).

Before it was giving error like this:

remote: error: Could not read 28df73703e738d8ae7a958350f74b08b2e9fe9ed
remote: fatal: Failed to traverse parents of commit
6b9d03db027c532e509ad9064dd767f621b6e69a

This seems to me a problem of a git push not uploading all the missing
commits between my local repo's commit-base and the remote one.

My repo was very old (2010). I assume none has ever cloned from it and
the media_tree has itself been push forced several times.

--
Patrick.

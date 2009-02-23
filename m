Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58928 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbZBWOyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 09:54:44 -0500
Date: Mon, 23 Feb 2009 11:54:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
Message-ID: <20090223115416.074b6f3e@pedra.chehab.org>
In-Reply-To: <20090223092657.1a2ac2e1@pedra.chehab.org>
References: <200902221115.01464.hverkuil@xs4all.nl>
	<20090223092657.1a2ac2e1@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Feb 2009 09:26:57 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:


> I'm right now working on another way of allowing backport that will better
> scale, and will allow developers to use -git, without losing backport for users.

I have an incomplete skeleton for the backport scripts, available at:

http://linuxtv.org/hg/~mchehab/backport

For now, it is very dumb (it recompiles all drivers every time) and requires
much more hacking to cleanup the Makefiles.

The current version just removes a very simple check for linux version, but it
is not hard to use this way for all cases where backport is needed. After
having this working fine and supporting all backports, people can develop using
-git as basis for development, without needing to take care of backport anymore.

Cheers,
Mauro

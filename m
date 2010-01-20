Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53169 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab0ATID6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 03:03:58 -0500
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [ANNOUNCE] git tree repositories
Date: Wed, 20 Jan 2010 09:04:44 +0100
Cc: Johannes Stezenbach <js@linuxtv.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
References: <4B55445A.10300@infradead.org> <20100119112057.GC9187@linuxtv.org> <4B55A915.1000207@infradead.org>
In-Reply-To: <4B55A915.1000207@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001200904.44258.markus.heidelberg@web.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab, 2010-01-19:
> Yes. I personally prefer to have a bare clone (bare trees have just
> the -git objects, and not a workig tree), and several working copies.
> I do the work at the working copies, and, after they are fine, I push
> into the bare and send the branches from bare to upstream.

Do you know git-new-workdir? It's included in the contrib area of the
git installation.
Instead of cloning your own local repository to get a new working
directory, with this script you really only get a new working directory
and can work in it as if it was the original clone. Then you don't have
to deal with pushes between local repositories.

Markus

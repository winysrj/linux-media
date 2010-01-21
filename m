Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0AUCTR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 21:19:17 -0500
Message-ID: <4B57B9A1.5080506@infradead.org>
Date: Thu, 21 Jan 2010 00:19:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <20100119215938.GA10958@linuxtv.org>
In-Reply-To: <20100119215938.GA10958@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Johannes Stezenbach wrote:
> Hi,
> 
> may I humbly request to make it mandatory to enter a description
> when a user creates a new tree on linuxtv.org?
> IMHO "foobar development repository" isn't useful at all.

Ok, I changed the git-menu script to ask for the description before
creating the clone.

> If I look at http://linuxtv.org/hg/ many times I have no
> clue what a repo is about or why it exists at all.
> Let's not repeat the same mistake with git.

Agreed.

> OTOH, since with git it is common to have multiple branches
> within one repository, I'm not sure how it works. It would
> be cool if git would support per-branch descriptions,
> and git web could display them.

I don't think git supports it. In kernel.org, people prefer to
use more than one repository when they have more than one
need.

Cheers,
Mauro.

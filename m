Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0AUDJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 22:09:44 -0500
Message-ID: <4B57C572.4070407@infradead.org>
Date: Thu, 21 Jan 2010 01:09:38 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Johannes Stezenbach <js@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <20100119215938.GA10958@linuxtv.org> <4B57B9A1.5080506@infradead.org> <Pine.LNX.4.58.1001201847530.4729@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.1001201847530.4729@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho wrote:
> On Thu, 21 Jan 2010, Mauro Carvalho Chehab wrote:
>>> OTOH, since with git it is common to have multiple branches
>>> within one repository, I'm not sure how it works. It would
>>> be cool if git would support per-branch descriptions,
>>> and git web could display them.
>> I don't think git supports it. In kernel.org, people prefer to
>> use more than one repository when they have more than one
>> need.
> 
> stgit lets me set descriptions for each branch.  The descriptions are there
> under the branch in the config file.  I don't think git-branch shows any
> kind of description for the branch.
stgit is a very interesting git porcelain. I used it a lot when I started with git.
It were very useful at the time git weren't implementing tools like rebase. 

However, stgit produces objects that aren't referenced, generating errors when 
you run "git fsck". So, I don't recomend using stgit anymore.

Cheers,
Mauro

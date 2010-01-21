Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:59741 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0AUCxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 21:53:09 -0500
Date: Wed, 20 Jan 2010 18:53:05 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Johannes Stezenbach <js@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
In-Reply-To: <4B57B9A1.5080506@infradead.org>
Message-ID: <Pine.LNX.4.58.1001201847530.4729@shell2.speakeasy.net>
References: <4B55445A.10300@infradead.org> <20100119215938.GA10958@linuxtv.org>
 <4B57B9A1.5080506@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 21 Jan 2010, Mauro Carvalho Chehab wrote:
> > OTOH, since with git it is common to have multiple branches
> > within one repository, I'm not sure how it works. It would
> > be cool if git would support per-branch descriptions,
> > and git web could display them.
>
> I don't think git supports it. In kernel.org, people prefer to
> use more than one repository when they have more than one
> need.

stgit lets me set descriptions for each branch.  The descriptions are there
under the branch in the config file.  I don't think git-branch shows any
kind of description for the branch.

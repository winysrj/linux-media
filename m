Return-path: <mchehab@pedra>
Received: from kroah.org ([198.145.64.141]:58767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab0JTAm4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 20:42:56 -0400
Date: Tue, 19 Oct 2010 16:52:05 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: stable@kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [stable] V4L/DVB (13966): DVB-T regression fix for saa7134
 cards
Message-ID: <20101019235205.GB22799@kroah.com>
References: <4CA35B00.4000300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA35B00.4000300@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Sep 29, 2010 at 12:28:00PM -0300, Mauro Carvalho Chehab wrote:
> Hi,
> 
> Some users are reporting a regression on 2.6.31 and 2.6.32 that were fixed on 2.6.33,
> related to DVB reception with saa7134.
> 
> Could you please cherry-pick this patch to 2.6.32 stable as well?
> 	http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=commit;h=08be64be3d1e5ecd72e7ba3147aea518e527f08e
>

Now queued up, thanks.

greg k-h

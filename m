Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:44202 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZBWNyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 08:54:36 -0500
Received: from shell2.sea5.speakeasy.net ([69.17.116.3])
          (envelope-sender <xyzzy@speakeasy.org>)
          by mail3.sea5.speakeasy.net (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 23 Feb 2009 13:54:30 -0000
Date: Mon, 23 Feb 2009 05:54:29 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
cc: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
In-Reply-To: <20090223144917.257a8f65@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0902230551580.24268@shell2.speakeasy.net>
References: <20090223144917.257a8f65@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Feb 2009, Jean Delvare wrote:
> > There are lot's of discussions, but it can be hard sometimes to actually
> > determine someone's opinion.
> >
> > So here is a quick poll, please reply either to the list or directly to me
> > with your yes/no answer and (optional but welcome) a short explanation to
> > your standpoint. It doesn't matter if you are a user or developer, I'd like
> > to see your opinion regardless.
> >
> > Please DO NOT reply to the replies, I'll summarize the results in a week's
> > time and then we can discuss it further.
> >
> > Should we drop support for kernels <2.6.22 in our v4l-dvb repository?

Does this mean keep our current system and move the backward compatibility
point to 2.6.22?

Or not have any backward compatibilty at all?

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab0ASMQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 07:16:48 -0500
Message-ID: <4B55A2AC.4020009@infradead.org>
Date: Tue, 19 Jan 2010 10:16:44 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <829197381001190204l3df81904gf8586f36187f212d@mail.gmail.com>
In-Reply-To: <829197381001190204l3df81904gf8586f36187f212d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> Hello Mauro,
> 
> I find it somewhat unfortunate that this is labeled "ANNOUNCE" instead
> of "RFC".  It shows how little you care about soliciting the opinions
> of the other developers.  Rather than making a proposal for how the
> process can be improved and soliciting feedback, you have chosen to
> decide for all of us what the best approach is and how all of us will
> develop in the future.

The announcement by purpose doesn't contain any changes on the process,
since it requires some discussions before we go there. It is just the
first step, where -git tree support were created. It also announces
that I personally won't keep maintaining -hg, delegating its task
to Douglas.

> The point I'm trying to make is that we need to be having a discussion
> about what we are optimizing for, and what are the costs to other
> developers.  This is why I'm perhaps a bit pissed to see an
> "announcement" declaring how development will be done in the future as
> opposed to a discussion of what we could be doing and what are the
> trade-offs.

I fully understand that supporting the development and tests with an
out of tree building is important to everybody. So, the plans are
to keep the out-of-tree building system maintained, and even
improving it. I'd like to thank to Douglas for his help on making 
this happen.

Cheers,
Mauro.

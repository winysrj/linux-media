Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47943 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbbFBJ0R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2015 05:26:17 -0400
Date: Tue, 2 Jun 2015 06:26:13 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 00/35] Improve DVB frontend API documentation
Message-ID: <20150602062613.0377e5e5@recife.lan>
In-Reply-To: <20150602121229.74b537a8@lwn.net>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
	<20150602121229.74b537a8@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

Em Tue, 02 Jun 2015 12:12:29 +0900
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Thu, 28 May 2015 18:49:03 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > This is the first series of patches that will improve the DVB
> > documentation.
> 
> I've done a *quick* pass over these and sent a few comments, but they are
> all on the trivial-detail side of things.  Looks good in general.

Thanks for the review! I'll address them, on a separate patch.

> Would you like me to carry these in the docs tree, or will you sent them
> up yourself?  Feel free to add my ack if you want in the latter case.

I prefer to send it via my tree, if you don't mind. There are some
automation at the DocBook/media/Makefile that links the latest version
of the UAPI headers and create cross-references between what's there
with what's documented. With that, if a patch add new API stuff but
don't add documentation, xmlmint will produce warnings. Those are
been very helpful to double check if the API is fully documented[1].

Also, there are some scripting at linuxtv.org that updates the
documentation there once a day from what's committed on my tree:
	http://linuxtv.org/downloads/v4l-dvb-apis/

So, merging it via my tree is better. 

[1] Yet, it doesn't handle enums vars that are largely used on DVB
API. I intend to write a new parser for that too on a next patch.

Regards,
Mauro


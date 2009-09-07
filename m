Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZIGOGw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 10:06:52 -0400
Date: Mon, 7 Sep 2009 11:06:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ML delivery failures
Message-ID: <20090907110625.5ed50733@caramujo.chehab.org>
In-Reply-To: <4AA50882.7070002@kernellabs.com>
References: <4AA50882.7070002@kernellabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 07 Sep 2009 09:20:02 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> Hi,
> 
> I have the traffic from this list going to a gmail account. I normally use 
> thunderbird to respond to emails and never have issues posting to the ML.
> 
> If I'm away from thunderbird and try to respond via the google apps gmail 
> interface my mails always get bounced from vger's mail daemon, claiming that the 
> message has a html sub-part, and is considered spam or an outlook virus - thus 
> rejected.
> 
> It's happened a few times, again today when responding to Simon's comment about 
> the relationship between the 716x and the 7162 driver.
> 
> I don't see any obvious 'use-non-html' formatting setting in gmail.
> 
> Perhaps someone else has seen this issue or knows of a workaround?
> 
> Comments / feedback appreciated.

Hi Stoth,

As you know, vger has several ways to protect the mailing list against spam,
and, considering the amount of spam we receive here and at LKML, they are quite
effective. There are very low spam traffic there.

I don't know what mechanisms they used there to solve this, but for sure they
deny html posts. This is a recommended measure from security POV, since html
emails can be used for several bad things including scam, especially when those
emails are mirrored on some websites, since they can include some arbitrary code
(asp/java/javascript) inside, that can do evil things for those who read such
emails.

I dunno if is there any way to disable html emails at gmail's web interface. In
my case, when I use my gmail account, I always do it via an imap/smtp client, using
the gmail server as a smtp smart relay. This way, the email will be sent as a
pure text email as expected.

Cheers,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbbFCQh1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 12:37:27 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <556F1A02.9020203@gmail.com>
References: <556F1A02.9020203@gmail.com> <55677568.4070603@gmail.com> <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk> <360.1432807690@warthog.procyon.org.uk> <23160.1433326669@warthog.procyon.org.uk>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: dhowells@redhat.com, crope@iki.fi, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31745.1433349441.1@warthog.procyon.org.uk>
Date: Wed, 03 Jun 2015 17:37:21 +0100
Message-ID: <31746.1433349441@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Malcolm Priestley <tvboxspy@gmail.com> wrote:

> >> Yes, also, the workqueue appears not to be initialized when using the dvb
> >> attached method.
> >
> > I'm not sure what you're referring to.  It's initialised in ts2020_probe()
> > just after the ts2020_priv struct is allocated - the only place it is
> > allocated.
> >
> ts2020_probe() isn't touched by devices not converted to I2C binding.

Hmmm...  Doesn't that expose a larger problem?  The only place the ts2020_priv
struct is allocated is in ts2020_probe() within ts2020.c and the struct
definition is private to that file and so it can't be allocated from outside.
So if you don't pass through ts2020_probe(), fe->tuner_priv will remain NULL
and the driver will crash.

David

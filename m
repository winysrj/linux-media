Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbbE1KIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 06:08:14 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5564C269.2000003@gmail.com>
References: <5564C269.2000003@gmail.com> <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: dhowells@redhat.com, crope@iki.fi, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <359.1432807690.1@warthog.procyon.org.uk>
Date: Thu, 28 May 2015 11:08:10 +0100
Message-ID: <360.1432807690@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Malcolm Priestley <tvboxspy@gmail.com> wrote:

> Statistics polling can not be done by lmedm04 driver's implementation of
> M88RS2000/TS2020 because I2C messages stop the devices demuxer.
> 
> So any polling must be a config option for this driver.

Ummm...  I presume a runtime config option is okay.

Also, does that mean that the lmedm04 driver can't be made compatible with the
DVBv5 API?

David

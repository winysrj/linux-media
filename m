Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49581 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573Ab0DCA7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 20:59:35 -0400
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR
 protocols at the IR core
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <1270251567.3027.55.camel@palomino.walls.org>
References: <cover.1270142346.git.mchehab@redhat.com>
	 <20100401145632.7b1b98d5@pedra>
	 <1270251567.3027.55.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 02 Apr 2010 20:59:47 -0400
Message-Id: <1270256387.3027.84.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-04-02 at 19:39 -0400, Andy Walls wrote:
> On Thu, 2010-04-01 at 14:56 -0300, Mauro Carvalho Chehab wrote:

> > +enum raw_event_type {
> > +	IR_SPACE	= (1 << 0),
> > +	IR_PULSE	= (1 << 1),
> > +	IR_START_EVENT	= (1 << 2),
> > +	IR_STOP_EVENT	= (1 << 3),
> > +};
> > +
> 
> Why are these events encoded as bit flags?  Shouldn't they all be
> orthogonal?
  ^^^^^^^^^^
Argh, wrong word.

Shouldn't they all be mutually exclusive?


Regards,
Andy


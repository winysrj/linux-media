Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35781 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416Ab3KEXXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 18:23:43 -0500
Message-ID: <1383697544.1862.7.camel@palomino.walls.org>
Subject: Re: ivtv 1.4.2/1.4.3 broken in recent kernels?
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Rajil Saraswat <rajil.s@gmail.com>, linux-media@vger.kernel.org
Date: Tue, 05 Nov 2013 19:25:44 -0500
In-Reply-To: <527796AD.2000000@xs4all.nl>
References: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
	 <1381371651.1889.21.camel@palomino.walls.org>
	 <CAFoaQoBiLUK=XeuW31RcSeaGaX3VB6LmAYdT9BoLsz9wxReYHQ@mail.gmail.com>
	 <1381620192.22245.18.camel@palomino.walls.org>
	 <1381668541.2209.14.camel@palomino.walls.org>
	 <CAFoaQoAaGhDycKfGhD2m-OSsbhxtxjbbWfj5uidJ0zMpEWQNtw@mail.gmail.com>
	 <1381707800.1875.63.camel@palomino.walls.org>
	 <CAFoaQoAjjj=nxKwWET9a5oe1JeziOz40Uc54v4hg_QB-FU-7xw@mail.gmail.com>
	 <1382202581.2405.5.camel@palomino.walls.org> <527796AD.2000000@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2013-11-04 at 13:44 +0100, Hans Verkuil wrote:
> On 10/19/2013 07:09 PM, Andy Walls wrote:
> > On Wed, 2013-10-16 at 01:10 +0100, Rajil Saraswat wrote:

> > Try applying the following (untested) patch that is made against the
> > bleeding edge Linux kernel.  The test on the mute control state in
> > wm8775_s_routing() appears to have been inverted in the bad commit you
> > isolated.
> 
> Aargh! I'm pretty sure that's the culprit. Man, that's been broken for ages.

Hi Hans,

Yes, and only *one* person reported it in those years.  I suspect very
few people use the comination of conventional PCI, analog video, and
SVideo 2 or Composite 2 anymore.


> I'll see if I can test this patch this week.

Thanks!  I'm very busy at work until mid-December.

Regards,
Andy


Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55159 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab2DJTti (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 15:49:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SHh4J-0003So-OE
	for linux-media@vger.kernel.org; Tue, 10 Apr 2012 21:49:35 +0200
Received: from lechon.iro.umontreal.ca ([132.204.27.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 21:49:35 +0200
Received: from monnier by lechon.iro.umontreal.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 21:49:35 +0200
To: linux-media@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: Unknown eMPIA tuner
Date: Tue, 10 Apr 2012 15:49:26 -0400
Message-ID: <jwv4nsrtlo8.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
References: <jwv4nsyx9pr.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
	<CAGoCfiwKU1doqvdcHFpVoc2xuRQKdQirWze0oB2QQyXSQcYrKw@mail.gmail.com>
	<jwv1unvwrtn.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
	<CAGoCfix+YHc3wPUvdwudqk5rAed09BroPX6wf-5N6BxXV5fV0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Ok, so it's an em2874/drx-j/tda18271 design, which in terms of the
> components is very similar to the PCTV 80e (which I believe Mauro got
> into staging recently).  I would probably recommend looking at that
> code as a starting point.

Any pointers to actual file names?

> That said, you'll need to figure out the correct IF frequency, the
> drx-j configuration block, the GPIO layout, and the correct tuner
> config.  If those terms don't mean anything to you, then you are best
> to wait until some developer stumbles across the device and has the
> time to add the needed support.

The words aren't meaningless to me, but not too far either.  Maybe if
someone could give me pointers as to how I could try to figure out the
corresponding info, I could give it a try.


        Stefan


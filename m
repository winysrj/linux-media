Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59898 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbeK1Fxr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 00:53:47 -0500
Date: Tue, 27 Nov 2018 16:54:47 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCHv18 01/35] Documentation: v4l: document request API
Message-ID: <20181127165447.6e421cd7@coco.lan>
In-Reply-To: <alpine.DEB.2.21.1811231343490.2603@nanos.tec.linutronix.de>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
        <20180814142047.93856-2-hverkuil@xs4all.nl>
        <alpine.DEB.2.21.1811121048400.14703@nanos.tec.linutronix.de>
        <20181118115215.5ebc681c@coco.lan>
        <20181123075157.077758c0@coco.lan>
        <alpine.DEB.2.21.1811231134100.2603@nanos.tec.linutronix.de>
        <20181123102908.2ec61ce4@coco.lan>
        <alpine.DEB.2.21.1811231343490.2603@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 23 Nov 2018 13:44:24 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> escreveu:

> On Fri, 23 Nov 2018, Mauro Carvalho Chehab wrote:
> > Ok, I'll use then the enclosed patch, replacing them by a free
> > form license info, adding a TODO at the end, as a reminder.  
> 
> LGTM. Thanks for fixing this.

Thanks for reviewing it.

Added to my fixes branch. I'll push upstream later this week.

Thanks,
Mauro

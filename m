Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:35774 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZBZLIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 06:08:18 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 26 Feb 2009 16:37:41 +0530
Subject: RE: [PATCH v4] v4l/tvp514x: make the module aware of rich people
Message-ID: <19F8576C6E063C45BE387C64729E739404279B65AC@dbde02.ent.ti.com>
In-Reply-To: <20090221084345.GA11187@www.tglx.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

I have validated the changes and it looks ok to me. As I mentioned the only issue I observed is, patch doesn't get applied cleanly (may be due to mail-server).

Hans/Mauro,

You can pull this patch.

Thanks,
Vaibhav Hiremath
Platform Support Products
Texas Instruments Inc
Ph: +91-80-25099927

> -----Original Message-----
> From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
> Sent: Saturday, February 21, 2009 2:14 PM
> To: Hiremath, Vaibhav
> Cc: video4linux-list@redhat.com; mchehab@infradead.org; linux-
> media@vger.kernel.org
> Subject: Re: [PATCH v4] v4l/tvp514x: make the module aware of rich
> people
> 
> * Sebastian Andrzej Siewior | 2009-02-10 20:30:39 [+0100]:
> 
> >because they might design two of those chips on a single board.
> >You never know.
> >
> >Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >---
> >v4: fix checkpatch issues
> 
> I don't want to rush anything but is there any update on this?
> 
> Sebastian


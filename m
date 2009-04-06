Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1971 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZDFO5S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 10:57:18 -0400
Message-ID: <60676.207.214.87.58.1239029832.squirrel@webmail.xs4all.nl>
Date: Mon, 6 Apr 2009 16:57:12 +0200 (CEST)
Subject: RE: [PATCH 3/3] V4L2 Driver for OMAP3/3 DSS.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Shah, Hardik" <hardik.shah@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
> Please find my comments inline. Most of the comments are taken care of.

> 2.  In DSS rotation is accomplished by some memory algorithm but its quite
> costly so -1 is essentially same as 0 degree but with out the overhead.
> But if mirroring is on then we have to do the 0 degree rotation with
> overhead using some memory techniques.  So from user point of view he will
> only be setting 0 but internally driver will take it as -1 or 0 depending
> upon the mirroring selected.

Hi Hardik,

I just looked over these comments and I'll do a full review in the weekend
when I'm back from San Francisco. But just one quick remark regarding this
magic -1 number: wouldn't it be better to write a small inline function
like this:

/* return true if we need to rotate or mirror, return false if we
   don't have to do anything here. */
static inline int needs_rotate(struct foo *foo)
{
    return foo->rotate != 0 || foo->mirror;
}

I think this is much more understandable. It's up to you, though.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG


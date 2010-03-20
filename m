Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2416 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0CTOUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 10:20:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: av7110 and budget_av are broken! (was: Re: changeset 14351:2eda2bcc8d6f)
Date: Sat, 20 Mar 2010 15:20:39 +0100
Cc: e9hack <e9hack@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <4B8E4A6F.2050809@googlemail.com> <4B9FDC37.8000806@googlemail.com> <201003201507.09504@orion.escape-edv.de>
In-Reply-To: <201003201507.09504@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003201520.40069.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 March 2010 15:07:08 Oliver Endriss wrote:
> e9hack wrote:
> > Am 13.3.2010 17:27, schrieb Hans Verkuil:
> > > If there are no further comments, then I'll post a pull request in a few days.
> > > 
> > > Tested with the mxb board. It would be nice if you can verify this with the
> > > av7110.
> > 
> > Hi hans,
> > 
> > it works with my TT-C2300 perfectly. The main problem of your changes was: It wasn't
> > possible to unload the module for the TT-C2300.
> 
> Guys, when will you finally apply this fix?

Thanks for reminding me, I frankly forgot about this.

Hartmut, is the problem with unloading the module something that my patch
caused? Or was that there as well before changeset 14351:2eda2bcc8d6f?
Are there any kernel messages indicating why it won't unload?

Regards,

	Hans

> As Hartmut pointed out, changeset 14351:2eda2bcc8d6f broke the av7110
> driver (and also budget-av).
> 
> It is time to fix it. This bug must not go into the kernel!
> 
> CU
> Oliver
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

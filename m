Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1507 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab1DWK5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 06:57:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jesse Allen <the3dfxdude@gmail.com>
Subject: Re: Regression with suspend from "msp3400: convert to the new control framework"
Date: Sat, 23 Apr 2011 12:56:25 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <BANLkTim7AONexeEm-E8iLQA5+TMDRUy36w@mail.gmail.com> <BANLkTi=y6_86zX_Sz69oPhMOJg_duTrcGQ@mail.gmail.com>
In-Reply-To: <BANLkTi=y6_86zX_Sz69oPhMOJg_duTrcGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104231256.25263.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, April 23, 2011 07:06:58 Jesse Allen wrote:
> On Fri, Apr 22, 2011 at 3:55 PM, Jesse Allen <the3dfxdude@gmail.com> wrote:
> > Hello All,
> >
> > I have finally spent time to figure out what happened to suspending
> > with my bttv card. I have traced it to this patch:
> >
> > msp3400: convert to the new control framework
> > ebc3bba5833e7021336f09767347a52448a60bc5
> >
> > This was done by reverting the patch at the head for v2.6.39-git.
> >
> 
> I may be still wrong about this patch being the problem. I will have
> to keep hunting for the real answer.

It would really surprise me if this patch has anything to do with it. The
error comes from the tuner driver, not from this msp3400 driver (which handles
audio).

Can you at least provide the dmesg output so I can see which bttv card and tuner
and msp versions you have?

It would also help to turn on debugging in the bttv, tuner and msp3400 drivers.

Regards,

	Hans

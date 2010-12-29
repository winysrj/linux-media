Return-path: <mchehab@gaivota>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4330 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab0L2MpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 07:45:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Deti Fliegl <deti@fliegl.de>
Subject: Re: [PATCH] [media] dabusb: Move it to staging to be deprecated
Date: Wed, 29 Dec 2010 13:44:52 +0100
Cc: Felipe Sanches <juca@members.fsf.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D19037B.6060904@redhat.com> <4D1B1D11.6030505@fliegl.de> <201012291303.22716.hverkuil@xs4all.nl>
In-Reply-To: <201012291303.22716.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012291344.52365.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wednesday, December 29, 2010 13:03:22 Hans Verkuil wrote:
> On Wednesday, December 29, 2010 12:35:45 Deti Fliegl wrote:
> > On 12/29/10 12:24 PM, Hans Verkuil wrote:
> >  >> No, it should support the Terratec hardware as well but it's outdated
> >  >> and unstable. Therefor I agreed to remove the driver from the current
> >  >> kernel as I am not willing to continue support for the code.
> >  >
> >  > I don't think it supports the Terratec hardware since the list of USB ids
> >  > doesn't include the Terratec products:
> > Yes you are right - there you see - our driver is quite different - out 
> > latest changes are of october 2010 - and the kernel driver is somehow 
> > stone aged.
> > 
> >  > Unless someone will pick up this source code and starts to work with 
> > us on
> >  > designing an API it will probably be forgotten :-(
> >  >
> >  > As far as I can tell (please correct me if I am wrong) the hardware 
> > either no
> >  > longer available or very hard to get hold off.
> > The product has been discontinued a couple of years ago. AFAIK about 50k 
> > to 100k pieces have been sold.
> > 
> >  > I did see that Terratec still sells some DAB receivers, but they are 
> > all based
> >  > on different hardware.
> > Yes you are right. We currently do not develop any DAB products and I 
> > don't think there will be DAB Linux support from other companies. DAB 
> > and even DAB+ is dead.
> 
> I agree. Thank you for your help!
> 
> Mauro, do you think we can remove it for 2.6.38 based on the information
> provided (i.e. that there is no commercial product that is supported by
> this driver), or do you want to deprecate it first and remove it in 2.6.39?

Never mind, I missed the patch that moved it to staging. No point in doing
anything more.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

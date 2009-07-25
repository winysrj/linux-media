Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52516 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZGYNgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 09:36:08 -0400
Date: Sat, 25 Jul 2009 16:25:21 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"dougsland@gmail.com" <dougsland@gmail.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCHv10 6/8] FMTx: si4713: Add files to handle si4713 i2c
 device
Message-ID: <20090725132521.GE10561@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com>
 <200907251520.53119.hverkuil@xs4all.nl>
 <1FFEF31EBAA4F64B80D33027D4297760047DF3D655@NOK-EUMSG-02.mgdnok.nokia.com>
 <200907251533.55361.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907251533.55361.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 25, 2009 at 03:33:55PM +0200, ext Hans Verkuil wrote:
> On Saturday 25 July 2009 15:29:38 ext-Eero.Nurkkala@nokia.com wrote:
> > 
> > > I'm surprised at these MAX string lengths. Looking at the RDS standard it
> > > seems that the max length for the PS_NAME is 8 and for RADIO_TEXT it is
> > > either 32 (2A group) or 64 (2B group). I don't know which group the si4713
> > > uses.
> > > 
> > > Can you clarify how this is used?
> > > 
> > > Regards,
> > > 
> > >         Hans
> > 
> > Well, PS_NAME can be 8 x n, but only 8 bytes are shown at once...
> > so it keeps 'scrolling', or changes periodically. There's even commercial
> > radio stations that do so.
> 
> And I'm assuming that the same is true for radio text. However, this behavior
> contradicts the control description in the spec, so that should be clarified.

Yes, I'll add a comment explaining this for those defines.

> 
> Regards,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin

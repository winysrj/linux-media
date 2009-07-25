Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2471 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZGYNeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 09:34:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: ext-Eero.Nurkkala@nokia.com
Subject: Re: [PATCHv10 6/8] FMTx: si4713: Add files to handle si4713 i2c device
Date: Sat, 25 Jul 2009 15:33:55 +0200
Cc: eduardo.valentin@nokia.com, mchehab@infradead.org,
	dougsland@gmail.com, matti.j.aaltonen@nokia.com,
	linux-media@vger.kernel.org
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com> <200907251520.53119.hverkuil@xs4all.nl> <1FFEF31EBAA4F64B80D33027D4297760047DF3D655@NOK-EUMSG-02.mgdnok.nokia.com>
In-Reply-To: <1FFEF31EBAA4F64B80D33027D4297760047DF3D655@NOK-EUMSG-02.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251533.55361.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 25 July 2009 15:29:38 ext-Eero.Nurkkala@nokia.com wrote:
> 
> > I'm surprised at these MAX string lengths. Looking at the RDS standard it
> > seems that the max length for the PS_NAME is 8 and for RADIO_TEXT it is
> > either 32 (2A group) or 64 (2B group). I don't know which group the si4713
> > uses.
> > 
> > Can you clarify how this is used?
> > 
> > Regards,
> > 
> >         Hans
> 
> Well, PS_NAME can be 8 x n, but only 8 bytes are shown at once...
> so it keeps 'scrolling', or changes periodically. There's even commercial
> radio stations that do so.

And I'm assuming that the same is true for radio text. However, this behavior
contradicts the control description in the spec, so that should be clarified.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1355 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZFPLWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 07:22:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCHv7 7/9] FMTx: si4713: Add files to handle si4713 i2c device
Date: Tue, 16 Jun 2009 13:22:13 +0200
Cc: ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com> <200906141431.55725.hverkuil@xs4all.nl> <20090616110609.GC16092@esdhcp037198.research.nokia.com>
In-Reply-To: <20090616110609.GC16092@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906161322.13518.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 16 June 2009 13:06:09 Eduardo Valentin wrote:
> On Sun, Jun 14, 2009 at 02:31:55PM +0200, ext Hans Verkuil wrote:
> > > +     if (rval < 0)
> > > +             goto exit;
> > > +
> > > +     /* TODO: How to set frequency to measure current signal length
> > > */
> >
> > Huh? I don't understand this TODO.
>
> The todo is about the property this device had, to report signal length

'signal length' or 'signal strength'? If it is the former, then I don't 
understand what you mean with that term.

> of a freq. It used to work like: user echoes the freq on sysfs entry.
> when reading the same entry, it reports the signal noise there.
>
> This is something which I still don't know the proper place to put.
>
> I thought in another ext control. But I don't know if this fix into
> the fm tx controls. Maybe I should use a private one ?

I need to understand this better first.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

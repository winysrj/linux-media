Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1737 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZGYO3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 10:29:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCH 1/1] v4l2-ctl: Add G_MODULATOR before set/get frequency
Date: Sat, 25 Jul 2009 16:29:26 +0200
Cc: ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1248453732-1966-1-git-send-email-eduardo.valentin@nokia.com> <200907251610.53698.hverkuil@xs4all.nl> <20090725140801.GG10561@esdhcp037198.research.nokia.com>
In-Reply-To: <20090725140801.GG10561@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251629.26421.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 25 July 2009 16:08:01 Eduardo Valentin wrote:
> On Sat, Jul 25, 2009 at 04:10:53PM +0200, ext Hans Verkuil wrote:
> > On Friday 24 July 2009 18:42:12 Eduardo Valentin wrote:
> > > As there can be modulator devices with get/set frequency
> > > callbacks, this patch adds support to them in v4l2-ctl utility.
> > 
> > Thanks for this patch.
> > 
> > I've implemented it somewhat differently (using the new V4L2_CAP_MODULATOR
> > to decide whether to call G_TUNER or G_MODULATOR) and pushed it to my
> > v4l-dvb-strctrl tree. I've also improved the string print function so things
> > like newlines and carriage returns are printed as \r and \n.
> > 
> > Can you mail me the output of 'v4l2-ctl --all -L' based on this updated
> > version of v4l2-ctl? I'd like to check whether everything is now reported
> > correctly.
> 
> Yes sure. But there is also the RDS output for txsubchannel. This is missing
> now for G_MODULATOR. RDS is also missing in S_MODULATOR.

Added both.

> S_MODULATOR is also 
> confusing to me. The strings can be set only with one value? I though I could
> do something like:
> 
> v4l2-ctl -d /dev/radio0 --set-modulator=rds,stereo

The reason I did that is that txsubchans only supports specific flag
combinations. So rather than having to make all sorts of verification
code I decided to make these combinations explicit.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2364 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZFPLS6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 07:18:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCHv7 2/9] v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX controls
Date: Tue, 16 Jun 2009 13:18:57 +0200
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Eduardo Valentin <edubezval@gmail.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com> <200906141859.13982.hverkuil@xs4all.nl> <20090616105234.GB16092@esdhcp037198.research.nokia.com>
In-Reply-To: <20090616105234.GB16092@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906161318.57666.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 16 June 2009 12:52:34 Eduardo Valentin wrote:
> > It is my believe that the other fm_tx controls are unambiguously
> > transmitter related, so I don't think they need a TX prefix. It doesn't
> > hurt if someone can double check that, though.
>
> hmm.. I see no problem removing the fmtx prefix of the preemphasis
> enum. But, if it is becoming a generic enum, better to check if its
> meaning is the same of existing emphasis enum for mpeg.

It has the same meaning, but unfortunately the mpeg enum is already a public 
API and so cannot be changed. I never realized at the time that that enum 
is more generic than I thought.

But at least this enum can be made generic.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

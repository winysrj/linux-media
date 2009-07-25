Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2587 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZGYQo4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 12:44:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Changes to the string control handling
Date: Sat, 25 Jul 2009 18:44:44 +0200
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"dougsland@gmail.com" <dougsland@gmail.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com> <200907251639.18441.hverkuil@xs4all.nl> <20090725144127.GI10561@esdhcp037198.research.nokia.com>
In-Reply-To: <20090725144127.GI10561@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251844.45017.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eduardo,

On Saturday 25 July 2009 16:41:27 Eduardo Valentin wrote:
> On Sat, Jul 25, 2009 at 04:39:18PM +0200, ext Hans Verkuil wrote:
> > If the string must be exactly 8 x n long, then I think that it is a good idea
> > to start using the 'step' value of v4l2_queryctrl: this can be used to tell
> > the application that string lengths should be a multiple of the step value.
> > I've toyed with that idea before but I couldn't think of a good use case,
> > but this might be it.
> 
> I think that would be good. It is a way to report to user land what can be
> done in these cases which strings can be chopped in small pieces. Of course,
> documenting this part it is appreciated.

Ok, I've implemented this. While doing this I realized that I had to change
a few things:

1) the 'length' field in v4l2_ext_control has been renamed to 'size'. The
name 'length' was too easy to confuse with 'string length' while in reality
it referred to the memory size of the control payload. 'size' is more
appropriate.

2) the 'minimum' and 'maximum' fields of v4l2_queryctrl now return the min
and max string lengths, i.e. *without* terminating zero. I realized that what
VIDIOC_QUERYCTRL returns has nothing to do with how much memory to reserve
for the string control. It is about the properties of the string itself
and it is not normal to include the terminating zero when talking about a
string length.

I've incorporated everything in my v4l-dvb-strctrl tree. I apologize for the
fact that you have to make yet another series of patches, but these changes
are typical when you start implementing and documenting a new feature for
the first time.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

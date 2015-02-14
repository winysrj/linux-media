Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52926 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbbBNLAZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2015 06:00:25 -0500
Date: Sat, 14 Feb 2015 09:00:19 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv4 00/25] dvb core: add basic support for the media
 controller
Message-ID: <20150214090019.798b6d18@recife.lan>
In-Reply-To: <54DF1625.20808@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<54DF1625.20808@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 14 Feb 2015 10:32:21 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
> > This patch series adds basic support for the media controller at the
> > DVB core: it creates one media entity per DVB devnode, if the media
> > device is passed as an argument to the DVB structures.
> > 
> > The cx231xx driver was modified to pass such argument for DVB NET,
> > DVB frontend and DVB demux.
> > 
> > -
> > 
> > version 4:
> > 
> > - Addressed the issues pointed via e-mail
> 
> No, you didn't. Especially with regards to the alsa node definition. I'm
> pretty sure you need at least the subdevice information which is now removed.

Well, back on Jan, 26 I answered your issues about that at:
	http://www.spinics.net/lists/linux-media/msg85857.html

As you didn't reply back in a reasonable amount of time, I assumed that
you're happy with that.

In any case, the definitions are still there, as nothing got dropped
from the external header.

So, when ALSA media controller support will be added at the Kernel, we
can decide if it will use major/minor or card/device/subdevice or both.

As I said back in Jan, 26, IMO, the best would be to use both:

struct media_entity_desc {
	...
	union {
		struct {
			u32 major;
			u32 minor;
		} dev;
		/* deprecated fields */
		...
	}
	union {
		struct {
			u32 card;
			u32 device;
			u32 subdevice;
		} alsa_props;
		__u8 raw[172];
	}
}

(additional and deprecated fields removed just to simplify its
 representation above)

Even for ALSA, it is a way easier for libmediactl.c to keep using
major/minor to get the device node name via both udev/sysfs than
using anything else, as I don't think that udev has any method to
find the associated name without major,minor information. Ok, there
are indirect methods using the ALSA API to get such association, but
it is just easier to fill everything at the struct than to add the
extra complexity for the media control clients to convert between
major/minor into card/device/subdevice.

What I'm saying is that the card/device/subdevice really seems to be
an extra property for this specific type of devnode, and not a
replacement.

In any case, I think we should take the decision on how to properly
map the ALSA specific bits when we merge ALSA media controller patches,
and not before.

> I also do *not* like the fact that you posted a v4 and immediately applied
> these patches to the master without leaving any time for more discussions.
> 
> These patches change the kernel API and need to go to proper review and need
> a bunch of Acks, Laurent's at the very minimum since he's MC maintainer.
>
> Please revert the whole patch series from master, then we can discuss this
> more.
> 
> For the record, for patch 02/25:
> 
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I do *not* agree with this API change.
> 
> We can discuss this more on Monday.

This hole series is for discussions for a long time (since the beginning of
January), without rejection, and its now starting to receive patches from
other authors. Keeping it OOT just makes harder to discuss and for people to
test. It is time to move on.

As I said on IRC, as I opted to merge it for 3.21, we'll have 2 entire
Kernel cycles to make it mature before being merged upstream. During that
period, we can fix any issues on it.

Regards,
Mauro

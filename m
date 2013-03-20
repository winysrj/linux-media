Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:64229 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab3CTLTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 07:19:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "edubezval@gmail.com" <edubezval@gmail.com>
Subject: Re: [PATCH 0/4] media: si4713: minor updates
Date: Wed, 20 Mar 2013 12:18:48 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com> <201303201004.05563.hverkuil@xs4all.nl> <CAC-25o-rJGeYnQ91E4W888Ak6GxVe9u6e0ZY-qcpfoaKNkU0hw@mail.gmail.com>
In-Reply-To: <CAC-25o-rJGeYnQ91E4W888Ak6GxVe9u6e0ZY-qcpfoaKNkU0hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303201218.48929.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 12:11:11 edubezval@gmail.com wrote:
> Hi Hans,
> 
> My last email didn't reach the list, so re-sending.
> 
> On Wed, Mar 20, 2013 at 5:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > Hi Eduardo!
> >
> > On Tue 19 March 2013 16:41:30 Eduardo Valentin wrote:
> > > Hello Mauro and Hans,
> > >
> > > Here are a couple of minor changes for si4713 FM transmitter driver.
> >
> > Thanks!
> 
> No problem!
> 
> >
> > Patches 2-4 are fine, but I don't really see the point of the first patch
> > (except for the last chunk which is a real improvement).
> >
> > The Codingstyle doesn't require such alignment, and in fact it says:
> >
> > "Descendants are always substantially shorter than the parent and
> > are placed substantially to the right. The same applies to function
> > headers
> > with a long argument list."
> >
> > Unless Mauro thinks otherwise, I would leave all the alignment stuff alone
> > and just post a version with the last chunk.
> >
> 
> OK. The chunks on patch 01 are mostly to get rid of these outputs out
> of checkpatch.pl --strict -f drivers/media/radio/radio-si4713.c:
> CHECK: Alignment should match open parenthesis
> #97: FILE: media/radio/radio-si4713.c:97:
> +       strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
> +                               sizeof(capability->card));

Ah. I never use --strict, so that's why I never saw that. I have no major
problems with this so I give my Ack for this patch as well (even though
I believe it is a bit overkill :-) ).

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> 
> > For patches 2-4:
> >
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >
> 
> 
> Nice! I will add your Acked-by.
> 
> 
> > Are you still able to test the si4713 driver? Because I have patches
> 
> 
> 
> I see. In fact that is my next step on my todo list for si4713. I
> still have an n900 that I can fetch from my drobe, so just a matter of
> booting it with newer kernel.
> 
> > outstanding that I would love for someone to test for me:
> >
> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/si4713
> >
> > In particular, run the latest v4l2-compliance test over it.
> >
> 
> 
> OK. I will check your branch once I get my setup done and let you know.

Great! Let me quickly rebase my tree first. I'll mail you when that's done.

Regards,

	Hans

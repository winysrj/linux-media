Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4326 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2HFOTe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 10:19:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v8] media: Add stk1160 new driver
Date: Mon, 6 Aug 2012 16:18:56 +0200
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Takashi Iwai <tiwai@suse.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
References: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com> <CALF0-+Xwa6qNH3pEOgJq9f07C+ArNco6nxQcjGWoy5kwyQeScA@mail.gmail.com> <501FCFE1.7010802@redhat.com>
In-Reply-To: <501FCFE1.7010802@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208061618.56479.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon August 6 2012 16:08:33 Mauro Carvalho Chehab wrote:
> Em 06-08-2012 10:58, Ezequiel Garcia escreveu:
> > Hi Mauro,
> > 
> > On Mon, Aug 6, 2012 at 10:38 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> >> This driver adds support for stk1160 usb bridge as used in some
> >> video/audio usb capture devices.
> >> It is a complete rewrite of staging/media/easycap driver and
> >> it's expected as a replacement.
> >> ---
> >>
> > 
> > I just sent v8, but it looks it wasn't received by patchwork either.
> > 
> > What's going on?
> 
> The patch didn't arrive at linux-media ML.
> 
> Not sure why it got rejected at vger. I suggest you to ping vger admin
> to see why your patches are being rejected there.
> 
> I tested parsing this patch manually and patchwork accepted. So, once
> the issue with vger is solved, other patches should be properly
> handled there.

Could it be related to the fact that a gmail account is used? Konke Radlow
had a similar issue recently when he posted a patch from a gmail account. It
worked fine when posted from a company account.

Regards,

	Hans

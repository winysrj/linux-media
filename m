Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2412 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab3CYIxS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 04:53:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [REVIEW PATCH 09/42] sony-btf-mpx: the MPX driver for the sony BTF PAL/SECAM tuner
Date: Mon, 25 Mar 2013 09:52:56 +0100
Cc: linux-media@vger.kernel.org,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl> <25054205c5119e9e7a86aad5a15ea0b5f8b0ca30.1363000605.git.hans.verkuil@cisco.com> <20130324122112.07348e39@redhat.com>
In-Reply-To: <20130324122112.07348e39@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303250952.56955.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 24 2013 16:21:12 Mauro Carvalho Chehab wrote:
> Em Mon, 11 Mar 2013 12:45:47 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The Sony BTF PG472Z has an internal MPX to deal with mono/stereo/bilingual
> > audio. This is split off from the wis-sony-tuner driver that is part of
> > the go7007 driver as it should be a separate i2c sub-device driver.
> > 
> > The wis-sony-tuner is really three i2c devices: a standard tuner, a tda9887
> > compatible demodulator and this mpx. After this patch the wis-sony-tuner
> > can be replaced by this driver and the standard tuner driver.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/i2c/Kconfig        |   11 +-
> >  drivers/media/i2c/Makefile       |    1 +
> >  drivers/media/i2c/sony-btf-mpx.c |  399 ++++++++++++++++++++++++++++++++++++++
> 
> Not sure what happened, but sony-btf-mpx.c got missed on the version inside
> the pull request.
> 
> So, I got it from this patch.

Grr. I found the same 'const' issue as you did, fixed it in my tree but forgot
to do a git add for the file :-(

Sorry.

Regards,

	Hans

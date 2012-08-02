Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1366 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab2HBG0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 02:26:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Subject: Re: [PATCH for v3.6] VIDIOC_ENUM_FREQ_BANDS fix
Date: Thu, 2 Aug 2012 08:25:20 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201208012152.46310.hverkuil@xs4all.nl> <201208012341.16986.remi@remlab.net>
In-Reply-To: <201208012341.16986.remi@remlab.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208020825.21008.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed August 1 2012 22:41:16 Rémi Denis-Courmont wrote:
> Le mercredi 1 août 2012 22:52:46 Hans Verkuil, vous avez écrit :
> > When VIDIOC_ENUM_FREQ_BANDS is called for a driver that doesn't supply an
> > enum_freq_bands op, then it will fall back to reporting a single freq band
> > based on information from g_tuner or g_modulator.
> 
> By the way...
> 
> Isn't V4L2_TUNER_CAP_FREQ_BANDS expected to tell whether the driver can 
> enumerate bands?

Yes. And it is set as well in this fallback case.

> Why is there a need for fallback implementation?

The main reason is that struct v4l2_frequency_band also returns the modulation
of the frequency band. For all existing drivers (except radio-cadet, which
now implements enum_freq_bands) this can be deduced by the type of device node
that's used (/dev/radioX means FM, /dev/videoX or vbiX means VSB). While the
application could do the same we decided it was more consistent if the V4L2
core does that for the application. It was trivial to implement.

So apps will benefit, and only drivers that actually have more than one
frequency band need to go to the trouble of implementing enum_freq_bands.

Regards,

	Hans

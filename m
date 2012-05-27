Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2802 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2E0JXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 05:23:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Discussion: How to deal with radio tuners which can tune to multiple bands
Date: Sun, 27 May 2012 11:23:39 +0200
Cc: halli manjunatha <hallimanju@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1337032913-18646-1-git-send-email-manjunatha_halli@ti.com> <4FBD2C80.3060406@redhat.com> <4FC1EE93.9020003@redhat.com>
In-Reply-To: <4FC1EE93.9020003@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205271123.39715.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun May 27 2012 11:06:27 Hans de Goede wrote:
> Hi,
> 
> Just noticed the following on:
> http://linuxtv.org/downloads/v4l-dvb-apis/tuner.html#id2570531
> 
> "This specification does not define radio output devices.", iow no
> radio modulators, but we agreed upon making the band changes to
> the modulator too, and this makes sense because AFAIK we do support
> radio modulators.
> 
> I hit this while working on adding support for the proposed API to
> v4l2-ctl, as I wanted to only print the band stuff for radio type
> devices, but the modulator struct has no type!
> 
> Regards,
> 
> Hans
> 

Yeah, that section needs to be rewritten. We have no TV modulators at all.
If a video/vbi node supports G/S_MODULATOR, then it is a TV modulator. If
a radio node supports it, then it is a radio modulator.

Even for g/s_freq and g/s_tuner the type field is now determined strictly
by the type of the node. It is no longer possible to e.g. query the radio
tuner from a video node. It used to be possible (as least in theory) in the
past, but that was crazy.

Regards,

	Hans

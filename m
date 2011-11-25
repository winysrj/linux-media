Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1645 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1KYPZt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 10:25:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
Date: Fri, 25 Nov 2011 16:25:44 +0100
Cc: Andreas Oberritter <obi@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <4ECF9038.6050208@linuxtv.org> <4ECFB1DC.2090304@redhat.com>
In-Reply-To: <4ECFB1DC.2090304@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251625.44135.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 25, 2011 16:18:52 Mauro Carvalho Chehab wrote:
> The V4L2 API complements the ALSA API. Audio streaming, audio format negotiation
> etc are via the ALSA API.
> 
> > Can you control pass-through of digital audio to SPDIF for example? Can
> > you control which decoder should be the master when synchronizing AV?
> 
> Patches for that are being proposed and should be merged soon. They are part
> of the set of patches under discussion with ALSA people, as part of the Media
> Controller API.

Can you provide a link to those patches? I haven't seen anything cross-posted
to linux-media.

Regards,

	Hans

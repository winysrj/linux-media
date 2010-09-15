Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:43914 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab0IOJzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 05:55:33 -0400
Subject: Re: [PATCH v9 1/4] V4L2: Add seek spacing and FM RX class.
From: "Matti J. Aaltonen" <matti.j.aaltonen@Nokia.com>
Reply-To: matti.j.aaltonen@Nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@Nokia.com>
In-Reply-To: <4C87D782.4030604@redhat.com>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1283168302-19111-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <4C87D782.4030604@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 12:54:55 +0300
Message-ID: <1284544495.25428.64.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On Wed, 2010-09-08 at 20:35 +0200, ext Mauro Carvalho Chehab wrote:

> > +	case V4L2_CID_FM_BAND:			return "FM Band";
> 
> There's no need for a FM control, as there's already an ioctl pair that allows get/set the frequency
> bandwidth: VIDIOC_S_TUNER and VIDIOC_G_TUNER. So, the entire patch here seems uneeded/unwanted.

Yes I agree, we can manage without having BAND support, but it isn't
completely covered by VIDIOC_S_TUNER and VIDIOC_G_TUNER. Actually it
would have had the biggest effect on the HW seek operation. For example
without V4L2_CID_FM_BAND using wl1273  FM radio, which supports two
bands, you need to do two seeks and band switch for every HW_SEEK IOCTL
and those seeks are kind of slow operations to begin with. You have
probably taken this into consideration but I wanted point this out
anyway... Could the seek struct have a band indicator?

B.R.
Matti



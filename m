Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2927 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FCIux (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 04:50:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [RFC PATCH 0/3] bttv: convert to generic TEA575x interface
Date: Mon, 3 Jun 2013 10:50:25 +0200
Cc: linux-media@vger.kernel.org
References: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306031050.26000.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue May 14 2013 22:54:42 Ondrej Zary wrote:
> 
> Hello,
> this patch series removes the tea575x code from bttv and uses the common
> tea575x driver instead. Only set_frequency is implemented (signal/stereo
> detection or seek would require more changes to bttv).
> 
> It works fine on Video Highway Xtreme but I don't have the Miro/Pinnacle or
> Terratec Active Radio Upgrade to test.
> 
> Miro/Pinnacle seems to be simple and should work.
> 
> However, I don't understand the Terratec Active Radio Upgrade code. The HW
> seems to need IOR, IOW and CSEL signals that were taken from ISA bus on
> older cards (IOR and IOW directly and CSEL from some address decoder) and
> are emulated here using GPIOs. But the code manipulating these signals in
> bttv seems to be broken - it never asserts the IOR signal. If anyone has
> this HW, please test if I got that right.

I wish I had this HW as well. There is a radio-terratec driver for this
Radio Upgrade as well in drivers/media/radio.

Anyway, I'm OK with the first two patches, but the last needs some more
work w.r.t. the bttv Kconfig (see my comment to that patch).

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4085 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2E1L6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 07:58:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFCv2 PATCH 0/5] Add hwseek caps and frequency bands
Date: Mon, 28 May 2012 13:58:40 +0200
Cc: linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl> <4FC35F8F.7090703@redhat.com>
In-Reply-To: <4FC35F8F.7090703@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205281358.40725.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 28 2012 13:20:47 Hans de Goede wrote:
> Hi,
> 
> Looks good, the entire series is:
> 
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> 
> I was thinking that it would be a good idea to add a:
> #define V4L2_TUNER_CAP_BANDS_MASK 0x001f0000
> 
> to videodev2.h, which apps can then easily use to test
> if the driver supports any bands other then the default,
> and decide to show band selection elements of the UI or
> not based on a test on the tuner-caps using that mask.
> 
> This can be done in a separate patch, or merged into
> "PATCH 4/6 videodev2.h: add frequency band information"

Good idea, I've merged it into patch 4 and 5 (documenting it).

It's here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/bands

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab2GENKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 09:10:17 -0400
Message-ID: <4FF5925A.7060906@redhat.com>
Date: Thu, 05 Jul 2012 15:10:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>
Subject: Re: [PATCH 0/6] Add frequency band information
References: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Series looks good to me, ack series:

Acked-by: Hans de Goede <hdegoede@redhat.com>

On 07/05/2012 12:25 PM, Hans Verkuil wrote:
> Hi Mauro,
>
> This should be the final patch series for adding multiband support to the
> kernel.
>
> This patch series assumes that this pull request was merged first:
>
> http://patchwork.linuxtv.org/patch/13180/
>
> Changes since the previous RFC patch series:
> (See http://www.mail-archive.com/linux-media@vger.kernel.org/msg48549.html)
>
> - The name field was dropped.
> - A new modulation field was added that describes the possible modulation
>    systems for that frequency band (currently only one modulation system can
>    be supported per band).
> - Compat code was added to allow VIDIOC_ENUM_FREQ_BANDS to be used for
>    existing drivers.
>
> A note regarding the cadet driver: I want to do a follow-up patch to this
> at a later date so that it uses the tea575x-tuner framework. But with these
> patches it will at least work correctly again.
>
> Regards,
>
> 	Hans
>


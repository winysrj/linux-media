Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2IUM1p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 08:27:45 -0400
Message-ID: <505C5D8F.5070007@redhat.com>
Date: Fri, 21 Sep 2012 14:29:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH 0/3] In non-blocking mode return EAGAIN in hwseek
References: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1348227868-20895-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Looks good, but for patch 3/3 you're missing the same changes to
sound/i2c/other/tea575x-tuner.c

Regards,

Hans


On 09/21/2012 01:44 PM, Hans Verkuil wrote:
> This patch series resolves a problem with S_HW_FREQ_SEEK when called in
> non-blocking mode. Currently this would actually block during the seek.
>
> This is not a good idea. This patch changes the spec and the drivers to
> return -EAGAIN when called in non-blocking mode.
>
> In the future actual support for non-blocking mode might be added to
> selected drivers, but that will require a new event (SEEK_READY or something
> like that), and I am not convinced it is worth the effort anyway.
>
> Regards,
>
> 	Hans
>

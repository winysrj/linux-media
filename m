Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2481 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbaGUN7h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:59:37 -0400
Message-ID: <53CD1CBB.2000201@xs4all.nl>
Date: Mon, 21 Jul 2014 15:59:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [PATCH 0/7] si4713/miropcm20: RDS enhancements
References: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2014 03:45 PM, Hans Verkuil wrote:
> This patch series adds a bunch of missing RDS TX controls and implements
> them in the si4713 driver. It also adds back RDS support to the miropcm20
> driver.
> 
> The Alternate Frequencies control is a u32 array since there can be up to
> 25 alternate frequencies. This was also the reason why I am only now posting
> this series since it had to wait for compound control support to go in.
> 
> I've tested both drivers with my si4713 and miropcm20 boards.

I forgot to mention that this sits on top of the ctrls patches from this
pull request:

https://patchwork.linuxtv.org/patch/24885/

Regards,

	Hans

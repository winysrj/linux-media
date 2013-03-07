Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f181.google.com ([209.85.160.181]:57274 "EHLO
	mail-gh0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754Ab3CGSwF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 13:52:05 -0500
Received: by mail-gh0-f181.google.com with SMTP id y8so121455ghb.40
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2013 10:52:04 -0800 (PST)
Date: Thu, 7 Mar 2013 15:46:53 -0300
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/20] solo6x10: V4L2 compliancy fixes and major
 overhaul
Message-ID: <20130307154653.32b94e7f@pirotess>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun,  3 Mar 2013 00:45:16 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote: 
> 3) What is the meaning of this snippet of code in v4l2-enc.c?
> 
> 	if (pix->priv)
> 		solo_enc->type = SOLO_ENC_TYPE_EXT;
> 
>    I've commented it out since it is completely undocumented and no
> driver should assume that priv is non-zero anymore, precisely because
> of issues like this. Ismael, do you know what the difference is
> between SOLO_ENC_TYPE_STD and SOLO_ENC_TYPE_EXT?

When written to the first bit of the 0x480-0x4BC registers
(SOLO_CAP_CH_COMP_ENA_E(n)), it enables the encoding of the respective
extended channel.

It's a bad name :/.

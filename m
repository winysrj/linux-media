Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3418 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3L1M2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:28:34 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBSCSVVH082414
	for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 13:28:33 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 32AEA2A2228
	for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 13:28:01 +0100 (CET)
Message-ID: <52BEC3D1.5080607@xs4all.nl>
Date: Sat, 28 Dec 2013 13:28:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 0/4] add radio-raremono driver
References: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2013 01:26 PM, Hans Verkuil wrote:
> This patch series adds the new radio-raremono driver for the USB
> 'Thanko's Raremono' AM/FM/SW receiver.
> 
> Since it (ab)uses the same USB IDs as the si470x SiLabs Reference
> Design I had to add additional checks to si470x to tell the two apart.
> 
> While editing si470x I noticed that it passes USB buffers from the stack
> instead of using kmalloc, so I fixed that as well.
> 
> I have tested the si470x checks, and the FM and AM receiver of the
> Raremono device have been tested as well. I don't have a SW transmitter,
> nor are there any SW transmitters here in Norway, so I couldn't test it.
> 
> All I can say is that it is definitely tuning since the white noise
> changes when I change frequency. I'll try this nexy week in the Netherlands,
> as I think there are still a few SW transmissions there I might receive.

I've tested this yesterday and the SW receiver works fine.

Regards,

	Hans

> 
> The initial reverse engineering for this driver was done by Dinesh Ram
> as part of his Cisco internship, so many thanks to Dinesh for doing that
> work.
> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


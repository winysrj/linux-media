Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52478 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbaAHOvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 09:51:13 -0500
Received: by mail-ie0-f177.google.com with SMTP id tp5so1948848ieb.8
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 06:51:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
References: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
Date: Wed, 8 Jan 2014 18:51:12 +0400
Message-ID: <CALW4P+KTJOPk5EVZ9cx7fwj=+k5OR1fACNjFtJ8-1eh7ZxOQjQ@mail.gmail.com>
Subject: Re: [REVIEW PATCH 0/4] add radio-raremono driver
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 13, 2013 at 4:26 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
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
>
> The initial reverse engineering for this driver was done by Dinesh Ram
> as part of his Cisco internship, so many thanks to Dinesh for doing that
> work.

Hi Hans,

this is very nice radio and driver. But where did you buy/get this device?
Could you please share a link?

Year ago i tried to find place on internet to buy this device but failed.

-- 
Best regards, Klimov Alexey

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39496 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab1KGT4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 14:56:08 -0500
Received: by faan17 with SMTP id n17so367536faa.19
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2011 11:56:06 -0800 (PST)
Message-ID: <4EB837CE.1050409@gmail.com>
Date: Mon, 07 Nov 2011 20:55:58 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 00/13] Remaining coding style clean up of AS102 driver
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com> <4EB7F709.2050503@gmail.com>
In-Reply-To: <4EB7F709.2050503@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gianluca,

On 11/07/2011 04:19 PM, Gianluca Gennari wrote:
> Hi Sylwester,
> I spotted a minor error in file as102_drv.c line 233:
> in a call to function "dev_err", the first "dev" parameter is missing.
> This produces a compilation warning.

Thanks for pointing that out, not sure how I have managed to overlook this..
I'll wait for some time and I'll probably resend the whole series, including
correction of the above, at the end of this week.

-- 
Regards,
Sylwester

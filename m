Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:62826 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZCaEyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 00:54:51 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2310523yxl.1
        for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 21:54:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
References: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
Date: Tue, 31 Mar 2009 00:54:49 -0400
Message-ID: <412bdbff0903302154w5ddb3fc8m684bcb5092942561@mail.gmail.com>
Subject: Re: [PATCH] Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX China
	DMB-TH digital demodulator
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 17, 2009 at 11:55 AM, David Wong <davidtlwong@gmail.com> wrote:
> This patch contains the unified driver for Legend Silicon LGS8913 and
> LGS8GL5. It should replace lgs8gl5.c in media/dvb/frontends
>
> David T.L. Wong

David,

The questions you posed tonight on a separate thread about making the
xc5000 work with this device prompts the question:

Do you know that this driver you submitted actually works?  Have you
successfully achieved lock with this driver and been able to view the
stream?

It is great to see the improvements and more generic support, but if
you don't have it working in at least one device, then it probably
shouldn't be submitted upstream yet, and it definitely should not be
replacing an existing driver.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:8112 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZCaVvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 17:51:25 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2637412yxl.1
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 14:51:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090331233524.4000cb61@gdc1>
References: <20090329155608.396d2257@gdc1>
	 <20090331075610.53620db8@pedra.chehab.org>
	 <20090331212052.152d2ffc@gdc1>
	 <412bdbff0903311359i3f3883dds2d870c93e23d08f2@mail.gmail.com>
	 <20090331233524.4000cb61@gdc1>
Date: Tue, 31 Mar 2009 17:51:23 -0400
Message-ID: <412bdbff0903311451w776c7b68t22fc3acbcd23fe64@mail.gmail.com>
Subject: Re: [PATCH] Drivers for Pinnacle pctv200e and pctv60e
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Gabriele Dini Ciacci <dark.schneider@iol.it>
Cc: linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@desy.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2009 at 5:35 PM, Gabriele Dini Ciacci
<dark.schneider@iol.it> wrote:
> I it's so, say me how to make or where to look to create a profile for
> the existing driver.
>
> I am willing to do the work.
>
> (when I first wrote the driver to me it seemed that this was the
> simplet way.
>
> Meanwhile I will try to look at the Cypress FX2

As Michael Krufky pointed out to me off-list, I was not exactly correct here.

While there are indeed drivers based on the same FX2 chip in your
device, it may be possible to reuse an existing driver, or you may
need a whole new driver, depending on how much the firmware varies
between your product versus the others.  You may want to look at the
pvrusb2 and cxusb drivers, which also use the FX2 chip, and see what
similarities exist in terms of the API and command set.  If it is not
similar to any of the others, then writing a new driver is probably
the correct approach.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

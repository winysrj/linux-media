Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35668 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1CJWpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 17:45:41 -0500
Received: by ewy4 with SMTP id 4so753218ewy.19
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 14:45:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BF6ACC3F-C9C0-42F4-B649-B4D28AB9B4A4@wilsonet.com>
References: <AANLkTik_W1uE05J+BSY8K6siOdgYxsB1CLmiFUmGy-s8@mail.gmail.com>
	<BF6ACC3F-C9C0-42F4-B649-B4D28AB9B4A4@wilsonet.com>
Date: Thu, 10 Mar 2011 17:45:39 -0500
Message-ID: <AANLkTinm_76Vp+GncB58YvB7HcZ4xQ1E73=js4rznEZL@mail.gmail.com>
Subject: Re: mygica hdcap
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 10, 2011 at 3:30 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> It looks like an at least semi-similar device to the Hauppauge HD-PVR,
> which is under v4l, so it probably does make sense here. Not aware of
> anyone working on your specific hardware, but Hans Verkuil posted some
> patches for some at least similar-ish Analog Devices chips not too
> long ago, which might be relevant to at least that part of your card...
>
> http://git.linuxtv.org/hverkuil/cisco.git?a=shortlog;h=refs/heads/cobalt

Just like with the Hauppauge Colossus, the Analog Devices part is
relatively easy to bring up.  In both cases the hard part is that
there is no bridge driver for either chip, and writing a PCIe driver
from scratch without the datasheet is one of the more
difficult/annoying things for a device driver developer to have to do.

I've looked into the tm6200.  It would be a royal PITA.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

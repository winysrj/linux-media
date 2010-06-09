Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33823 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0FIDpZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 23:45:25 -0400
Received: by vws17 with SMTP id 17so1900905vws.19
        for <linux-media@vger.kernel.org>; Tue, 08 Jun 2010 20:45:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilRCGGcwbln42XBcw_u4-b8Q2QiwtQPMU5gEx0N@mail.gmail.com>
References: <20100604150601.GG23375@redhat.com>
	<AANLkTilRCGGcwbln42XBcw_u4-b8Q2QiwtQPMU5gEx0N@mail.gmail.com>
Date: Tue, 8 Jun 2010 23:45:24 -0400
Message-ID: <AANLkTil9NdTHjvd7aMkMZd5qaFxs8HFA6DcfVcDhGr8R@mail.gmail.com>
Subject: Re: [PATCH] IR/mceusb: clean up gen1 device init
From: Jarod Wilson <jarod@wilsonet.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 8, 2010 at 11:08 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> On Fri, Jun 4, 2010 at 11:06 AM, Jarod Wilson <jarod@redhat.com> wrote:
>> The first-gen mceusb device init code, while mostly functional, had a few
>> issues in it. This patch does the following:
>>
>> 1) removes use of magic numbers
>> 2) eliminates mapping of memory from stack
>> 3) makes debug spew translator functional
>> 4) properly initializes default tx blaster mask
>
> My memory is starting to go. I pretty much resubmitted exactly the
> same patch (https://patchwork.kernel.org/patch/105042/) today,
> forgetting I'd already submitted this. There's a minor context
> difference though, the newer one should match the staging/rc tree
> better.

Or maybe not. I think I pooched one of the mceusb_dev struct member
names, too many patches in flight. Lemme just resend a proper v3
tomorrow...

-- 
Jarod Wilson
jarod@wilsonet.com

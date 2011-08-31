Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab1HaPDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 11:03:52 -0400
Received: by iabu26 with SMTP id u26so842228iab.19
        for <linux-media@vger.kernel.org>; Wed, 31 Aug 2011 08:03:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108311551500.8429@axis700.grange>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
	<Pine.LNX.4.64.1108311551500.8429@axis700.grange>
Date: Wed, 31 Aug 2011 11:03:52 -0400
Message-ID: <CAOcJUbyve2KJE43yTOZYC7yEf8CSuUnqxLVXZNMyqcXM3=xU7g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Capture menu reorganization
From: Michael Krufky <mkrufky@kernellabs.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 31, 2011 at 9:53 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Hans
>
> On Wed, 31 Aug 2011, Hans Verkuil wrote:
>
>> I think this is how I would reorganize the capture menu. IMHO it's much easier
>> to navigate, and should be even better once the soc-camera sensor drivers can
>> be moved to the other sensors.
>>
>> For the radio adapters a similar change would be needed (all the ISA drivers
>> in particular should be grouped in a submenu).
>
> Thanks for tackling this. A general note: I really think, sorting entries
> inside categories alphabetically would help.

This is most certainly a nice and long overdue organizational
improvement - thank you for doing this, Hans.  It all looks good to
go, but we can remove the "&& USB" from the USB submenu as Guennadi
pointed out.

Reviewed-by: Michael Krufky <mkrufky@kernellabs.com>

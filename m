Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:41809 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZHHTIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 15:08:43 -0400
Received: by ewy7 with SMTP id 7so1892068ewy.18
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2009 12:08:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.58.0908081101310.11911@shell2.speakeasy.net>
References: <1249753576.15160.251.camel@tux.localhost>
	 <Pine.LNX.4.58.0908081101310.11911@shell2.speakeasy.net>
Date: Sat, 8 Aug 2009 23:08:43 +0400
Message-ID: <208cbae30908081208o5a048fb0qdd6c356b0c6d3eb9@mail.gmail.com>
Subject: Re: [patch review 6/6] radio-mr800: redesign radio->users counter
From: Alexey Klimov <klimov.linux@gmail.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 8, 2009 at 10:01 PM, Trent Piepho<xyzzy@speakeasy.org> wrote:
> On Sat, 8 Aug 2009, Alexey Klimov wrote:
>> Redesign radio->users counter. Don't allow more that 5 users on radio in
>
> Why?

Well, v4l2 specs says that multiple opens are optional. Honestly, i
think that five userspace applications open /dev/radio is enough. Btw,
if too many userspace applications opened radio that means that
something wrong happened in userspace. And driver can handle such
situation by disallowing new open calls(returning EBUSY). I can't
imagine user that runs more than five mplayers or gnomeradios, or
kradios and so on.

Am i totally wrong here?

Thanks.
-- 
Best regards, Klimov Alexey

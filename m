Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51624 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab2JaUZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 16:25:13 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so2694614iea.19
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2012 13:25:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3pq3ywh0w.fsf@ursa.amorsen.dk>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<m3vcdr1ku9.fsf@ursa.amorsen.dk>
	<50911079.7010404@googlemail.com>
	<m3pq3ywh0w.fsf@ursa.amorsen.dk>
Date: Wed, 31 Oct 2012 17:25:12 -0300
Message-ID: <CALF0-+Xzb_HULqQLkG3OZaG-9bfe7vaLX5nRdgBSehkbyvRqLA@mail.gmail.com>
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Benny,

On Wed, Oct 31, 2012 at 4:58 PM, Benny Amorsen <benny+usenet@amorsen.dk> wrote:
>>
>> Is this a regression caused by patches or a general issue with the
>> Raspberry board ?
>
> It is a general issue with the Raspberry USB host controller or driver.
> Bulk transfers work, isochronous transfers have problems. I was hoping I
> could somehow convince the Nanostick to use bulk transfers instead of
> isochronous transfers. Since that seems to require a firmware change, I
> will have to give up on it.
>
>

Very interesting. Let me see if I understand this: you say it's not a
problem with USB bandwidth,
but with isochronous transfers, in the sense it could achieve enough
speed for streaming
if bulk transfers were used?

Do you have any links supporting this?

Thanks,

    Ezequiel

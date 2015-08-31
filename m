Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36278 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbbHaTMa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 15:12:30 -0400
Subject: Re: [PATCH] media: dvb-core: Don't force CAN_INVERSION_AUTO in
 oneshot mode.
To: Devin Heitmueller <dheitmueller@kernellabs.com>
References: <1441012425-25050-1-git-send-email-tvboxspy@gmail.com>
 <55E488FF.3040608@a1.net> <55E492B8.4020207@gmail.com>
 <CAGoCfiyar01CJxgUqoqz6Kix_4V=-jX58r9XTrKd=eE9qDc28A@mail.gmail.com>
Cc: Johann Klammer <klammerj@a1.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	stable@vger.kernel.org
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <55E4A718.7070101@gmail.com>
Date: Mon, 31 Aug 2015 20:12:24 +0100
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyar01CJxgUqoqz6Kix_4V=-jX58r9XTrKd=eE9qDc28A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin

On 31/08/15 19:07, Devin Heitmueller wrote:
> Hi Malcolm,
>
>>> The capabilities call interacting with the oneshot setting is rather weird
>>> and maybe unexpected.
>>>
>>>
>>
>> No, because in normal mode it can do auto inversion.
...
>
> If the goal was for the software-emulated auto inversion to be
> transparent to userland, perhaps it makes more sense for the oneshot
> mode to toggle the inversion if needed.  The oneshot mode would
> continue to disable zigzag and the stats monitoring.  I realize that
> this is a bit messy since it won't really be "oneshot", but I don't
> know what else can be done without breaking the ABI.
>
I did think flagging INVERSION_AUTO to INVERSION_OFF on frontends
not supporting inversion in oneshot mode.

But it's still messy, as INVERSION_AUTO is need for emulation to work.

Regards


Malcolm

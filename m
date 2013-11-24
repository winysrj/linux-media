Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40456 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3KXSCl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 13:02:41 -0500
Received: by mail-ie0-f179.google.com with SMTP id x13so5572626ief.10
        for <linux-media@vger.kernel.org>; Sun, 24 Nov 2013 10:02:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
References: <20130603171607.73d0b856@endymion.delvare>
	<20130603172150.1aaf1904@endymion.delvare>
	<CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
Date: Sun, 24 Nov 2013 11:02:40 -0700
Message-ID: <CAA9z4Lbro=UjZjcjK1e51ikVG7Q2XU9Ei1XWPELCq47iGowkWg@mail.gmail.com>
Subject: Re: [PATCH 2/3] femon: Display SNR in dB
From: Chris Lee <updatelee@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a frustration of mine. Some report it in SNR others report it
in terms of % (current snr / (max_snr-min_snr)) others its completely
random.

Seems many dvb-s report arbitrary % which is stupid and many atsc
report snr by 123 would be 12.3db. But there isnt any standardization
around.

imo everything should be reported in terms of db, why % was ever
chosen is beyond logic.

Is this something we can get ratified ?

Chris Lee

On Sun, Nov 24, 2013 at 10:21 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi Jean,
>
> Sorry, that I came upon this patch quite late.
>
> On Mon, Jun 3, 2013 at 8:51 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> SNR is supposed to be reported by the frontend drivers in dB, so print
>> it that way for drivers which implement it properly.
>
>
> Not all frontends do report report the SNR in dB. Well, You can say quite
> some frontends do report it that way. Making the application report it in
> dB for frontends which do not will show up as incorrect results, from what
> I can say.
>
> Best Regards,
>
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

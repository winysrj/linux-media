Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:43211 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbBAN0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2015 08:26:36 -0500
Received: by mail-qc0-f171.google.com with SMTP id s11so26833534qcv.2
        for <linux-media@vger.kernel.org>; Sun, 01 Feb 2015 05:26:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54CDFC13.6040908@web.de>
References: <54CDFC13.6040908@web.de>
Date: Sun, 1 Feb 2015 14:26:36 +0100
Message-ID: <CA+O4pCJBg6ggcKqddeRK6AVkz3HPUgMoKjfx1a-5K6fTNrO5Rg@mail.gmail.com>
Subject: Re: Sundtek Media Pro III Europe switching off
From: Markus Rechberger <mrechberger@gmail.com>
To: steigerungs faktor <steigerungsfaktor@web.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You'd need to show us some logfiles.

echo loglevel=min > /etc/sundtek.conf
(and reboot)
or
/opt/bin/mediaclient --loglevel=min (this will turn on the logfile immediately).

Is the tuner attached to a USB 3.0 port?

What does tvheadend say?

The tuner and drivers are 100% stable and proven with tvheadend, so in
case tvheadend is blocked something else must be wrong.

Best Regards,
Markus

On Sun, Feb 1, 2015 at 11:12 AM, steigerungs faktor
<steigerungsfaktor@web.de> wrote:
> Hi.
> New to the list, so maybe topic "Sundtek Media Pro III" has been treatet
> allready.
> If so, please just send "archives".
>
> If not:
> Setup is the the above Stick, newest driver, Linux (Fedora 20), Kodi
> with TVHeadend.
> All fine when initially starting. Shows TV and records shows.
> Then Timer is set, and stick 'stops working'. I.e.: the timed show is
> not recorded.
> Instead Kodi tells me that connection to tvheadend is lost.
> To gain stick back, reboot is necessary.
>
> Any ideas?
>
> Gunter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

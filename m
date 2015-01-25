Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41040 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbbAYQIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 11:08:14 -0500
Received: by mail-ie0-f182.google.com with SMTP id ar1so4939950iec.13
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 08:08:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54C4D24D.2000706@iki.fi>
References: <CAOBYczptqxkRXVPs3UuKJxEtm7uf9=yF9DgpF+e5mqbj6wZRrQ@mail.gmail.com>
	<54C4D24D.2000706@iki.fi>
Date: Sun, 25 Jan 2015 16:08:13 +0000
Message-ID: <CAOBYczoCeMDjCJthynWyC5OhFCqKKDCSjsj93QkcrDHQMv+S3w@mail.gmail.com>
Subject: Re: usb3 + 2 x pctv290e issues
From: Robin Becker <robin@reportlab.com>
To: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to all, I applied the patch suggested by Olli Salonen and I can
now run multiple vlc's on my NUC.

On 25 January 2015 at 11:23, Antti Palosaari <crope@iki.fi> wrote:
> Moikka!
>
>
> On 01/25/2015 11:33 AM, Robin Becker wrote:
>>
>> Has anyone else her had the problem described in
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=65021
>>
>> ie complete xhci freeze when a second pctv290e is accessed with vlc.
>> I'm wondering if this is a problem specific to em28xx or the pctv290e
>> or to this kind of device (ie dvb usb).
>
>
> I have seen multiple times USB3 issues and reboot is needed in order to
> solve those. USB3 is simply not enough robust yet. Due to that, I will never
> use USB3 ports when developing the drivers - I only test it very quickly
> when driver is about ready.
>
> regards
> Antti
>
> --
> http://palosaari.fi/



-- 
Robin Becker

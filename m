Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59445 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2FKQjD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 12:39:03 -0400
Received: by ghrr11 with SMTP id r11so2659696ghr.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 09:39:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD5F30E.2060108@redhat.com>
References: <CALF0-+VmR6izw6zXj+kOsrQDPN94v8jqhoRmeYp1vvexuoFJ1Q@mail.gmail.com>
	<4FD5F30E.2060108@redhat.com>
Date: Mon, 11 Jun 2012 13:39:02 -0300
Message-ID: <CALF0-+WPOw2tHaTF0zYkmP9Z1kORVjYGAAh-p0_sV6FLqUBZBQ@mail.gmail.com>
Subject: Re: [Q] Why is it needed to add an alsa module to v4l audio capture devices?
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Mauro,

On Mon, Jun 11, 2012 at 10:30 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 07-06-2012 15:26, Ezequiel Garcia escreveu:
>> Hi all,
>>
>> (I hope this is a genuine question, and I'm not avoiding my own homework here.)
>>
>> I'm trying to support the audio part of the stk1160 usb bridge
>> (similar to em28xx).
>> Currently, the snd-usb-audio module is being loaded when I physically
>> plug my device,
>> but I can't seem to capture any sound with vlc.
>
> Laurent already explained why snd-usb-audio is loaded.
>>
>> I still have to research and work a lot to understand the connection
>> between my device
>> and alsa, and altough I could write a working module similar to
>> em28xx-alsa.ko, I still
>> can't figure out why do I need to write one in the first place.
>
> On em28xx, some devices use UAC (USB Audio Class), while others use a proprietary
> vendor class protocol. The em28xx-alsa module is used only for the devices with a
> vendor class.
>>
>> Why is this module suffficient for gspca microphone devices (gspca, to name one)
>> and why is a new alsa driver needed for em28xx (or stk1160)?
>
> On em28xx, even the ones that use UAC require some configuration, for audio to work.
>
> some setup is required to configure the audio input associated with a video input,
> and to enable clock for the audio sampler. Such setup is made when a video input is
> selected. You likely need something similar for stk1160.
>

It is *much* clear now, thanks to both.

Ezequiel.

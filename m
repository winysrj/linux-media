Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46764 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1HRNjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 09:39:45 -0400
Received: by pzk37 with SMTP id 37so3022165pzk.1
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2011 06:39:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPz3gmkRoh_gXU4PtzVhXb=0BOBjcgmhK7CCCq5ioajfjHZg3A@mail.gmail.com>
References: <CAPz3gmkRoh_gXU4PtzVhXb=0BOBjcgmhK7CCCq5ioajfjHZg3A@mail.gmail.com>
Date: Thu, 18 Aug 2011 15:39:44 +0200
Message-ID: <CAL9G6WUFyWuKJQnTBCW6StEfoWeKhXix3rFkU9eC8AxEbuD5Uw@mail.gmail.com>
Subject: Re: Record DVB-T from command line
From: Josu Lazkano <josu.lazkano@gmail.com>
To: shacky <shacky83@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/18 shacky <shacky83@gmail.com>:
> Hi.
>
> I need to record from DVB-T using the command line.
> I'm looking for some commands to make that saving the recording to a .ts file.
> Could you help me please?
>
> Thank you very much!
> Bye.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

You can try this:

szap -a 0 -c channels_astra.conf -r "TV3 CAT"
cat /dev/dvb/adapter0/dvr0 > testvideo.mpg
mplayer testvideo.mpg

This is for DVB-S, you can change it with tzap, first you need to scan
your local channels.

Regards.

-- 
Josu Lazkano

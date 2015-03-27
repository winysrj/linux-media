Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35389 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbbC0Mb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 08:31:29 -0400
Received: by ierf6 with SMTP id f6so2145490ier.2
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 05:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNX+covLWsgpUdW5sOfHtka6B93wK6y8o6A2+qt6PGkWug@mail.gmail.com>
References: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
	<1427457439-1493-5-git-send-email-olli.salonen@iki.fi>
	<CALzAhNX+covLWsgpUdW5sOfHtka6B93wK6y8o6A2+qt6PGkWug@mail.gmail.com>
Date: Fri, 27 Mar 2015 14:31:28 +0200
Message-ID: <CAAZRmGwkxsajMJj2xNjBJsYAQcmm8upWrWOe32wSm6RpKEFX-Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] saa7164: Hauppauge HVR-2205 and HVR-2215 DVB-C/T/T2 tuners
From: Olli Salonen <olli.salonen@iki.fi>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Feel free to ignore the patches I sent. Just thought that since I made
the work to get the devices working anyway I'll post my code in case
someone can benefit from that somehow.

The HVR-2215 is sold in Australia, it's not a prototype card:
http://www.pccasegear.com/index.php?main_page=product_info&products_id=28385&cPath=172

I also know a user in AU who has tested my code with HVR-2215 and it works ok.

My understanding is that the Windows driver does set the gapped clock,
the below is from Hauppauge's own Windows driver INF files for
HVR-2205 (I assume the parameters pointing to Si2164 apply also to
Si2168):

;gapped clock
HKR,"Parameters","Si2164_ts_clk_gapped_en",0x00010001, 1

However, it is true that the device seems to work with or without this
setting. That was the case with TechnoTrend CT2-4400 earlier as well.
Only when TT made another version of the same device (with the same
USB IDs etc.) it stopped working and the change was necessary.

Cheers,
-olli


On 27 March 2015 at 14:08, Steven Toth <stoth@kernellabs.com> wrote:
>> I know there's parallel activity ongoing regarding these devices, but I
>> thought I'll submit my own version here as well. The maintainers of each
>> module can then make the call what to merge.
>
> http://git.linuxtv.org/cgit.cgi/stoth/media_tree.git/log/?h=saa7164-dev
>
> As mentioned previously, I've added support for the HVR2205 and
> HVR2255. I moved those patches from bitbucket.org into linuxtv.org a
> couple of days ago pending a pull request. It took a couple of days to
> get my git.linuxtv.org account back up and running.
>
> You've seen and commented on the patches when they were in bitbucket
> earlier this week, so your need to push our your own patches only
> confuses and concerns me.
>
> I did not require any 2168/2157 driver changes to make these devices
> work. (Antti please note).
>
> I plan to issue a pull request for my tree shortly.
>
> - Steve
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com

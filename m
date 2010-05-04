Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59059 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab0EDAoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 20:44:03 -0400
Received: by pva4 with SMTP id 4so667022pva.19
        for <linux-media@vger.kernel.org>; Mon, 03 May 2010 17:44:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BDF60AB.8020600@redhat.com>
References: <4BDE7DB4.7030706@redhat.com>
	 <k2y6e8e83e21005030113v64aea6c0q87754a5d8f04d2d4@mail.gmail.com>
	 <4BDF60AB.8020600@redhat.com>
Date: Tue, 4 May 2010 08:44:01 +0800
Message-ID: <g2j6e8e83e21005031744s429fdbe7g1a106e13949ad33c@mail.gmail.com>
Subject: Re: [PATCH] Fix colorspace on tm6010
From: Bee Hock Goh <beehock@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Its too much time to fix it so I simply reinstall the OS but I will be
working with hg tree for the time being.

True but having the audio will probably help to ascertain how bad the
frame loss is. And also writing the audio module will be trivial to
you but it will take some time for me.


On Tue, May 4, 2010 at 7:47 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Bee Hock Goh wrote:
>> lot of good changes to tm6000. Unfortunately, I am not able to test
>> any of this at the moment. Git not working for me anymore as 2.6.33
>> insist to freeze my machine on boot.
>>
>> Reverting to hg does not work as well after my upgrade to lucid. :)
>>
>> Apparently, its now complain about invalid module format.
>>
>> if everything work out again, I would like to try and get the audio working.
>>
>
> Due to your last email, I suspect you already found a solution to make your
> distro to work again.
>
> Audio should be trivial: just finish writing the tm6000-alsa logic
> (currently, it is just an skeleton), based on snd-usb-audio (you might also
> use the em28xx module as reference, but snd-usb-audio should be the primary
> one, since it is maintained by alsa guys, so, in thesis, it probably use better
> the alsa API). I bet that just copying the values of the alsa stream to the
> audio channels will be enough for having audio.
>
> The thing is: before going to audio, we need to be sure that we're not loosing
> anything at copy_streams logic, since, while it is not that bad to loose a video
> packet (as we may just repeat the last frame, as the current logic), but this
> doesn't work with audio.
>
> --
>
> Cheers,
> Mauro
>

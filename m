Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0ECXsA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 19:48:00 -0400
Message-ID: <4BDF60AB.8020600@redhat.com>
Date: Mon, 03 May 2010 20:47:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Bee Hock Goh <beehock@gmail.com>
CC: "linux-media >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix colorspace on tm6010
References: <4BDE7DB4.7030706@redhat.com> <k2y6e8e83e21005030113v64aea6c0q87754a5d8f04d2d4@mail.gmail.com>
In-Reply-To: <k2y6e8e83e21005030113v64aea6c0q87754a5d8f04d2d4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bee Hock Goh wrote:
> lot of good changes to tm6000. Unfortunately, I am not able to test
> any of this at the moment. Git not working for me anymore as 2.6.33
> insist to freeze my machine on boot.
> 
> Reverting to hg does not work as well after my upgrade to lucid. :)
> 
> Apparently, its now complain about invalid module format.
> 
> if everything work out again, I would like to try and get the audio working.
> 

Due to your last email, I suspect you already found a solution to make your
distro to work again.

Audio should be trivial: just finish writing the tm6000-alsa logic
(currently, it is just an skeleton), based on snd-usb-audio (you might also
use the em28xx module as reference, but snd-usb-audio should be the primary
one, since it is maintained by alsa guys, so, in thesis, it probably use better
the alsa API). I bet that just copying the values of the alsa stream to the
audio channels will be enough for having audio.

The thing is: before going to audio, we need to be sure that we're not loosing
anything at copy_streams logic, since, while it is not that bad to loose a video
packet (as we may just repeat the last frame, as the current logic), but this
doesn't work with audio.

-- 

Cheers,
Mauro

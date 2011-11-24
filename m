Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab1KXNcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:32:47 -0500
Message-ID: <4ECE477A.5060707@infradead.org>
Date: Thu, 24 Nov 2011 11:32:42 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: PULL request for 3.2 (fixes 'n' features)
References: <alpine.LRH.2.00.1110041130530.28076@pub4.ifh.de> <alpine.LRH.2.02.1111241023410.16976@pub4.ifh.de>
In-Reply-To: <alpine.LRH.2.02.1111241023410.16976@pub4.ifh.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-11-2011 07:26, Patrick Boettcher escreveu:
> Hi Mauro,
> 
> On Tue, 4 Oct 2011, Patrick Boettcher wrote:
> 
>> Hi Mauro,
>>
>> if it's not too late for 3.2 could you please pull from
>>
>> git://linuxtv.org/pb/media_tree.git staging/for_v3.2
>>
>> for
>>
>> [media] dib9090: limit the I2C speed [media] dib8096P: add the reference board [media] add the support for DiBcom [media] dib7090: add the reference board [media] DiB8000: improve the tuning and the SNR monitoring
>> [media] DiBcom: correct warnings
>> [media] dib7090: add the reference board TFE7090E
>> [media] dib7000p/dib0090: update the driver
> 
> I think this PULL request got lost. (as usual for my pull-requests :( ).

Yes, I didn't get your pull request. Now that we're using patchwork, to also track pull
requests, it is easy for you to check if the pull request is on my queue. Just take a
look at http://patchwork.linuxtv.org.

It should be noticed that patchwork relies on the way that git request-pull formats the
message:

$  git request-pull HEAD^1 .
The following changes since commit db9bc660cf4d1a09565f5db2bab9d3b86e3e32a5:

  [media] ir-rc6-decoder: Support RC6-6A variable length data (2011-11-23 22:23:15 -0200)

are available in the git repository at:
  . staging/for_v3.3

Dan Carpenter (1):
      [media] V4L: mt9t112: use after free in mt9t112_probe()

 drivers/media/video/mt9t112.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

It basically seeks for "The following...at: <url> <branch>" part of the message. If found,
it will add it at its repository, like:

	http://patchwork.linuxtv.org/patch/8279/

> It was meant for 3.2 and was sent in advance.
> 
> Do you think you will get it in?

We can get the fixes, and new board additions for 3.2, but driver updates should
go to 3.3.

> 
> regards,
> -- 
> 
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com/


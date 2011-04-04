Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36507 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845Ab1DDNMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 09:12:03 -0400
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Andy Walls <awalls@md.metrocast.net>
To: Eric B Munson <emunson@mgebm.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org
In-Reply-To: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 09:12:17 -0400
Message-ID: <1301922737.5317.7.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-04-04 at 08:20 -0400, Eric B Munson wrote:
> I the above mentioned capture card and the digital side of the card
> works well.  However, when I try to get video from the analog side of
> the card, all I get is a red screen and no sound regardless of channel
> requested.  This is a problem I see in 2.6.39-rc1 though I typically
> run the ubuntu 10.10 kernel with the newest drivers built from source.
>  Is there something in setup or configuration that I may be missing?

Eric,

You are likely missing the last 3 fixes here:

http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18_39

(one of which is critical for analog to work).

Also check the ivtv-users and ivtv-devel list for past discussions on
the "red screen" showing up for known well supported models and what to
try.


Mauro,

Did these changes for HVR-1600 analog make it into .39 ?  

Here was my pull request from about a week ago:

http://www.spinics.net/lists/linux-media/msg30721.html


Regards,
Andy



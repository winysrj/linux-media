Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56925
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbcJUQ4L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 12:56:11 -0400
Date: Fri, 21 Oct 2016 14:55:59 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
        Stefan =?UTF-8?B?UMO2c2NoZWw=?= <basic.master@gmx.de>
Subject: Re: [GIT PULL STABLE 4.6] af9035 regression
Message-ID: <20161021145559.23b80d7b@vento.lan>
In-Reply-To: <943812ea-cec5-46a1-8652-a468ebb2cb42@iki.fi>
References: <1e077824-104b-4665-96c8-de46c1a63a5d@iki.fi>
        <20160909114906.66c77b1b@vento.lan>
        <943812ea-cec5-46a1-8652-a468ebb2cb42@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 9 Sep 2016 18:04:07 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 09/09/2016 05:49 PM, Mauro Carvalho Chehab wrote:
> > Hi Antti,
> >
> > Em Sat, 3 Sep 2016 02:40:52 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:
> >  
> >> The following changes since commit 2dcd0af568b0cf583645c8a317dd12e344b1c72a:
> >>
> >>    Linux 4.6 (2016-05-15 15:43:13 -0700)  
> >
> > Is this patchset really meant to Kernel 4.6? if so, you should send
> > the path to stable@vger.kernel.org, c/c the mailing list.
> >
> > It helps to point the original patch that fixed the issue upstream,
> > as they won't apply the fix if it was not fixed upstream yet.  
> 
> I think you already applied upstream patch, that one is just back-ported 
> to 4.6.

Ah!

> It is that patch:
> https://patchwork.linuxtv.org/patch/36795/
> 
> and it contains all the needed tags including Cc stable. Could you send 
> it to stable?

Just send the patch directly to stable@vger.kernel.org. if you
C/C me, I'll add my acked-by.

> 
> Antti
> 
> >
> > Regards,
> > Mauro
> >  
> >>
> >> are available in the git repository at:
> >>
> >>    git://linuxtv.org/anttip/media_tree.git af9035_fix
> >>
> >> for you to fetch changes up to 7bb87ff5255defe87916f32cd1fcef163a489339:
> >>
> >>    af9035: fix dual tuner detection with PCTV 79e (2016-09-03 02:23:44
> >> +0300)
> >>
> >> ----------------------------------------------------------------
> >> Stefan Pöschel (1):
> >>        af9035: fix dual tuner detection with PCTV 79e
> >>
> >>   drivers/media/usb/dvb-usb-v2/af9035.c | 53
> >> +++++++++++++++++++++++++++++++++++------------------
> >>   drivers/media/usb/dvb-usb-v2/af9035.h |  2 +-
> >>   2 files changed, 36 insertions(+), 19 deletions(-)
> >>  
> >
> >
> >
> > Thanks,
> > Mauro
> >  
> 



Thanks,
Mauro

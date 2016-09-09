Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53127
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbcIIOtV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 10:49:21 -0400
Date: Fri, 9 Sep 2016 11:49:06 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
        Stefan =?UTF-8?B?UMO2c2NoZWw=?= <basic.master@gmx.de>
Subject: Re: [GIT PULL STABLE 4.6] af9035 regression
Message-ID: <20160909114906.66c77b1b@vento.lan>
In-Reply-To: <1e077824-104b-4665-96c8-de46c1a63a5d@iki.fi>
References: <1e077824-104b-4665-96c8-de46c1a63a5d@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Em Sat, 3 Sep 2016 02:40:52 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> The following changes since commit 2dcd0af568b0cf583645c8a317dd12e344b1c72a:
> 
>    Linux 4.6 (2016-05-15 15:43:13 -0700)

Is this patchset really meant to Kernel 4.6? if so, you should send
the path to stable@vger.kernel.org, c/c the mailing list.

It helps to point the original patch that fixed the issue upstream,
as they won't apply the fix if it was not fixed upstream yet.

Regards,
Mauro

> 
> are available in the git repository at:
> 
>    git://linuxtv.org/anttip/media_tree.git af9035_fix
> 
> for you to fetch changes up to 7bb87ff5255defe87916f32cd1fcef163a489339:
> 
>    af9035: fix dual tuner detection with PCTV 79e (2016-09-03 02:23:44 
> +0300)
> 
> ----------------------------------------------------------------
> Stefan Pöschel (1):
>        af9035: fix dual tuner detection with PCTV 79e
> 
>   drivers/media/usb/dvb-usb-v2/af9035.c | 53 
> +++++++++++++++++++++++++++++++++++------------------
>   drivers/media/usb/dvb-usb-v2/af9035.h |  2 +-
>   2 files changed, 36 insertions(+), 19 deletions(-)
> 



Thanks,
Mauro

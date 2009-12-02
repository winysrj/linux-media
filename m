Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60365 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754755AbZLBAM5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 19:12:57 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 1/3] radio-si470x: fix SYSCONFIG1 register set on si470x_start()
Date: Wed, 2 Dec 2009 01:12:59 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com
References: <4B039265.1020906@samsung.com> <200912020039.02737.tobias.lorenz@gmx.net> <4B15ACA7.6070807@samsung.com>
In-Reply-To: <4B15ACA7.6070807@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912020112.59668.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

ok, understood this problem.
So, why not set this in si470x_fops_open directly after the si470x_start?
It seems more appropriate to enable the RDS interrupt after starting the radio.

Bye the way, you pointed me to a bug. Instead of always setting de-emphasis in si470x_start:
radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
This should only be done, if requested by module parameter:
radio->registers[SYSCONFIG1] = (de << 11) & SYSCONFIG1_DE; /* DE */

Bye,
Toby

Am Mittwoch 02 Dezember 2009 00:54:15 schrieb Joonyoung Shim:
> Hi, Tobias.
> 
> On 12/2/2009 8:39 AM, Tobias Lorenz wrote:
> > Hi,
> > 
> > what is the advantage in not setting SYSCONFIG1 into a known state?
> > 
> 
> At patch 3/3, i am setting the SYSCONFIG1 register for RDS interrupt in
> i2c probe function, so i need this patch. Do you have other idea?
> 
> > Bye,
> > Toby
> > 
> > Am Mittwoch 18 November 2009 07:21:25 schrieb Joonyoung Shim:
> >> We should use the or operation to set value to the SYSCONFIG1 register
> >> on si470x_start().
> >>
> >> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> >> ---
> >>  drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
> >> index f33315f..09f631a 100644
> >> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> >> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> >> @@ -357,7 +357,7 @@ int si470x_start(struct si470x_device *radio)
> >>  		goto done;
> >>  
> >>  	/* sysconfig 1 */
> >> -	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
> >> +	radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
> >>  	retval = si470x_set_register(radio, SYSCONFIG1);
> >>  	if (retval < 0)
> >>  		goto done;
> >>
> > 
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab3CVKYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 06:24:07 -0400
Date: Fri, 22 Mar 2013 06:30:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 11/41] af9035: basic support for IT9135 v2 chips
Message-ID: <20130322063004.43e66b05@redhat.com>
In-Reply-To: <514B9B9A.7010502@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
	<1362881013-5271-11-git-send-email-crope@iki.fi>
	<20130321185422.4c2c9696@redhat.com>
	<514B9B9A.7010502@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Mar 2013 01:45:30 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 03/21/2013 11:54 PM, Mauro Carvalho Chehab wrote:
> > Em Sun, 10 Mar 2013 04:03:03 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >>   static struct ite_config af9035_it913x_config = {
> >> -	.chip_ver = 0x01,
> >> +	.chip_ver = 0x02,
> 
> >> @@ -1153,6 +1161,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
> >>   	case AF9033_TUNER_IT9135_38:
> >>   	case AF9033_TUNER_IT9135_51:
> >>   	case AF9033_TUNER_IT9135_52:
> >> +		af9035_it913x_config.chip_ver = 0x01;
> >
> > Hmmm... aren't you missing a break here? If not, please add a comment, as
> > otherwise reviewers think that this is a bug.
> 
> It is correct as it was set 0x02 by init. And variable was removed 
> totally few patches later.

Ok, so please send a patch latter adding a notice about that, like:
  	case AF9033_TUNER_IT9135_52:
		af9035_it913x_config.chip_ver = 0x01;
		/* fall trough */
	case ...

This is a very common practice at the Kernel, as it helps to better
document it.

Also I'm pretty sure some janitor would otherwise send us sooner or later a
patch adding a break there.

Regards,
Mauro

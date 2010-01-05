Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([203.16.214.141]:24716 "EHLO
	ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab0AEBZ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 20:25:27 -0500
Message-ID: <4B4294FE.8000309@internode.on.net>
Date: Tue, 05 Jan 2010 12:25:18 +1100
From: Raena Lea-Shannon <raen@internode.on.net>
MIME-Version: 1.0
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
CC: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu>
In-Reply-To: <4B421BCB.6050909@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



istvan_v@mailbox.hu wrote:
> On 01/03/2010 09:21 AM, Raena Lea-Shannon wrote:
> 
>> That seems odd. This patch on the LinuxTv site
>> http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026379.html
>> seems to be using the cx88 drivers?
> 
> Unfortunately, this patch is for the older DTV 2000H (not Plus)
> card, which uses a Philips FMD1216 tuner. The main change on the
> "Plus" card is the replacement of the tuner with the XC4000, and
> that is why it is not supported yet. However, an XC4000 driver
> is already under development, and - compiling V4L from source -
> you could get the card working in the near future. In fact, code
> that implements support for this card already exists, but it is
> only for development/testing at the moment.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Thanks. Will try again later.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32777 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2COSHm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 14:07:42 -0400
Received: by eekc41 with SMTP id c41so1818682eek.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 11:07:40 -0700 (PDT)
Message-ID: <4F622FEA.7000903@gmail.com>
Date: Thu, 15 Mar 2012 19:07:38 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: [PATCH 0/3] cxd2820r: tweak search algorithm, enable LNA in DVB-T
 mode
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com> <4F6229D4.8010302@redhat.com>
In-Reply-To: <4F6229D4.8010302@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 15/03/2012 18:41, Mauro Carvalho Chehab ha scritto:

> 
> Hi Gianluca,
> 
> With regards to LNA, the better is to add a DVBv5 property for it.
> 
> The LNA is generally located at the antenna, and not at the device.
> 
> As you know, more than one device may be connected to the same antenna, 
> and it is generally not a good idea to have two devices sending power to
> the LNA.
> 
> So, it is better to have a way to turn it on via the usespace API.
> 
> Also, as this consumes power, the better is to do it only when the device
> is actually used.
> 
> Regards,
> Mauro

Hi Mauro, I believe this "LNA" is just an internal amplifier that is
embedded in the cxd2820r demodulator itself.
I have a "condo" antenna so there is no way I can control the power from
my apartment as everything is centralized.

Many DTT receivers have a "5v power" option to drive the antenna
amplifiers on the roof. But almost every antenna (at least here in
Italy) has a dedicated power supply, in order to make things simpler for
the user.
Anyway, a DVBv5 property to control this "power switch" is a good idea.

Regards,
Gianluca

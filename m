Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61385 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1H1Szc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 14:55:32 -0400
Received: by gwaa12 with SMTP id a12so4252902gwa.19
        for <linux-media@vger.kernel.org>; Sun, 28 Aug 2011 11:55:31 -0700 (PDT)
Date: Sun, 28 Aug 2011 13:55:24 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DiBxxxx: fixes for 3.1/3.0
Message-ID: <20110828185524.GA8369@elie.gateway.2wire.net>
References: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>
 <alpine.LRH.2.00.1108051043480.19389@pub5.ifh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1108051043480.19389@pub5.ifh.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Patrick Boettcher wrote:
> On Wed, 3 Aug 2011, Patrick Boettcher wrote:

>> [media] dib0700: protect the dib0700 buffer access
>> [media] DiBcom: protect the I2C bufer access
>
> I added a patch from Olivier which fixes wrongly used dprintks and replaces
> them by err()-calls.
>
> [media] dib0700: correct error message

Just for the record[1]:

Tested-by: Eric Valette <eric.valette@free.fr>

Thanks!

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=639161#22

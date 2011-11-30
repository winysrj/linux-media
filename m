Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:54780 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1K3Tjw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 14:39:52 -0500
Received: from moweb001.kundenserver.de (moweb001.kundenserver.de [172.19.20.114])
	by fmmailgate05.web.de (Postfix) with ESMTP id 7E0B967AD382
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 20:39:51 +0100 (CET)
From: Jens Erdmann <Jens.Erdmann@web.de>
To: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: Add Terratec Cinergy HTC Stick
Date: Wed, 30 Nov 2011 20:39:48 +0100
References: <11607963.5467764.1322494881126.JavaMail.fmail@mwmweb051> <0MQf77-1RNtkl3pe9-00U2UK@smtp.web.de> <4ED4D683.40508@linuxtv.org>
In-Reply-To: <4ED4D683.40508@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111302039.48970.Jens.Erdmann@web.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Andreas,

On Tuesday, November 29, 2011 01:56:35 PM you wrote:
<snip>
> 
> >>> 2. I stumbled over http://linux.terratec.de/tv_en.html where they list
> >>> a NXP TDA18271
> >>> 
> >>>     as used tuner for H5 and HTC Stick devices. I dont have any
> >>>     experience in this kind of stuff but i am just asking.
> >> 
> >> That's right.
> > 
> > So this should be made like the other devices which are using the
> > TDA18271? Or is there no driver for this tuner yet?
> 
> I don't understand your question. Both TERRATEC H5 and Cinergy HTC Stick
> are already supported by Linux (at least for digital signals, the latter
> since the patch you're referring to), so a driver for every relevant
> chip, including TDA18271, is already involved.
> 

If i remember correctly there was used another tuner driver in the out 
commended code. Is this just a coyp paste leftover?

Regards, 
  Jens

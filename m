Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61600 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab2ARNyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 08:54:39 -0500
Received: by wgbdq11 with SMTP id dq11so3204378wgb.1
        for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 05:54:38 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] DVB: dib0700, add support for Nova-TD LEDs
Date: Wed, 18 Jan 2012 14:54:34 +0100
Cc: linux-media@vger.kernel.org
References: <E1RnU5E-0000Vf-T9@www.linuxtv.org> <4F16C6B8.8000402@linuxtv.org>
In-Reply-To: <4F16C6B8.8000402@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201181454.34245.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 January 2012 14:18:48 Michael Krufky wrote:
> Mauro,
> 
> Why was my sign-off changed to an Ack?
> 
> As you can see, I worked *with* Jiri to help him create this
> patchset.
> 
> During review, I noticed a poorly named function, which I renamed
> before pusging it into my own tree.  Patrick saw this, and merged my
> changes into into his tree.
> 
> Why did I go through this effort to help another developer add value
> to one of our drivers, and additional effort to make a small
> cleanup, push the changes into my own tree and issue a pull request?
>  I was thanked by Patrick.  Everybody's signature is on the patch,
> but you then go and remove my signature, and add a forged "ack"?  I
> don't understand this, Mauro.

I think it is my fault.

I haven't merged your tree but I merged Jiri's patches as is. (git am)  
I completely oversaw your pull request and issued mine. 

Mauro in IRC told me that you issued a PULL request as well. Not being 
aware that you have made any modifications Mauro suggest to pull from me 
and add an Ack-By to the patches.

So he did not remove anything but trusted me too much.

--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/

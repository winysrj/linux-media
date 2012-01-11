Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48870 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339Ab2AKTTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 14:19:38 -0500
Received: by wibhm14 with SMTP id hm14so644181wib.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 11:19:37 -0800 (PST)
Message-ID: <4F0DE0C2.5050907@gmail.com>
Date: Wed, 11 Jan 2012 19:19:30 +0000
From: Jim Darby <uberscubajim@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
References: <4F0C3D1B.2010904@gmail.com> <4F0CE040.7020904@iki.fi>
In-Reply-To: <4F0CE040.7020904@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/01/12 01:05, Antti Palosaari wrote:
> [snip]
> Also latest LinuxTV.org devel could be interesting to see. There is 
> one patch that changes em28xx driver endpoint configuration. But as 
> that patch is going for 3.3 it should not be cause of issue, but I 
> wonder if it could fix... Use media_build.git if possible.

Well, I built the kernel and installed it. Sadly I get entries of the 
form: "dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 
call to delivery system 0" which isn't what I was looking for. I guess 
there's a new API? It would appear this is from the set frontend call.

This is most annoying as I'd like to try out the newest code.

Is there a v3 to v3 transition document anywhere?

Best regards,

Jim.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:17164 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835Ab0GPVsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 17:48:25 -0400
Subject: Re: How to begin v4l2 application development??
From: Andy Walls <awalls@md.metrocast.net>
To: Bryan Nations <bnations@streamvenue.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1279316889.2446.6.camel@localhost>
References: <4C40B598.20705@streamvenue.com>
	 <1279316889.2446.6.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 17:49:02 -0400
Message-ID: <1279316942.2446.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-16 at 17:48 -0400, Andy Walls wrote:
> On Fri, 2010-07-16 at 14:40 -0500, Bryan Nations wrote:
> > I am new to video for linux and would like to know what resources are 
> > available to assist me in programming a simple webcam application with 
> > c++ in a *nix environment. My main goal right now is to just view the 
> > webcam in a small window. I have found lots of info on driver 
> > development, but I am interested in the application side. Are there any 
> > c++ examples or references that will help me get started?
> 
> Read the V4L2 API documentation.  Everything an app programmer can call
> is there.

Oops, forgot the link:

http://linuxtv.org/downloads/v4l-dvb-apis/

> I susggest playing around with the v4l2-ctl utility with your device to
> get a feel for what many of the miscellaneous ioctl()'s support.
> 
> You may want to look at svv.c here:
> 
> 	http://moinejf.free.fr/
> 
> as a simple test viewer application.
> 
> Regards,
> Andy
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



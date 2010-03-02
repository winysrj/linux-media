Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0CBTIl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Mar 2010 14:08:41 -0500
Message-ID: <4B8D6231.1020806@redhat.com>
Date: Tue, 02 Mar 2010 16:08:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: git over http from linuxtv
References: <4B82F7ED.6020502@redhat.com> <1267550594.27183.22.camel@masi.mnp.nokia.com>
In-Reply-To: <1267550594.27183.22.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m7aalton wrote:
> Hi.
> 
> Is it possible to access the linuxtv.org git repositories using http?
> I tried to do this:
> 
> git remote add linuxtv git://linuxtv.org/v4l-dvb.git

You should be able to use both URL's:

URL	http://git.linuxtv.org/v4l-dvb.git
	git://linuxtv.org/v4l-dvb.git

There were a miss-configuration for the http URL. I just fixed it.

> 
> using http, but I couldn't figure out a working address. 
> 
> Thank you,
> Matti Aaltonen
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro

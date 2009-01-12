Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11a.verio-web.com ([204.202.242.23]:37843 "HELO
	mail11a.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752722AbZALRFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 12:05:51 -0500
Received: from mx70.stngva01.us.mxservers.net (204.202.242.141)
	by mail11a.verio-web.com (RS ver 1.0.95vs) with SMTP id 2-0611529947
	for <linux-media@vger.kernel.org>; Mon, 12 Jan 2009 12:05:49 -0500 (EST)
Message-ID: <496B785F.3000505@sensoray.com>
Date: Mon, 12 Jan 2009 09:05:35 -0800
From: Dean Anderson <dean@sensoray.com>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@isely.net>,
	Thierry MERLE <thierry.merle@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Fw: [PATCH] v4l/dvb: remove err macro from few usb devices
References: <20090108101342.58f7ce5e@pedra.chehab.org> <1231547630.4474.202.camel@tux.localhost>
In-Reply-To: <1231547630.4474.202.camel@tux.localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alexey Klimov wrote:
> Hello, all
>   
> Dean, so you think that we don't need s2255 name in the beginning of
> message and we doesn't need s2255_dev_err macros, right ?
>
> As i remember pr_err is just printk with KERN_ERR..
>
>   
Not at all.  We must have s2255 in the beginning of the message.  I 
wasn't sure only about pr_err, but it looks ok now. 

The s2255_dev_err macros are a good idea.

Thanks,

Dean





Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35404 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcFRQZU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 12:25:20 -0400
Date: Sat, 18 Jun 2016 09:25:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hansverk@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv16 08/13] DocBook/media: add CEC documentation
Message-ID: <20160618162515.GB12210@dtor-ws>
References: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
 <1461937948-22936-9-git-send-email-hverkuil@xs4all.nl>
 <20160616180958.03b9d759@recife.lan>
 <5763ADBD.3050502@xs4all.nl>
 <20160617065028.7410ae46@recife.lan>
 <5763DA56.20402@xs4all.nl>
 <20160617083738.491c01ae@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160617083738.491c01ae@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 17, 2016 at 08:37:38AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 17 Jun 2016 13:09:10 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 06/17/2016 11:50 AM, Mauro Carvalho Chehab wrote:
> > One area where I am uncertain is when remote control messages are received and
> > passed on by the framework to the RC input device.
> > 
> > Suppose the application is the one receiving a password, then that password appears
> > both in the input device and the cec device. What I think will be useful is if the
> > application can prevent the use of an input device to pass on remote control messages.
> > 
> > CEC_ADAP_S_LOG_ADDRS has a flags field that I intended for just that purpose.
> > 
> > Note that RC messages are always passed on to CEC followers even if there is an
> > input device since some RC messages have additional arguments that the rc subsystem
> > can't handle. Also I think that it is often easier to handle all messages from the
> > same CEC device instead of having to read from two devices (cec and input). I
> > actually considered removing the input support, but it turned out to be useful in
> > existing video streaming apps since they don't need to add special cec support to
> > handle remote control presses.
> > 
> > Question: is there a way for applications to get exclusive access to an input device?
> > Or can anyone always read from it?
> 
> That's a very good question. I did a quick test to check how this is
> currently protected, by running:
> 
> $ strace ir-keytable -t
> ...
> open("/dev/input/event12", O_RDONLY)    = -1 EACCES (Permission denied)
> ...
> 
> It turns that the input device was created by udev with those
> permissions:
> 
> crw-rw---- 1 root input 13, 76 Jun 17 08:26 /dev/input/event12
> 
> Changing access to 666 allowed to run ir-keytable -t without the
> need of being root.
> 
> Yet, maybe there's a way to get exclusive access to input/event
> device, but I never needed to go that deep at the input subsystem.
> Maybe Dmitry could shed some light on that. Adding him in the loop.

EVIOCGRAB ioctl will do what you want.

Thanks.

-- 
Dmitry

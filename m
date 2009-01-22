Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:15987 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZAVD75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 22:59:57 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2009583fgg.17
        for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 19:59:55 -0800 (PST)
Subject: Re: usb_make_path()
From: Alexey Klimov <klimov.linux@gmail.com>
To: Thierry Merle <thierry.merle@free.fr>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <49778924.7030100@free.fr>
References: <20090121114308.048c0a19@gmail.com>  <49778924.7030100@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jan 2009 07:00:08 +0300
Message-Id: <1232596808.3764.121.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added linux-media mail-list)

Hello to all

On Wed, 2009-01-21 at 21:44 +0100, Thierry Merle wrote:
> Hi Douglas,
> Douglas Schilling Landgraf a écrit :
> > Hello friends,
> > 
> >      Since you sent patches to linux-media for usb_make_path changes, I
> > would like to make a question for you. Should we check for
> > return of usb_make_path as a good programming practice?
> > 
> > static inline int usb_make_path(struct usb_device *dev, char *buf,
> > size_t size)
> > 
> > I didn't see this check in your patches.
> > 
> I saw that the return code was checked in some other v4l sources, but I preferred to ignore the return value like done in many other drivers (see http://lxr.falinux.com/ident?i=usb_make_path)
> I know it is bad but for failing this function fails if the buffer is to small to copy the complete usb path.
> Nevertheless it uses snprintf that truncates safely the string if needed.
> What to do if this function fails? I did not see anything better, so ignoring the return code seemed to be the best.

usb_make_path returns -1 if sizeof buffer is smaler than path (no device
or hardware troubles). Bus_info is 32 byte and usb path looks like:
"usb-%s-%s", dev->bus->bus_name, dev->devpath (from usb.h). I failed
trying to find size of bus_name, but maximum size of dev->devpath is 16
chars.

So, i'm confused about two things:
- as this information goes to userspace, will userpace feel bad that
trucated string will be delivered? And do v4l-subsystem care enough to
provide complete usb-path?
- will it happened one day that usb_make_path returns -1 and we care?

I don't have ideas about first thing.
In case we care to provide full usb-path - may be check for returned
value should be placed, print message and ask user, for example:
"usb_make_path error! Please send message to linux-media maillist".
In case of many reports size of bus_info[32] can be increased.

By other side, if this all is really important? It's right that ignoring
returned value is safe.


-- 
Best regards, Klimov Alexey


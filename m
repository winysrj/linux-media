Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43026 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbaKAOJF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Nov 2014 10:09:05 -0400
Date: Sat, 1 Nov 2014 12:08:58 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH 3/7] [media] cx231xx: Cleanup printk at the driver
Message-ID: <20141101120858.47dc0bd7@recife.lan>
In-Reply-To: <5454E7A8.40707@iki.fi>
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
	<c347502e632c69c80dcf5d4df1396cb59973af2f.1414849031.git.mchehab@osg.samsung.com>
	<5454E7A8.40707@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 01 Nov 2014 16:01:12 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 11/01/2014 03:38 PM, Mauro Carvalho Chehab wrote:
> > There are lots of debug printks printed with pr_info. Also, the
> > printk's data are not too coherent:
> >
> > - there are duplicated driver name at the print format;
> > - function name format string differs from function to function;
> > - long strings broken into multiple lines;
> > - some printks just produce ugly reports, being almost useless
> >    as-is.
> >
> > Do a cleanup on that.
> >
> > Still, there are much to be done in order to do a better printk
> > job on this driver, but, at least it will now be a way less
> > verbose, if debug printks are disabled, and some logs might
> > actually be useful.
> 
> As you do that kind of cleanup, why don't just use a bit more time and 
> do it properly using dev_foo() logging. Basically all device drivers 
> should use dev_foo() logging, it prints module name, bus number etc. 
> automatically in a standard manner. pr_foo() is worse, which should be 
> only used for cases where pointer to device is not available (like library).

Please notice that my only goal with this series is to be able to
check if analog/digital is still working after Mattias's i2c mux
patchsets. I don't have much time right now for a more complete
cleanup.

Several of the printks are done before creating the cx231xx device
struct. See the places where cx231xx_errdev() were called before
patch 1/7.

The cx231xx probing is complex. Not sure if it is possible
to convert everything to dev_foo() and mixing pr_foo with dev_foo()
seems to be worse.

I may revisit it some other time and try to evaluate the impact of
doing such change when I have more spare time.

Regards,
Mauro

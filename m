Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54441 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbaKAOBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Nov 2014 10:01:38 -0400
Message-ID: <5454E7A8.40707@iki.fi>
Date: Sat, 01 Nov 2014 16:01:12 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Takashi Iwai <tiwai@suse.de>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH 3/7] [media] cx231xx: Cleanup printk at the driver
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com> <c347502e632c69c80dcf5d4df1396cb59973af2f.1414849031.git.mchehab@osg.samsung.com>
In-Reply-To: <c347502e632c69c80dcf5d4df1396cb59973af2f.1414849031.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/01/2014 03:38 PM, Mauro Carvalho Chehab wrote:
> There are lots of debug printks printed with pr_info. Also, the
> printk's data are not too coherent:
>
> - there are duplicated driver name at the print format;
> - function name format string differs from function to function;
> - long strings broken into multiple lines;
> - some printks just produce ugly reports, being almost useless
>    as-is.
>
> Do a cleanup on that.
>
> Still, there are much to be done in order to do a better printk
> job on this driver, but, at least it will now be a way less
> verbose, if debug printks are disabled, and some logs might
> actually be useful.

As you do that kind of cleanup, why don't just use a bit more time and 
do it properly using dev_foo() logging. Basically all device drivers 
should use dev_foo() logging, it prints module name, bus number etc. 
automatically in a standard manner. pr_foo() is worse, which should be 
only used for cases where pointer to device is not available (like library).

regards
Antti

-- 
http://palosaari.fi/

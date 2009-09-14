Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:31732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbZINVuu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 17:50:50 -0400
Message-ID: <4AAEBABA.9060108@gmail.com>
Date: Mon, 14 Sep 2009 23:50:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: V4L2 drivers: potentially dangerous and inefficient msecs_to_jiffies()
 calculation
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de> <4AAEB6F0.4080706@gmail.com> <20090914213933.GA5468@rhlx01.hs-esslingen.de>
In-Reply-To: <20090914213933.GA5468@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2009 11:39 PM, Andreas Mohr wrote:
> On Mon, Sep 14, 2009 at 11:34:40PM +0200, Jiri Slaby wrote:
>> On 09/14/2009 11:07 PM, Andreas Mohr wrote:
>>> msecs_to_jiffies(1) is quite a bit too boldly assuming
>>> that all of the msecs_to_jiffies(x) implementation branches
>>> always round up.
>>
>> They do, don't they?
> 
> I'd hope so, but a slight risk remains, you never know,
> especially with 4+ or so variants...

A potential problem here is rather that it may wait longer due to
returning 1 jiffie. It's then timeout * 1000 * 1. On 250HZ system it
makes a difference of multiple of 4. Don't think it's a real issue in
those drivers at all, but it's worth fixing. Care to post a patch?

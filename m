Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0BCO2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 09:28:25 -0500
Message-ID: <4B698803.7010805@infradead.org>
Date: Wed, 03 Feb 2010 12:28:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: Julia Lawall <julia@diku.dk>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/media/video/hdpvr: introduce missing kfree
References: <Pine.LNX.4.64.0909111821180.10552@pc-004.diku.dk> <20090916111325.GA14900@aniel.lan> <4B684273.6040500@infradead.org> <20100203141210.GD7946@aniel.lan>
In-Reply-To: <20100203141210.GD7946@aniel.lan>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Janne Grunau wrote:
> Hej, 
> 
> On Tue, Feb 02, 2010 at 01:19:15PM -0200, Mauro Carvalho Chehab wrote:
>> Janne Grunau wrote:
>>> On Fri, Sep 11, 2009 at 06:21:35PM +0200, Julia Lawall wrote:
>>>> Error handling code following a kzalloc should free the allocated data.
>>> Thanks for the report. I'll commit a different patch which adds the buffer
>>> to the buffer list as soon it is allocated. The hdpvr_free_buffers() in the
>>> error handling code will clean it up then. See below:
>> Any news about this subject? The current upstream code still misses the change bellow
> 
> it was fixed differently in cd0e280f

Thanks! I'm removing it from my queue :)

Now, the only hdpvr patch is this one:

hdpvr-video: cleanup signedness                                         http://patchwork.kernel.org/patch/74902


Cheers,
Mauro

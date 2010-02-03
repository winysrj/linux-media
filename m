Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:34893 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab0BCOUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 09:20:04 -0500
Date: Wed, 3 Feb 2010 15:12:10 +0100
From: Janne Grunau <j@jannau.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Julia Lawall <julia@diku.dk>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/media/video/hdpvr: introduce missing kfree
Message-ID: <20100203141210.GD7946@aniel.lan>
References: <Pine.LNX.4.64.0909111821180.10552@pc-004.diku.dk>
 <20090916111325.GA14900@aniel.lan>
 <4B684273.6040500@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B684273.6040500@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hej, 

On Tue, Feb 02, 2010 at 01:19:15PM -0200, Mauro Carvalho Chehab wrote:
> 
> Janne Grunau wrote:
> > On Fri, Sep 11, 2009 at 06:21:35PM +0200, Julia Lawall wrote:
> >> Error handling code following a kzalloc should free the allocated data.
> > 
> > Thanks for the report. I'll commit a different patch which adds the buffer
> > to the buffer list as soon it is allocated. The hdpvr_free_buffers() in the
> > error handling code will clean it up then. See below:
> 
> Any news about this subject? The current upstream code still misses the change bellow

it was fixed differently in cd0e280f

kind regards,
Janne

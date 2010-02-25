Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:16772 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab0BYQxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 11:53:40 -0500
Date: Thu, 25 Feb 2010 08:52:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Subject: Re: linux-next: Tree for February 22 (media/video/tvp7002)
Message-Id: <20100225085205.9cf68ce9.randy.dunlap@oracle.com>
In-Reply-To: <4B82AF18.3030107@oracle.com>
References: <20100222172218.4fd82a45.sfr@canb.auug.org.au>
	<4B82AF18.3030107@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Feb 2010 08:21:44 -0800 Randy Dunlap wrote:

> On 02/21/10 22:22, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20100219:
> 
> 
> drivers/media/video/tvp7002.c:896: error: 'struct tvp7002' has no member named 'registers'

same problem in linux-next-20100225.

so where are these registers??

thanks,
---
~Randy

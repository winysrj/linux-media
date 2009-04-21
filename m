Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59249 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZDURJX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 13:09:23 -0400
Date: Tue, 21 Apr 2009 14:08:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: subrata@linux.vnet.ibm.com
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	srinivasa.deevi@conexant.com, linux-media@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	sachinp <sachinp@linux.vnet.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [BUILD FAILURE 04/04] Next April 21 : x86_64 randconfig
 [drivers/built-in.o]
Message-ID: <20090421140847.509f8c59@pedra.chehab.org>
In-Reply-To: <1240332728.9110.40.camel@subratamodak.linux.ibm.com>
References: <1240332728.9110.40.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Tue, 21 Apr 2009 22:22:08 +0530
Subrata Modak <subrata@linux.vnet.ibm.com> wrote:

> Observed the following build error. Reported this on 8th and 14th April
> Next build errors:
> 
> http://lkml.org/lkml/2009/4/14/473,
> 
> Patch was already provided by Randy on 7th April. This is still to hit
> the tree:
> http://lkml.org/lkml/2009/4/7/400,
> 

Probably Stephen picked from my tree before I merge this patch on my linux-next tree:

http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=c4f0ad35d1df1fed5fae477f806aa8daf5545520

This error should disappear on the today's build.

-- 

Cheers,
Mauro

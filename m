Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZCNLrd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 07:47:33 -0400
Date: Sat, 14 Mar 2009 08:47:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	DongSoo Kim <dongsoo.kim@gmail.com>,
	"ext Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	=?ISO-8859-1?B?S29za2lw5OQ=?= Antti Jussi Petteri
	<antti.koskipaa@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: OMAP3 ISP and camera drivers (update)
Message-ID: <20090314084702.4f556c7c@pedra.chehab.org>
In-Reply-To: <49B141F6.6040301@maxwell.research.nokia.com>
References: <49B141F6.6040301@maxwell.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari and other OMAP developers,

In order to better organize the OMAP stuff, I've created an account for Sakari
at linuxtv.org.

It is simply too much for me to review all those stuff again and again. So I
want to concentrate the process with Sakari, letting him do the review of OMAP
patches and coordinating the OMAP merge process. 

I expect that Sakari will send me periodic pull requests, after finishing the
discussions, for me to do a final review and merge upstream.

In order to reduce my pending list at patchwork, I'm marking all OMAP there
patches as RFC, trusting that Sakari will properly handle they.

Sakari, thanks for your help!

Cheers,
Mauro.

On Fri, 06 Mar 2009 17:32:06 +0200
Sakari Ailus <sakari.ailus@maxwell.research.nokia.com> wrote:

> Hi,
> 
> I've updated the patchset in Gitorious.
> 
> <URL:http://www.gitorious.org/projects/omap3camera>
> 
> Changes include
> 
> - Power management support. ISP suspend/resume should work now.
> 
> - Reindented and cleaned up everything. There are still some warnings 
> from checkpatch.pl from the CSI2 code.
> 
> - Fix for crash in device registration, posted to list already. (Thanks, 
> Vaibhav, Alexey!)
> 
> - LSC errors should be handled properly now.
> 
> I won't post the modified patches to the list this time since I guess it 
> wouldn't be much of use, I guess. Or does someone want that? :)
> 




Cheers,
Mauro

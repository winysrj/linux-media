Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56341 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1EBITb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 04:19:31 -0400
Date: Mon, 2 May 2011 03:19:25 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linuxtv <linuxtv@hubstar.net>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <error27@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, Andi Huber <hobrom@gmx.at>,
	Marlon de Boer <marlon@hyves.nl>,
	Damien Churchill <damoxc@gmail.com>
Subject: cx88 sound does not always work (Re: [PATCH v2.6.38 resend 0/7] cx88
 deadlock and data races)
Message-ID: <20110502081924.GC16077@elie>
References: <20110501091710.GA18263@elie>
 <4DBD4394.20907@hubstar.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBD4394.20907@hubstar.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

linuxtv wrote:

> FYI I too experienced the problem of hanging and used the patch dated
> 6th April to get it working.
> However I do have the problem that sound does not always work/come on.
> Once it is started it stays, getting it started is not reliable.

Could you give details?  What card do you use?  Does it show up in
lspci -vvnn output (and if so, could you show us)?  What kernel
version?  Could you attach your .config and dmesg?  Was this reported
on bugzilla before?  How does sound not working manifest itself?  How
do you go about getting it to work?

See the REPORTING-BUGS file for hints.

Thanks and hope that helps,
Jonathan

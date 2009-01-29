Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46209 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbZA2MWG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 07:22:06 -0500
Date: Thu, 29 Jan 2009 10:21:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Roel Kluin via Mercurial <roel.kluin@gmail.com>,
	akpm@linux-foundation.org
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] DVB: negative
 internal->sub_range won't get noticed
Message-ID: <20090129102149.473ff7dd@caramujo.chehab.org>
In-Reply-To: <49818912.7000109@gmail.com>
References: <E1LST8y-0003o5-Qw@www.linuxtv.org>
	<49818912.7000109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Thu, 29 Jan 2009 14:46:42 +0400
Manu Abraham <abraham.manu@gmail.com> wrote:

> Mauro,
> 
> Please revert this patch as it is incorrect. A correct version is
> available at http://jusst.de/hg/v4l-dvb which is undergoing tests.
> http://jusst.de/hg/v4l-dvb/rev/368dc6078295

Ok, I'll revert it. Please submit me later the pull request for the correct
patch.

> Why did you have to hastily apply this patch, especially when i
> mentioned this earlier ?

I haven't seen any comments about it on the Patchwork thread for this patch:
	http://patchwork.kernel.org/patch/3065/

-- 

Cheers,
Mauro

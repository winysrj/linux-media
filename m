Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45330 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbbBSTdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 14:33:14 -0500
Date: Thu, 19 Feb 2015 17:33:07 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Joe Perches <joe@perches.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Herrmann <dh.herrmann@gmail.com>,
	Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 4/7] [media] dvb core: rename the media controller
 entities
Message-ID: <20150219173307.36b043f3@recife.lan>
In-Reply-To: <54E4B1C2.20403@xs4all.nl>
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
	<56874b07885afd9d58dd3d3985d6167eb9a3deea.1424273378.git.mchehab@osg.samsung.com>
	<54E4B1C2.20403@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 18 Feb 2015 16:37:38 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> On 02/18/2015 04:29 PM, Mauro Carvalho Chehab wrote:
> > Prefix all DVB media controller entities with "dvb-" and use dash
> > instead of underline at the names.
> > 
> > Requested-by: Hans Verkuil <hverkuil@xs4all.nl>
> 			      ^^^^^^^^^^^^^^^^^^
> 
> For these foo-by lines please keep my hans.verkuil@cisco.com email.
> It's my way of thanking Cisco for allowing me to do this work. Not a
> big deal, but if you can change that before committing?
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>


Sure, I'll run a
git filter-branch -f --msg-filter 'cat |sed s,hverkuil@xs4all.nl,hans.verkuil@cisco.com,' origin..

To replace the e-mail on this series.

Next time, it would be better if you could reply using your @cisco
email on your From: if you want me to use it, as I generally just
cut-and-paste whatever e-mail used at the replies ;)

Regards,
Mauro

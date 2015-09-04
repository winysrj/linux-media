Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34347 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760133AbbIDWZF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 18:25:05 -0400
Date: Fri, 4 Sep 2015 19:24:56 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v8 54/55] [media] au0828: unregister MC at the end
Message-ID: <20150904192456.3f5e4d14@recife.lan>
In-Reply-To: <55E455D3.2000001@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<14e1926c1fdb883abc4d200913cd02371be694f4.1440902901.git.mchehab@osg.samsung.com>
	<55E455D3.2000001@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2015 15:25:39 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/30/2015 05:07 AM, Mauro Carvalho Chehab wrote:
> > au0828_analog_unregister() calls video_unregister_device(),
> > with, in turn, calls media_devnode_remove() in order to drop
> > the media interfaces.
> > 
> > We can't release the media controller before that, or an
> > OOPS will occur:
> 
> So this patch should be moved to a place earlier in the patch series,
> right? To prevent bisects that hit this bug.

Yes, it should be before the previous patch.

Regards,
Mauro

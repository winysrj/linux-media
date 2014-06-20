Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:19837 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220AbaFTW3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 18:29:52 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7H00A6QNTRXI40@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Jun 2014 18:29:51 -0400 (EDT)
Date: Fri, 20 Jun 2014 19:29:46 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Time for v4l-utils 1.2 release?
Message-id: <20140620192946.39765ec3.m.chehab@samsung.com>
In-reply-to: <53A4B097.3050802@xs4all.nl>
References: <53A49A11.2010502@googlemail.com> <53A4B097.3050802@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 21 Jun 2014 00:07:19 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/20/2014 10:31 PM, Gregor Jasny wrote:
> > Hello,
> > 
> > It's been 11 months since the 1.0.0 release. What do you think about
> > releasing HEAD? Do you have any pending commits?
> 
> I've got two patches from Laurent pending that ensure that the 'installed
> kernel headers' are used. I plan on processing those on Monday. After that
> I think it's OK to do a release.
> 
> Mauro, did you look at my email where I suggest to remove three apps from
> contrib? If you agree with that, then I can do that Monday as well.

Well, I don't remember about such email, nor I was able to find on a quick
look.

What apps are you planning to remove?

Btw, I think it could be a good idea to be able to install some of those
stuff under contrib to a separate package. I had to do a quick hack
in order to install v4l2grab on a Tizen package, in order to be able to
test a card there (as was needing to do some tests via CLI).

Regards,
Mauro

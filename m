Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:54359 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaIBUX5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 16:23:57 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBA00JBWJBW2HB0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 16:23:56 -0400 (EDT)
Date: Tue, 02 Sep 2014 17:23:51 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 1/2] tw68: add support for Techwell tw68xx PCI grabber
 boards
Message-id: <20140902172351.30367313.m.chehab@samsung.com>
In-reply-to: <54062070.3010300@xs4all.nl>
References: <1409034793-9465-1-git-send-email-hverkuil@xs4all.nl>
 <1409034793-9465-2-git-send-email-hverkuil@xs4all.nl>
 <20140902162119.0eb5b931.m.chehab@samsung.com> <54062070.3010300@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Sep 2014 21:54:24 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/02/2014 09:21 PM, Mauro Carvalho Chehab wrote:
> > Em Tue, 26 Aug 2014 08:33:12 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Add support for the tw68 driver. The driver has been out-of-tree for many
> >> years on gitorious: https://gitorious.org/tw68/tw68-v2
> >>
> >> I have refactored and ported that driver to the latest V4L2 core frameworks.
> >>
> >> Tested with my Techwell tw6805a and tw6816 grabber boards.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > I would be expecting here the  William M. Brack's SOB too.
> 
> Sorry, that's not possible. The only email I have no longer works. I googled
> to see if I could find another email without success. I met him years
> ago during an ELC and he was a retired engineer, so he may not even be
> around anymore. His gitorious.org repo has been inactive for over two years.
> 
> > 
> > Also, the best is to add his original work on one patch (without Kbuild
> > stuff) and your changes on a separate patch. That helps us to identify
> > what are your contributions to his code, and what was his original
> > copyright wording.
> 
> Are you sure you want that in the mainline kernel? His code is in gitorious,
> a link to that is in the commit log. I'm not too keen to add code to the
> kernel which is promptly being overwritten by another version. An alternative
> might be to add a link to that repo to tw68-core.c as well so that it is
> not just in the commit log but also in the source code.

There's no way to warrant that his gitorious repository will stay there
forever. We need to have the reference code somewhere, if something ever
complain about copyrights, especially since you're not able to contact
the author of the driver.

> 
> Regards,
> 
> 	Hans
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2377 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaIBTyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 15:54:43 -0400
Message-ID: <54062070.3010300@xs4all.nl>
Date: Tue, 02 Sep 2014 21:54:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 1/2] tw68: add support for Techwell tw68xx PCI grabber
 boards
References: <1409034793-9465-1-git-send-email-hverkuil@xs4all.nl> <1409034793-9465-2-git-send-email-hverkuil@xs4all.nl> <20140902162119.0eb5b931.m.chehab@samsung.com>
In-Reply-To: <20140902162119.0eb5b931.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/2014 09:21 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 26 Aug 2014 08:33:12 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add support for the tw68 driver. The driver has been out-of-tree for many
>> years on gitorious: https://gitorious.org/tw68/tw68-v2
>>
>> I have refactored and ported that driver to the latest V4L2 core frameworks.
>>
>> Tested with my Techwell tw6805a and tw6816 grabber boards.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I would be expecting here the  William M. Brack's SOB too.

Sorry, that's not possible. The only email I have no longer works. I googled
to see if I could find another email without success. I met him years
ago during an ELC and he was a retired engineer, so he may not even be
around anymore. His gitorious.org repo has been inactive for over two years.

> 
> Also, the best is to add his original work on one patch (without Kbuild
> stuff) and your changes on a separate patch. That helps us to identify
> what are your contributions to his code, and what was his original
> copyright wording.

Are you sure you want that in the mainline kernel? His code is in gitorious,
a link to that is in the commit log. I'm not too keen to add code to the
kernel which is promptly being overwritten by another version. An alternative
might be to add a link to that repo to tw68-core.c as well so that it is
not just in the commit log but also in the source code.

Regards,

	Hans


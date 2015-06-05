Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35691 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbbFEMBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 08:01:15 -0400
Date: Fri, 5 Jun 2015 14:01:10 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Jan Roemisch <maxx@spaceboyz.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] radio-bcm2048: Fix region selection
Message-ID: <20150605120110.GF7881@pali>
References: <1431725571-7417-1-git-send-email-pali.rohar@gmail.com>
 <557189C8.7040203@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <557189C8.7040203@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 05 June 2015 13:36:40 Hans Verkuil wrote:
> On 05/15/2015 11:32 PM, Pali Rohár wrote:
> > From: maxx <maxx@spaceboyz.net>
> > 
> > This actually fixes region selection for BCM2048 FM receiver. To select
> > the japanese FM-band an additional bit in FM_CTRL register needs to be
> > set. This might not sound so important but it enables at least me to
> > listen to some 'very interesting' radio transmission below normal
> > FM-band.
> > 
> > Patch writen by maxx@spaceboyz.net
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > Cc: maxx@spaceboyz.net
> 
> Looks good to me. If someone can repost with correct names and SoBs, then I'll
> apply.
> 

Jan, will you resend patch in correct format with correct names?

-- 
Pali Rohár
pali.rohar@gmail.com

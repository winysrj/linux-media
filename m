Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1610 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaDOKni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 06:43:38 -0400
Message-ID: <534D0D50.6020600@xs4all.nl>
Date: Tue, 15 Apr 2014 12:43:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: it-support <it@sca-uk.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: stoth@kernellabs.com
Subject: Re: [PATCH] cx23885: add support for Hauppauge ImpactVCB-e
References: <534BE92F.3010501@xs4all.nl> <534D0CD5.3090906@sca-uk.com>
In-Reply-To: <534D0CD5.3090906@sca-uk.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2014 12:41 PM, it-support wrote:
> Hi Guys,
> 
> This is a very noobie question,  but my 'patch' command does not return 
> to the command prompt.
> 
> I assume that my problem is one (or all four) of:
> 
> 1) the patch doesn't start or end where I think it does (I assume the 
> first line is
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> 
> and the last line is:
> 
>   #define GPIO_1 0x00000002
> 
> 2) I have put it in the wrong directory (I tried:
> 
> ~/linuxtv/media_build/linux/drivers/media/pci/cx23885/
> 
> and
> 
> ~/linuxtv/media_build
> 
> 3) My patch syntax is wrong.  I run it in the same directory as the file 
> like this: patch -b cx23885.diff

It's: patch -b <cx23885.diff

I still make this mistake and I've been doing this for many, many years :-)

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:8779 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3EUPAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 11:00:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] saa7115: Don't use a dynamic array
Date: Tue, 21 May 2013 17:00:22 +0200
References: <1369147293-30592-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1369147293-30592-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305211700.22465.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 21 May 2013 16:41:33 Mauro Carvalho Chehab wrote:
> At least on s390, gcc complains about that:
>     drivers/media/i2c/saa7115.c: In function 'saa711x_detect_chip.constprop.2':
>     drivers/media/i2c/saa7115.c:1647:1: warning: 'saa711x_detect_chip.constprop.2' uses dynamic stack allocation [enabled by default]
> 
> While for me the above report seems utterly bogus, as the
> compiler should be optimizing saa711x_detect_chip, merging
> it with saa711x_detect_chip and changing:
> 	char chip_ver[size - 1];
> to
> 	char chip_ver[16];
> 
> because this function is only called on this code snippet:
> 	char name[17];
> 	...
> 	ident = saa711x_detect_chip(client, id, name, sizeof(name));
> 
> It seems that gcc is not optimizing it, at least on s390.
> 
> As getting rid of it is easy, let's do it.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

	Hans

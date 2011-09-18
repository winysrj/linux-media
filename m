Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab1IRLax (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 07:30:53 -0400
Message-ID: <4E75D669.7040207@redhat.com>
Date: Sun, 18 Sep 2011 08:30:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: can't find bt driver
References: <4E7527BD.8040802@lockie.ca>
In-Reply-To: <4E7527BD.8040802@lockie.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-09-2011 20:05, James escreveu:
> Where is the bt848 driver in kernel-3.0.4?

It should be at the usual places:

$ find drivers/media/ -name bt8x*
drivers/media/video/bt8xx
drivers/media/dvb/bt8xx

$ find sound/ -name bt8*
sound/pci/bt87x.c

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10971 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3LIQAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 11:00:05 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXJ00CMAR44LR90@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Dec 2013 11:00:04 -0500 (EST)
Date: Mon, 09 Dec 2013 13:59:59 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Dinesh.Ram@cern.ch,
	edubezval@gmail.com
Subject: Re: [PATCHv2 00/11] si4713: add si4713 usb driver
Message-id: <20131209135959.60249587@samsung.com>
In-reply-to: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  6 Dec 2013 11:17:03 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This is the second version of this patch series from Dinesh:
> 
> http://www.spinics.net/lists/linux-media/msg68927.html
> 
> It's identical to the first version except for two new patches: patch 10/11
> prints the product number of the chip on the board and patch 11/11 fixes
> checkpatch warnings/errors in si4713.c and radio-usb-si4713.c.

It is better, but there are still a few fixes related to jiffies, as I
pointed on the previous emails.

Except for that, the patchset looks OK on my eyes.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro

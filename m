Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:46865 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaCNNKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 09:10:21 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2F002JRGL7F930@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 14 Mar 2014 09:10:19 -0400 (EDT)
Date: Fri, 14 Mar 2014 10:10:15 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] rtl2832_sdr driver
Message-id: <20140314101015.3148851c@samsung.com>
In-reply-to: <53224A61.4070602@iki.fi>
References: <53224A61.4070602@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Mar 2014 02:16:33 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> The following changes since commit 8ea5488a919bbd49941584f773fd66623192ffc0:
> 
>    [media] media: rc-core: use %s in rc_map_get() module load 
> (2014-03-13 11:32:28 -0300)
> 
> are available in the git repository at:
> 
>    git://linuxtv.org/anttip/media_tree.git sdr_review_v6

Those rises two new warnings on some archs:
	drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c:182:1: warning: 'rtl2832_sdr_wr' uses dynamic stack allocation [enabled by default]
	drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c:182:1: warning: 'rtl2832_sdr_wr' uses dynamic stack allocation [enabled by default]

-- 

Regards,
Mauro

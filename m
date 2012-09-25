Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab2IYUTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 16:19:44 -0400
Date: Tue, 25 Sep 2012 17:19:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, jwilson@redhat.com, sean@mess.org
Subject: Re: [PATCH 3/8] rc-core: add separate defines for protocol bitmaps
 and numbers
Message-ID: <20120925171936.6ff1ee7a@redhat.com>
In-Reply-To: <20120825214703.22603.19199.stgit@localhost.localdomain>
References: <20120825214520.22603.37194.stgit@localhost.localdomain>
	<20120825214703.22603.19199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Aug 2012 23:47:03 +0200
David Härdeman <david@hardeman.nu> escreveu:

> The RC_TYPE_* defines are currently used both where a single protocol is
> expected and where a bitmap of protocols is expected. This patch tries
> to separate the two in preparation for the following patches.
> 
> The intended use is also clearer to anyone reading the code. Where a
> single protocol is expected, enum rc_type is used, where one or more
> protocol(s) are expected, something like u64 is used.
> 
> The patch has been rewritten so that the format of the sysfs "protocols"
> file is no longer altered (at the loss of some detail). The file itself
> should probably be deprecated in the future though.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

Patch broke compilation. It seems you forgot to update RC6 meaning here:

  CC      drivers/media/usb/dvb-usb-v2/af9035.o
drivers/media/usb/dvb-usb-v2/af9035.c: In function 'af9035_get_rc_config':
drivers/media/usb/dvb-usb-v2/af9035.c:973:25: error: 'RC_BIT_RC6' undeclared (first use in this function)
drivers/media/usb/dvb-usb-v2/af9035.c:973:25: note: each undeclared identifier is reported only once for each function it appears in

-- 
Regards,
Mauro

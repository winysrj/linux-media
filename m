Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab1GMXqL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 19:46:11 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6DNkBQq011271
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 13 Jul 2011 19:46:11 -0400
Message-ID: <4E1E2E3D.6030507@redhat.com>
Date: Wed, 13 Jul 2011 20:46:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] redrat3 driver updates for 3.1
References: <1310592367-11501-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1310592367-11501-1-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-07-2011 18:26, Jarod Wilson escreveu:
> These changes make the redrat3 driver cooperate better with both in-kernel
> and lirc userspace decoding of signals, tested with RC5, RC6 and NEC.
> There's probably more we can do to make this a bit less hackish, but its
> working quite well here for me right now.
> 
> Jarod Wilson (3):
>   [media] redrat3: sending extra trailing space was useless
>   [media] redrat3: cap duration in the right place
>   [media] redrat3: improve compat with lirc userspace decode


Applied, thanks. There's one small issue on it (32 bits compilation):

drivers/media/rc/redrat3.c: In function ‘redrat3_init_rc_dev’:
drivers/media/rc/redrat3.c:1106: warning: assignment from incompatible pointer type
compilation succeeded


> 
>  drivers/media/rc/redrat3.c |   61 ++++++++++++++++++++-----------------------
>  1 files changed, 28 insertions(+), 33 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


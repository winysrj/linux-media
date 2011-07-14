Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1GNOke (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 10:40:34 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6EEeYnr001686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 10:40:34 -0400
Message-ID: <4E1EFFD0.6090501@redhat.com>
Date: Thu, 14 Jul 2011 10:40:16 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] redrat3 driver updates for 3.1
References: <1310592367-11501-1-git-send-email-jarod@redhat.com> <4E1E2E3D.6030507@redhat.com>
In-Reply-To: <4E1E2E3D.6030507@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em 13-07-2011 18:26, Jarod Wilson escreveu:
>> These changes make the redrat3 driver cooperate better with both in-kernel
>> and lirc userspace decoding of signals, tested with RC5, RC6 and NEC.
>> There's probably more we can do to make this a bit less hackish, but its
>> working quite well here for me right now.
>>
>> Jarod Wilson (3):
>>    [media] redrat3: sending extra trailing space was useless
>>    [media] redrat3: cap duration in the right place
>>    [media] redrat3: improve compat with lirc userspace decode
>
>
> Applied, thanks. There's one small issue on it (32 bits compilation):
>
> drivers/media/rc/redrat3.c: In function ‘redrat3_init_rc_dev’:
> drivers/media/rc/redrat3.c:1106: warning: assignment from incompatible pointer type
> compilation succeeded


I've mainly been working atop 3.0-rc bits, so I wasn't getting that 
warning. I believe that's new, following merge of one of David 
Härdeman's patches that reworks tx a bit, iirc. I'll take care of that 
as soon as I can.

-- 
Jarod Wilson
jarod@redhat.com



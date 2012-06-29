Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab2F2J00 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 05:26:26 -0400
Message-ID: <4FED74D2.3000105@redhat.com>
Date: Fri, 29 Jun 2012 11:26:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-media@vger.kernel.org,
	Antonio Ospite <ospite@studenti.unina.it>,
	stable@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.6] [media] gspca-core: Fix buffers staying
 in queued state after a stream_off
References: <E1Sjr0a-0006XB-Lg@www.linuxtv.org> <1340946601.4852.12.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1340946601.4852.12.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/29/2012 07:10 AM, Ben Hutchings wrote:
> On Mon, 2012-06-11 at 21:06 +0200, Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] gspca-core: Fix buffers staying in queued state after a stream_off
>> Author:  Hans de Goede <hdegoede@redhat.com>
>> Date:    Tue May 22 11:24:05 2012 -0300
>>
>> This fixes a regression introduced by commit f7059ea and should be
>> backported to all supported stable kernels which have this commit.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> Tested-by: Antonio Ospite <ospite@studenti.unina.it>
>> CC: stable@vger.kernel.org
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> [...]
>
> This surely can't both be so important that it should go into stable
> updates, yet so unimportant that it can wait for 3.6.

You're right. This patch was part of a pull-request titled:
"[GIT PULL FIXES FOR 3.5]: gspca & radio fixes"

Mauro, as the title of the mail suggested this pull-req contains
only fixes, which should really go into 3.5. Esp. The one pointed
out by Ben, but for example also the bttv fixes really belong in 3.5
(another user has already independently verified that they fix the
radio on his bttv card too). They really are all bug-fixes :)

Regards,

Hans

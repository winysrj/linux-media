Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab1HAHJZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2011 03:09:25 -0400
Message-ID: <4E365192.2000404@redhat.com>
Date: Mon, 01 Aug 2011 09:11:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL for v3.0] media updates for v3.1
References: <4E32EE71.4030908@redhat.com> <4E350B04.6050209@redhat.com> <4E3530BC.9050108@redhat.com>
In-Reply-To: <4E3530BC.9050108@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/31/2011 12:38 PM, Mauro Carvalho Chehab wrote:
> Em 31-07-2011 04:57, Hans de Goede escreveu:
>> Hi,
>>
>> I notice that Hans Verkuil's patches to make poll
>> report what is being polled to drivers, and my corresponding
>> patches for adding event support to pwc are not included,
>> what is the plan with these?
>
> The changes for the vfs code need vfs maintainer's ack, or to go
> via their tree. So, we need to wait for them to merge/send it
> upstream, before being able to merge the patches that depend on it.

Hmm, has anyone had any direct communications with the vfs maintainer
about this? If not I think we should have some direct communications
on this, otherwise we may end up waiting a long long time.

Regards,

Hans

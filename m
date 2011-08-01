Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1844 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1HAHp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 03:45:57 -0400
Message-ID: <c1f1fc61e7d5249df122e24ec539cb8a.squirrel@webmail.xs4all.nl>
In-Reply-To: <4E365192.2000404@redhat.com>
References: <4E32EE71.4030908@redhat.com> <4E350B04.6050209@redhat.com>
    <4E3530BC.9050108@redhat.com> <4E365192.2000404@redhat.com>
Date: Mon, 1 Aug 2011 09:45:53 +0200
Subject: Re: [GIT PULL for v3.0] media updates for v3.1
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi,
>
> On 07/31/2011 12:38 PM, Mauro Carvalho Chehab wrote:
>> Em 31-07-2011 04:57, Hans de Goede escreveu:
>>> Hi,
>>>
>>> I notice that Hans Verkuil's patches to make poll
>>> report what is being polled to drivers, and my corresponding
>>> patches for adding event support to pwc are not included,
>>> what is the plan with these?
>>
>> The changes for the vfs code need vfs maintainer's ack, or to go
>> via their tree. So, we need to wait for them to merge/send it
>> upstream, before being able to merge the patches that depend on it.
>
> Hmm, has anyone had any direct communications with the vfs maintainer
> about this? If not I think we should have some direct communications
> on this, otherwise we may end up waiting a long long time.

He was CC-ed on this from the very beginning...

Regards,

         Hans

>
> Regards,
>
> Hans
>



Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0CMGdj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 01:33:39 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2D6XdPu001801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 13 Mar 2010 01:33:39 -0500
Message-ID: <4B9B337F.50203@redhat.com>
Date: Sat, 13 Mar 2010 07:41:03 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pushes at v4l-utils tree
References: <4B99891E.9010406@redhat.com> <4B9A62B6.7090004@redhat.com> <4B9A962A.2020407@redhat.com>
In-Reply-To: <4B9A962A.2020407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/12/2010 08:29 PM, Mauro Carvalho Chehab wrote:
> Hans de Goede wrote:
>> Hi,
>>
>> On 03/12/2010 01:21 AM, Mauro Carvalho Chehab wrote:
>>> Hi Hans,
>>>
>>> As we've agreed that the idea is to allow multiple people to commit at
>>> v4l-utils,
>>> today, I've added 3 commits at v4l-utils tree (2 keycode-related and 1
>>> is .gitignore
>>> stuff). One of the reasons were to test the viability for such commits.
>>>
>>> I've temporarily enabled the same script that we use for upstream
>>> patches to
>>> generate patches against linuxtv-commits ML.
>>>
>>>   From my experiences, I have some notes:
>>>      1) git won't work fine if more than one is committing at the same
>>> tree.
>>> The reason is simple: it won't preserve the same group as the previous
>>> commits. So,
>>> the next committer will have troubles if we allow multiple committers;
>>>
>>
>> I assume you are talking about some issues with permissions on the
>> server side here ?
>
> Yes. The new objects and the touched files got a different group ownership
> after git push. I had to manually fix them at the server.
>

I'll get you in touch with one of the Fedora infrastructure admins.

Regards,

Hans

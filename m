Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936432Ab0CMBYp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 20:24:45 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2D1Oipg021519
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 20:24:44 -0500
Message-ID: <4B9AE956.203@redhat.com>
Date: Fri, 12 Mar 2010 22:24:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pushes at v4l-utils tree
References: <4B99891E.9010406@redhat.com> <4B9A62B6.7090004@redhat.com> <4B9A962A.2020407@redhat.com>
In-Reply-To: <4B9A962A.2020407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
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
>>>  From my experiences, I have some notes:
>>>     1) git won't work fine if more than one is committing at the same
>>> tree.
>>> The reason is simple: it won't preserve the same group as the previous
>>> commits. So,
>>> the next committer will have troubles if we allow multiple committers;
>>>
>> I assume you are talking about some issues with permissions on the
>> server side here ?
> 
> Yes. The new objects and the touched files got a different group ownership
> after git push. I had to manually fix them at the server.

I added a hook that will likely fix it. As I have a few more changes to ir-keytable,
I'll be sending it directly and see if the permissions are properly fixed.

Please, don't upgrade the version yet just due to keytable, as I'm still working on
more keytable patches, to handle the new uevent attributes (to match the IR core patches
I posted earlier today).

-- 

Cheers,
Mauro

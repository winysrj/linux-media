Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab0CLPtH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 10:49:07 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2CFn7et020575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 10:49:07 -0500
Message-ID: <4B9A62B6.7090004@redhat.com>
Date: Fri, 12 Mar 2010 16:50:14 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pushes at v4l-utils tree
References: <4B99891E.9010406@redhat.com>
In-Reply-To: <4B99891E.9010406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/12/2010 01:21 AM, Mauro Carvalho Chehab wrote:
> Hi Hans,
>
> As we've agreed that the idea is to allow multiple people to commit at v4l-utils,
> today, I've added 3 commits at v4l-utils tree (2 keycode-related and 1 is .gitignore
> stuff). One of the reasons were to test the viability for such commits.
>
> I've temporarily enabled the same script that we use for upstream patches to
> generate patches against linuxtv-commits ML.
>
>  From my experiences, I have some notes:
> 	1) git won't work fine if more than one is committing at the same tree.
> The reason is simple: it won't preserve the same group as the previous commits. So,
> the next committer will have troubles if we allow multiple committers;
>

I assume you are talking about some issues with permissions on the server side here ?

> 	2) people need to pull/rebase before pushing, if we fix the group permission
> issue above. I've enabled a hook that is meant to avoid rebase upstream, to prevent
> troubles if people push something with -f. I hope it works fine.
>

Ack, actually I just did that (rebase my local tree before pushing) as you pushed
some changes before I did.

> In summary, for now, I think that the better is to post all patches to v4l-utils at ML
> and ask Hans to merge them.
>

Yes and no, if you've a few patches, sure. If you are doing regular development you should
get commit access. In my experience in various projects multiple people pushing to the
same git tree will work fine.

Regards,

Hans

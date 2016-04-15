Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49114 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbcDOItz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 04:49:55 -0400
Subject: Re: Backport a Security Fix for CVE-2015-7833 to v4.1
To: Vladis Dronov <vdronov@redhat.com>,
	Yuki Machida <machida.yuki@jp.fujitsu.com>
References: <570B33E6.40705@jp.fujitsu.com>
 <573811194.2583282.1460376200290.JavaMail.zimbra@redhat.com>
Cc: sasha levin <sasha.levin@oracle.com>, linux-media@vger.kernel.org,
	stable@vger.kernel.org, oneukum@suse.com, mchehab@osg.samsung.com,
	ralf@spenneberg.net
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5710AB2A.50702@xs4all.nl>
Date: Fri, 15 Apr 2016 10:49:46 +0200
MIME-Version: 1.0
In-Reply-To: <573811194.2583282.1460376200290.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladis,

On 04/11/2016 02:03 PM, Vladis Dronov wrote:
> Hello,
> 
> I apologize for intercepting, but I believe commit 588afcc1 should
> not be accepted and reverted in the trees where it was.

Your patch requesting that commit to be reverted fell through the cracks.

Having looked at it I agree that it should be reverted and I will apply it.

The main reason is really the incorrect error return which should have been
a goto. But as you say reverting it is easiest since your code does the
right thing.

Regards,

	Hans

> 
> Reasons:
> 
> https://patchwork.linuxtv.org/patch/32798/
> or
> https://www.spinics.net/lists/linux-media/msg96936.html
> 
> 
> Best regards,
> Vladis Dronov | Red Hat, Inc. | Product Security Engineer
> 
> ----- Original Message -----
> From: "Yuki Machida" <machida.yuki@jp.fujitsu.com>
> To: "sasha levin" <sasha.levin@oracle.com>
> Cc: linux-media@vger.kernel.org, stable@vger.kernel.org, hverkuil@xs4all.nl, oneukum@suse.com, vdronov@redhat.com, mchehab@osg.samsung.com, ralf@spenneberg.net
> Sent: Monday, April 11, 2016 7:19:34 AM
> Subject: Backport a Security Fix for CVE-2015-7833 to v4.1
> 
> Hi Sasha,
> 
> I conformed that these patches for CVE-2015-7833 not applied at v4.1.21.
> 588afcc1c0e45358159090d95bf7b246fb67565
> fa52bd506f274b7619955917abfde355e3d19ff
> Could you please apply this CVE-2015-7833 fix for 4.1-stable ?
> 
> References:
> https://security-tracker.debian.org/tracker/CVE-2015-7833
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=588afcc1c0e45358159090d95bf7b246fb67565f
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=fa52bd506f274b7619955917abfde355e3d19ffe
> 
> Regards,
> Yuki Machida
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


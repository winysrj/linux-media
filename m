Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:59039 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbcDOIbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 04:31:39 -0400
Subject: Re: Backport a Security Fix for CVE-2015-7833 to v4.1
To: Vladis Dronov <vdronov@redhat.com>
References: <570B33E6.40705@jp.fujitsu.com>
 <573811194.2583282.1460376200290.JavaMail.zimbra@redhat.com>
Cc: sasha levin <sasha.levin@oracle.com>, linux-media@vger.kernel.org,
	stable@vger.kernel.org, hverkuil@xs4all.nl, oneukum@suse.com,
	mchehab@osg.samsung.com, ralf@spenneberg.net
From: Yuki Machida <machida.yuki@jp.fujitsu.com>
Message-ID: <5710A6D5.8000302@jp.fujitsu.com>
Date: Fri, 15 Apr 2016 17:31:17 +0900
MIME-Version: 1.0
In-Reply-To: <573811194.2583282.1460376200290.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladis,

 > I apologize for intercepting, but I believe commit 588afcc1 should
 > not be accepted and reverted in the trees where it was.
 >
 > Reasons:
 >
 > https://patchwork.linuxtv.org/patch/32798/
 > or
 > https://www.spinics.net/lists/linux-media/msg96936.html
Thank you for your reply.

If it revert commit 588afcc1 from the kernel,
It exists a Security Issue of CVE-2015-7833.
What do you think about it?

Best regards,
Yuki Machida

On 2016年04月11日 21:03, Vladis Dronov wrote:
> Hello,
>
> I apologize for intercepting, but I believe commit 588afcc1 should
> not be accepted and reverted in the trees where it was.
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
>

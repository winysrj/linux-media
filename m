Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:37658 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbcDRJWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 05:22:45 -0400
Date: Mon, 18 Apr 2016 05:20:54 -0400 (EDT)
From: Vladis Dronov <vdronov@redhat.com>
To: Yuki Machida <machida.yuki@jp.fujitsu.com>
Cc: sasha levin <sasha.levin@oracle.com>, linux-media@vger.kernel.org,
	stable@vger.kernel.org, hverkuil@xs4all.nl, oneukum@suse.com,
	mchehab@osg.samsung.com, ralf@spenneberg.net
Message-ID: <769622525.6010599.1460971254286.JavaMail.zimbra@redhat.com>
In-Reply-To: <57149B8C.8010900@jp.fujitsu.com>
References: <570B33E6.40705@jp.fujitsu.com> <573811194.2583282.1460376200290.JavaMail.zimbra@redhat.com> <5710A6D5.8000302@jp.fujitsu.com> <1369454336.4654676.1460714156331.JavaMail.zimbra@redhat.com> <57149B8C.8010900@jp.fujitsu.com>
Subject: Re: Backport a Security Fix for CVE-2015-7833 to v4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Yuki, all,

> Why "usbvision: revert commit 588afcc1" is not accepted in linux-media ?

As mentioned in a message from Hans down this thread, it "fell through the cracks",
unfortunately. (http://www.spinics.net/lists/linux-media/msg99495.html)

Best regards,
Vladis Dronov | Red Hat, Inc. | Product Security Engineer

----- Original Message -----
From: "Yuki Machida" <machida.yuki@jp.fujitsu.com>
To: "Vladis Dronov" <vdronov@redhat.com>
Cc: "sasha levin" <sasha.levin@oracle.com>, linux-media@vger.kernel.org, stable@vger.kernel.org, hverkuil@xs4all.nl, oneukum@suse.com, mchehab@osg.samsung.com, ralf@spenneberg.net
Sent: Monday, April 18, 2016 10:32:12 AM
Subject: Re: Backport a Security Fix for CVE-2015-7833 to v4.1

Hi Vladis,

On 2016年04月15日 18:55, Vladis Dronov wrote:
> Hello, Yuki, all,
>
> My commit fa52bd506f resolves CVE-2015-7833, as mentioned in
> https://www.spinics.net/lists/linux-media/msg96936.html
I understand that commit fa52bd506f resolved security issue of CVE-2015-7833
and commit 588afcc1 is not needed for fixing of CVE-2015-7833.

> Please, note a message from Hans down this thread, who agrees
> with my point.
I understand the opinion of Vladis and Hans.
Why "usbvision: revert commit 588afcc1" is not accepted in linux-media ?

Regards,
Yuki Machida

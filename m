Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbcDSFzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2016 01:55:55 -0400
Date: Tue, 19 Apr 2016 14:55:49 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Yuki Machida <machida.yuki@jp.fujitsu.com>
Cc: sasha levin <sasha.levin@oracle.com>,
	Vladis Dronov <vdronov@redhat.com>,
	linux-media@vger.kernel.org, stable@vger.kernel.org,
	hverkuil@xs4all.nl, oneukum@suse.com, mchehab@osg.samsung.com,
	ralf@spenneberg.net
Subject: Re: Backport a Security Fix for CVE-2015-7833 to v4.1
Message-ID: <20160419055549.GA19287@kroah.com>
References: <570B33E6.40705@jp.fujitsu.com>
 <573811194.2583282.1460376200290.JavaMail.zimbra@redhat.com>
 <5710A6D5.8000302@jp.fujitsu.com>
 <1369454336.4654676.1460714156331.JavaMail.zimbra@redhat.com>
 <5714A25F.2050500@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5714A25F.2050500@jp.fujitsu.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 18, 2016 at 06:01:19PM +0900, Yuki Machida wrote:
> Hi Greg and Sasha,
> 
> Please do not accept patch of 588afcc to stable tree,
> because above patch has some problem.
> It reported by Vladis and Hans.
> https://patchwork.linuxtv.org/patch/32798/
> https://www.spinics.net/lists/linux-media/msg96936.html
> http://article.gmane.org/gmane.linux.kernel.stable/174202/match=cve+2015+7833

Ok, now dropped from the 3.14-stable and 4.4-stable queues, thanks.

greg k-h

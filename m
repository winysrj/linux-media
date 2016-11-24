Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44295 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964793AbcKXLNN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 06:13:13 -0500
Subject: Re: [PATCH 1/3] [media] ivtv: prepare to convert to pr_foo()
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <897a2e15-7582-b05a-fa17-2046cb7d8313@xs4all.nl>
Date: Thu, 24 Nov 2016 12:13:09 +0100
MIME-Version: 1.0
In-Reply-To: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/16 12:01, Mauro Carvalho Chehab wrote:
> Move the pr_fmt() macro to ivtv_driver.h and ensure that it
> will be the first file to be included on all ivtv files.
>
> While here, put the includes inside ivtv-driver.h on
> alphabetic order.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

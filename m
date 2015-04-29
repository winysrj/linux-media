Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15723 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031665AbbD2JD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 05:03:57 -0400
Message-id: <55409E68.30006@samsung.com>
Date: Wed, 29 Apr 2015 11:03:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 10/14] s3c-camif: Check if fmt is NULL before use
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
 <14da8840d09d05132cc6183b85cffecb71f2bde4.1430235781.git.mchehab@osg.samsung.com>
In-reply-to: <14da8840d09d05132cc6183b85cffecb71f2bde4.1430235781.git.mchehab@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/04/15 17:43, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> 	drivers/media/platform/s3c-camif/camif-capture.c:463 queue_setup() warn: variable dereferenced before check 'fmt' (see line 460)
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

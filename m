Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38086 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaJJIOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 04:14:45 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND700CAXZ1DG060@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Oct 2014 09:17:37 +0100 (BST)
Message-id: <54379572.10900@samsung.com>
Date: Fri, 10 Oct 2014 10:14:42 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC 0/1] Libv4l: Add a plugin for the Exynos4 camera
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
 <5436C9DF.8090001@googlemail.com>
In-reply-to: <5436C9DF.8090001@googlemail.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/09/2014 07:46 PM, Gregor Jasny wrote:
> Hi,
>
> On 08/10/14 10:46, Jacek Anaszewski wrote:
>> This patch adds a plugin for the Exynos4 camera. I wanted to split
>> at least the parser part to the separate module but encountered
>> some problems with autotools configuration and therefore I'd like
>> to ask for an instruction on how to adjust the Makefile.am files
>> to achieve this.
>
> I was the one who authored the v4l-utils build system. It looks a little
> bit messy because of all the supported configurations and toolchain
> capabilities.
>
> Feel free to ask if you have any questions.

Thanks, I will certainly make use of your expertise, when in need.

Regards,
Jacek

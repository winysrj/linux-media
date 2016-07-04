Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:45379 "EHLO
	ussmtp01.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932249AbcGDDEj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2016 23:04:39 -0400
Subject: Re: [PATCH v5 0/2] [media] atmel-isc: add driver for Atmel ISC
To: Hans Verkuil <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>, <nicolas.ferre@atmel.com>,
	<boris.brezillon@free-electrons.com>,
	<alexandre.belloni@free-electrons.com>, <robh@kernel.org>
References: <1466153854-30272-1-git-send-email-songjun.wu@atmel.com>
 <e96fe150-2e5c-5ffa-3c1b-99e55fa4bff0@xs4all.nl>
CC: <linux-arm-kernel@lists.infradead.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	=?UTF-8?Q?Niklas_S=c3=83=c2=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	Benoit Parrot <bparrot@ti.com>,
	Kumar Gala <galak@codeaurora.org>,
	<linux-kernel@vger.kernel.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	<devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mark Rutland <mark.rutland@arm.com>,
	<linux-media@vger.kernel.org>,
	Simon Horman <horms+renesas@verge.net.au>
From: "Wu, Songjun" <songjun.wu@atmel.com>
Message-ID: <8aaf895f-d600-7df6-fcb4-3c3e366c0b90@atmel.com>
Date: Mon, 4 Jul 2016 11:04:16 +0800
MIME-Version: 1.0
In-Reply-To: <e96fe150-2e5c-5ffa-3c1b-99e55fa4bff0@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 7/1/2016 20:20, Hans Verkuil wrote:
> Hi Songjun,
>
> First of all, please CC patch 2/2 to linux-media as well the next time you post this.
> I only see 1/2 on the mailinglist, and we need both.
>
> Secondly, before I can accept it you need to run the v4l2-compliance test first and
> I need to see the output of that test.
>
> The compliance test is here: https://git.linuxtv.org/v4l-utils.git. Always compile it from
> the repository so you know you are using the latest most up to date version.
>
> Since this driver supports multiple pixelformats you need to test with the -f option,
> which tests streaming for all pixelformats.
>
> Obviously, there shouldn't be any FAILs :-)
>
> I greatly simplifies the code review if I know it passes the compliance test.
>
Hi Hans,

You suggestion is very helpful to me.
I will give the output of the compliance test in next version.

> Regards,
>
> 	Hans
>

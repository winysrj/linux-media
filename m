Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57555 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbaLONaJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 08:30:09 -0500
Message-ID: <548EE25C.4060808@iki.fi>
Date: Mon, 15 Dec 2014 15:30:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Prashant Laddha <prladdha@cisco.com>
CC: hverkuil@xs4all.nl,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/6] Use LUT based implementation for (co)sine functions
References: <1418635162-8814-1-git-send-email-prladdha@cisco.com>	<1418635162-8814-2-git-send-email-prladdha@cisco.com> <20141215111321.7602a7b9@recife.lan>
In-Reply-To: <20141215111321.7602a7b9@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2014 03:13 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 15 Dec 2014 14:49:17 +0530
> Prashant Laddha <prladdha@cisco.com> escreveu:
>
>> Replaced Taylor series calculation for (co)sine with a
>> look up table (LUT) for sine values.
>
> Kernel has already a LUT for sin/cos at:
> 	include/linux/fixp-arith.h
>
> The best would be to either use it or improve its precision, if the one there
> is not good enough.

I looked that one when made generator. It has poor precision and it uses 
degrees not radians. But surely it is correct practice improve existing 
than introduce new.

regards
Antti


-- 
http://palosaari.fi/

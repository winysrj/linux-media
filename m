Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:59999 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0ADVLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 16:11:10 -0500
Message-ID: <4B425954.6030603@freemail.hu>
Date: Mon, 04 Jan 2010 22:10:44 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] rj54n1cb0c: remove compiler warning
References: <201001031950.o03JoIjh012466@smtp-vbr4.xs4all.nl> <4B40FF73.2060906@freemail.hu> <Pine.LNX.4.64.1001042158350.9164@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1001042158350.9164@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> Hi Márton
> 
> On Sun, 3 Jan 2010, Németh Márton wrote:
> 
>> From: Márton Németh <nm127@freemail.hu>
>>
>> Remove the following compiler warning: 'dummy' is used uninitialized in this function.
>> Although the result in the dummy variable is not used the program flow in
>> soc_camera_limit_side() depends on the value in dummy. The program flow is better
>> to be deterministic.
>>
>> Signed-off-by: Márton Németh <nm127@freemail.hu>
> 
> The patch is good, the only slight problem - you have non-ASCII characters 
> in your name and you didn't use UTF-8 to send this mail, which, I think, 
> is the accepted encoding in the Linux kernel. I converted your patch to 
> utf8 and attached to this mail. Please verify that the result is correct.

Your conversion is OK. Sorry about this issue.

Regards,

	Márton Németh

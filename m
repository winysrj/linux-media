Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:52319 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZIASkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 14:40:33 -0400
Message-ID: <4A9D6A99.6050707@freemail.hu>
Date: Tue, 01 Sep 2009 20:40:25 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Michel Xhaard <mxhaard@users.sourceforge.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_sunplus: problem with brightness control
References: <4A9A1AB6.2050801@freemail.hu> <20090831112827.567a0a1f@tele>
In-Reply-To: <20090831112827.567a0a1f@tele>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Jean-Francois Moine wrote:
> On Sun, 30 Aug 2009 08:22:46 +0200
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> I am using a "Trust 610 LCD Powerc@m Zoom" device in webcam mode
>> (USB ID=06d6:0031). I am running Linux 2.6.31-rc7 updated with the
>> http://linuxtv.org/hg/v4l-dvb repository at version
>> 12564:6f58a5d8c7c6.
>>
>> When I start watching to the webcam picture and change the brightness
>> value then I get the following result. The possible brigthness values
>> are between 0 and 255.
> 	[snip]
>
> I fixed this problem in my test repository. As I did some other changes
> in sunplus.c, may you check if everything works for you?

I tested the version "12663:7f68f4e03299" from
http://linuxtv.org/hg/~jfrancois/gspca/ . The picture is still OK, the
brightness, contrast and color contrast are working correctly now as
expected. I have done the tests with "Trust 610 LCD Powerc@m Zoom" device
in webcam mode (USB ID=06d6:0031).

Thank you for your work!

Regards,

	Márton Németh



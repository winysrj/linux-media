Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:56523 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3H3Nnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 09:43:52 -0400
Received: by mail-ea0-f178.google.com with SMTP id a15so931656eae.37
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 06:43:49 -0700 (PDT)
Message-ID: <5220A190.70902@googlemail.com>
Date: Fri, 30 Aug 2013 15:43:44 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: g.liakhovetski@gmx.de
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <5210B2A9.1030803@googlemail.com> <20130818122008.38fac218@samsung.com> <1904390.nVVGcVBrVP@avalon> <52139A9B.1030400@googlemail.com> <52152578.2060201@googlemail.com> <5215344E.2070002@gmail.com> <52168D98.9060600@googlemail.com> <Pine.LNX.4.64.1308301227230.12356@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1308301227230.12356@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Am 30.08.2013 12:30, schrieb Guennadi Liakhovetski:
> Hi Frank,
>
> On Fri, 23 Aug 2013, Frank Schäfer wrote:
>
>> Hi Sylwester,
>>
>> Am 21.08.2013 23:42, schrieb Sylwester Nawrocki:
>>> Hi Frank,
>>>
>>> On 08/21/2013 10:39 PM, Frank Schäfer wrote:
>>>> Am 20.08.2013 18:34, schrieb Frank Schäfer:
>>>>> Am 20.08.2013 15:38, schrieb Laurent Pinchart:
>>>>>> Hi Mauro,
>>>>>>
>>>>>> On Sunday 18 August 2013 12:20:08 Mauro Carvalho Chehab wrote:
>>>>>>> Em Sun, 18 Aug 2013 13:40:25 +0200 Frank Schäfer escreveu:
>>>>>>>> Am 17.08.2013 12:51, schrieb Guennadi Liakhovetski:
>>>>>>>>> Hi Frank,
>>>>>>>>> As I mentioned on the list, I'm currently on a holiday, so,
>>>>>>>>> replying
>>>>>>>>> briefly.
>>>>>>>> Sorry, I missed that (can't read all mails on the list).
>>>>>>>>
>>>>>>>>> Since em28xx is a USB device, I conclude, that it's supplying
>>>>>>>>> clock to
>>>>>>>>> its components including the ov2640 sensor. So, yes, I think the
>>>>>>>>> driver
>>>>>>>>> should export a V4L2 clock.
> Could you please test this patch series 
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/68510 
> to see whether it fixes this your problem?
Thanks for the patches.
Unfortunately, I'm traveling this week and can't test them before
Monday, sorry. :(
But I've put I on my ToDo list. Please be patient.

Regards,
Frank

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/


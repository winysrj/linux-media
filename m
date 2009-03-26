Return-path: <linux-media-owner@vger.kernel.org>
Received: from zmr1.zoran.com ([67.98.202.21]:32903 "EHLO zmr1.zoran.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753AbZCZWNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 18:13:17 -0400
Message-ID: <49CBF437.7030603@zoran.com>
Date: Thu, 26 Mar 2009 17:31:35 -0400
From: Dave Strauss <Dave.Strauss@zoran.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Darius Augulis <augulis.darius@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
References: <49C89F00.1020402@gmail.com>	<Pine.LNX.4.64.0903261405520.5438@axis700.grange>	<49CBD53C.6060700@gmail.com> <20090326170910.6926d8de@pedra.chehab.org> <Pine.LNX.4.64.0903262116410.5438@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903262116410.5438@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Thu, 26 Mar 2009, Mauro Carvalho Chehab wrote:
> 
>>>>> +	/* common v4l buffer stuff -- must be first */
>>>>> +	struct videobuf_buffer vb;
>>>>>     
>>>> Here you have one space
>>>>
>>>>   
>>>>> +
>>>>> +	const struct soc_camera_data_format        *fmt;
>>>>>     
>>>> Here you have 8 spaces
>>>>
>>>>   
>>>>> +
>>>>> +	int			inwork;
>>>>>     
>>>> Here you have tabs. Please, unify.
>> Please always check your patches with checkpatch.pl. This will point such issues.
> 
> No, I did check the patch with checkpatch.pl and it didn't complain about 
> this. It checks _indentation_ of lines, that _must_ be done with TABs, but 
> it doesn't check what is used for alignment _inside_ lines, like
> 
> 	xxx     = 0;
> 	y	= 1;
> 	zzzzz   = 2;
> 
> where first and third lines have spaces before "=", and the second one has 
> a TAB. This is not checked by checkpatch.pl.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 

Newbie question -- where does one find checkpatch.pl?  And are there any other
tools we should be running on patches before we submit them?

Thanks.

  - Dave Strauss

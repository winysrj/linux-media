Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:62330 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717AbZKYOiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 09:38:18 -0500
Received: by ey-out-2122.google.com with SMTP id 4so1535958eyf.19
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2009 06:38:23 -0800 (PST)
Message-ID: <4B0D415C.2010108@gmail.com>
Date: Wed, 25 Nov 2009 15:38:20 +0100
From: Ryan Raasch <ryan.raasch@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Camera sensor
References: <4B0BE393.2080904@gmail.com> <Pine.LNX.4.64.0911242244360.4680@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911242244360.4680@axis700.grange>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Guennadi Liakhovetski wrote:
> On Tue, 24 Nov 2009, Ryan Raasch wrote:
> 
>> Hello,
>>
>> I have implemented a driver for the LZ0P374 Sharp CCD camera sensor. I have
>> been using an old kernel, and now i am updating to the new soc_camera
>> framework. My question is, is there anyone using this sensor? We bought the
>> sensor with absolutely no documents, support to be found (lucky to get driver
>> running).
> 
> I've recently implemented a driver for a rj54n1cb0c camera, and I've seen 
> it being referred to as lz0p398m... A simplified version of it is 
> currently in the linux-next tree, and a more complete version has been 
> submitted for review to the list. Would be interesting if you could dig 
> out that driver from the mailing list archives and see how similar it is 
> to your camera.
> 
> You can also see the patch-stack here
> 
> http://download.open-technology.de/soc-camera/20091105/
> 
> apply it to linux 2.6.32-rc5 and look at the resulting 
> drivers/media/video/rj54n1cb0c.c file.
> 
Thanks. I am looking at the code now. I have found the CMOS sensors are 
a little less confusing b/c of all the driving and clocking signals in 
the CCD chip. I will have a look at the code.

Thanks again for your input.

Ryan
>> It was found on the Sandgate 2P Sophia Systems development kit. The sensor is
>> mainly (only) sold in Asia. But at the time of our product release (~2006),
>> this was the only CCD camera sensor to be found in quantities less than
>> millions.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

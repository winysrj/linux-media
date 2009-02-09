Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:54563 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbZBIUKt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 15:10:49 -0500
Message-ID: <49908DE3.5000606@free.fr>
Date: Mon, 09 Feb 2009 21:11:15 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Jason Harvey <softdevice@jasonline.co.uk>
CC: linux-media@vger.kernel.org
Subject: Re: CinergyT2 not working with newer alternative driver
References: <4984E50D.8000506@jasonline.co.uk> <49857A09.9020302@free.fr> <49859A71.70701@jasonline.co.uk> <4986925A.9040800@free.fr> <498697B5.10200@jasonline.co.uk> <498F50AE.4080004@free.fr> <499071FC.7080005@jasonline.co.uk>
In-Reply-To: <499071FC.7080005@jasonline.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jason Harvey wrote:
> Thierry Merle wrote:
>> Another thing, do you know the firmware version of your tuner?
>> I have the 1.06 version.
>>   
> Both are running on firmware 1.08
> Wonder if I can downgrade them... will look into that.
Yes, and I will try to find time to upgrade mine.
>> Look at lsusb -vvv, this is the "bcdDevice" line for the CinergyT2
>> device.
>> Sorry but I have no idea of the origin of the problem.
>> If I had time I would compare USB dumps between the old driver and the
>> new one for the same tuning operation.
>>   
> I'll try and get the USB dumps and a comparison done myself within the
> next week or two.
OK thanks; I will be able to help you by doing some perl scripts.
> Think I have a spare PC around with an older Fedora on it with a kernel
> that worked.
> I did see another posting to this mail list from someone with the same
> problem which I'll take as confirmation that it is not just me :)
> 
Yes I know, but the user did not answer the last time so we committed the redesign and we expect to find another user with the problem :)
Regards,
Thierry

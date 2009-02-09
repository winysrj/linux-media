Return-path: <linux-media-owner@vger.kernel.org>
Received: from 78-86-168-217.zone2.bethere.co.uk ([78.86.168.217]:43299 "EHLO
	homer.jasonline.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbZBISMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 13:12:17 -0500
Message-ID: <499071FC.7080005@jasonline.co.uk>
Date: Mon, 09 Feb 2009 18:12:12 +0000
From: Jason Harvey <softdevice@jasonline.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Thierry Merle <thierry.merle@free.fr>
Subject: Re: CinergyT2 not working with newer alternative driver
References: <4984E50D.8000506@jasonline.co.uk> <49857A09.9020302@free.fr> <49859A71.70701@jasonline.co.uk> <4986925A.9040800@free.fr> <498697B5.10200@jasonline.co.uk> <498F50AE.4080004@free.fr>
In-Reply-To: <498F50AE.4080004@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thierry Merle wrote:
> Another thing, do you know the firmware version of your tuner?
> I have the 1.06 version.
>   
Both are running on firmware 1.08
Wonder if I can downgrade them... will look into that.
> Look at lsusb -vvv, this is the "bcdDevice" line for the CinergyT2 device.
> Sorry but I have no idea of the origin of the problem.
> If I had time I would compare USB dumps between the old driver and the new one for the same tuning operation.
>   
I'll try and get the USB dumps and a comparison done myself within the 
next week or two.
Think I have a spare PC around with an older Fedora on it with a kernel 
that worked.
I did see another posting to this mail list from someone with the same 
problem which I'll take as confirmation that it is not just me :)

Regards,
Jason

Return-path: <linux-media-owner@vger.kernel.org>
Received: from luna.schedom-europe.net ([193.109.184.86]:57378 "HELO
	luna.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752240Ab3CAU3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 15:29:01 -0500
Message-ID: <20130301212854.93kflfbg4jc0kksk@webmail.dommel.be>
Date: Fri,  1 Mar 2013 21:28:54 +0100
From: jandegr1@dommel.be
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: HAUPPAUGE HVR-930C analog tv feasible ??
References: <20130225120117.atcsi16l8jokos80@webmail.dommel.be>
	<20130225083345.2d83d554@redhat.com>
In-Reply-To: <20130225083345.2d83d554@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Citeren Mauro Carvalho Chehab <mchehab@redhat.com>:

> Em Mon, 25 Feb 2013 12:01:17 +0100
> jandegr1@dommel.be escreveu:
>
>> Hi,
>>
>> To get analog tv working on a hauppauge hvr-930c, I started sniffing usb and
>> parsing.
>>
>> you can see a sample here : 
>> https://dl.dropbox.com/u/93775123/grphCable22.txt
>>
>> Howeverver I am missing a lot of knowledge to jump on it right away, so I'd
>> as for opinion of the experts over here first.
>
> AFAIKT, the designs with avf4910b also has a drx-k demod on it (or maybe some
> other Micronas demod, like drx-j).
>
> When I added support for Terratec H7, I used a Linux driver made available by
> Terratec at that time, as reference. See:
> 	http://lwn.net/Articles/476992/
>
> While I don't see the link for the driver anymore on Terratec linux site,
> it seems that the file is still there at:
> 	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
>
> While H7 driver there only adds support for digital TV, you may find
> something useful at drxk driver, as it has several stuff there related
> to analog TV. I won't doubt that the needed bits for avf4910 are (at least
> partially) there. So, you may find useful to take a look on it.
>
> To be frank, while I would love to have analog working there, I never
> found enough time to work on adding analog support for it, nor I succeeded
> to get any avf4910b datasheet or development kit.
>
>>
>> This could be benifical for several other cards with the avf4910 as well.
>
> Sure. I suspect that, once having it work for one device, it should be
> trivial to make it work with the others.
>
>>
>> thx,
>>
>> Jan De Graeve
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
>
> Cheers,
> Mauro
>
Hi,

Thanks for the pointers, the code for the audio demodulator is in the drx-k
driver. I updated the comments accordingly in
https://dl.dropbox.com/u/93775123/grphCable22.txt
I am updating that file it as I find more things.

Any other suggestions/comments or anyone wanting to work with me on this ?
It would be a pity if these boards did not get analog support.

regards,

Jan De Graeve








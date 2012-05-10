Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:38661 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab2EJQn1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 12:43:27 -0400
Received: from [192.168.0.104] (unknown [82.225.141.62])
	by smtp1-g21.free.fr (Postfix) with ESMTP id D2AB0940134
	for <linux-media@vger.kernel.org>; Thu, 10 May 2012 18:43:20 +0200 (CEST)
Message-ID: <4FABF027.3020405@yahoo.fr>
Date: Thu, 10 May 2012 18:43:19 +0200
From: chrbruno <chrbruno@yahoo.fr>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: em28xx : can work on ARM beagleboard ?
References: <4FA96365.3090705@yahoo.fr> <4FABC503.5060006@redhat.com>
In-Reply-To: <4FABC503.5060006@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm not sure about the fix (it could break the driver for other em28xx 
cards) but I will try to post a patch for the em28xx problem on ARM

Next, I have encountered the same USB problem you described : USB 
stopping after a long capture (and ethernet stops too)
For this problem, I think a patch is available about the PHY update 
frequency
Have a look to :
http://rcn-ee.homeip.net:81/testing/beagleboard/sprz319-erratum-2.1/
I found it in a thread on the google beagleboard list)
I will try and post the results here

Regards,
Chris

Le 10/05/2012 15:39, Mauro Carvalho Chehab a �crit :
> Em 08-05-2012 15:18, CB escreveu:
>> Hello,
>>
>> I would like to know if someone has already used the em28xx driver on a beagleboard xM
>> (the connected device is a Dazzle DVC 100)
>>
>> I have tried with an Angstrom Narcissus image and a Debian but I still get "select timeouts" and skipped frames with mencoded or the capture.c sample
> Not sure if something changed, but on previous tests I did with USB 2.0 isoc
> and Beagleboard, it seems that it has something broken at its USB driver:
> after some time, it stops working when submitted to a high traffic.
>
> I noticed this behavior not only with USB capture cards, but also when using
> it to sniff traffic, using Google's GoC sniffer[1].
>
> [1] http://beagleboard.org/project/usbsniffer/
>
>> Thanks in advance,
>>
>> Regards,
>> Chris
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


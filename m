Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab2EJNjS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 09:39:18 -0400
Message-ID: <4FABC503.5060006@redhat.com>
Date: Thu, 10 May 2012 10:39:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: CB <chrbruno@yahoo.fr>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: em28xx : can work on ARM beagleboard ?
References: <4FA96365.3090705@yahoo.fr>
In-Reply-To: <4FA96365.3090705@yahoo.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-05-2012 15:18, CB escreveu:
> Hello,
> 
> I would like to know if someone has already used the em28xx driver on a beagleboard xM
> (the connected device is a Dazzle DVC 100)
> 
> I have tried with an Angstrom Narcissus image and a Debian but I still get "select timeouts" and skipped frames with mencoded or the capture.c sample

Not sure if something changed, but on previous tests I did with USB 2.0 isoc
and Beagleboard, it seems that it has something broken at its USB driver:
after some time, it stops working when submitted to a high traffic. 

I noticed this behavior not only with USB capture cards, but also when using 
it to sniff traffic, using Google's GoC sniffer[1].

[1] http://beagleboard.org/project/usbsniffer/

> 
> Thanks in advance,
> 
> Regards,
> Chris
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


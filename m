Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd18532.kasserver.com ([85.13.139.13]:40912 "EHLO
	dd18532.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbZDAMbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 08:31:38 -0400
Date: Wed, 1 Apr 2009 14:31:34 +0200
From: Carsten Meier <cm@trexity.de>
To: Carsten Meier <cm@trexity.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Where to get dvb-usb-dw2104.fw for TeVii S650
Message-ID: <20090401143134.45e8053f@tuvok>
In-Reply-To: <20090401140116.55123d8f@tuvok>
References: <20090401140116.55123d8f@tuvok>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 1 Apr 2009 14:01:16 +0200
schrieb Carsten Meier <cm@trexity.de>:

> Hello list,
> 
> where do I get the dvb-usb-dw2104.fw firmware-file for my TeVii S650?
> The driver-package downloadble from the manufacturer website
> ( http://tevii.com/support.html ) only contains dvb-fe-cx24116.fw,
> dvb-usb-s600.fw, and dvb-usb-s600.fw. The manufacturers driver is
> multiproto-based which is not what I want.
> 
> The method described here:
> http://article.gmane.org/gmane.linux.drivers.dvb/44694
> to get the firmware doesn't work anymore, the file has been removed.
> 
> Any hints?
> 
> Thanks in advance,
> Carsten
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I actually meant:
"The driver-package downloadble from the manufacturer website
> ( http://tevii.com/support.html ) only contains dvb-fe-cx24116.fw,
> dvb-usb-s600.fw, and dvb-usb-s650.fw" (650 not 600)

I've found this thread:
http://www.allrussian.info/thread.php?postid=1460227
Because I cannot speak any russian, I've auto-translated it with
google. Am I right that it suggests to simply rename dvb-usb-s650.fw
from the manufacturer to dvb-usb-dw2104.fw?

Thanks,
Carsten

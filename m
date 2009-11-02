Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZKBJgq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 04:36:46 -0500
Message-ID: <4AEEA838.8080006@tripleplay-services.com>
Date: Mon, 02 Nov 2009 09:36:56 +0000
From: Lou Otway <louis.otway@tripleplay-services.com>
MIME-Version: 1.0
To: Michael Durket <durket@rlucier-home2.stanford.edu>
CC: linux-media@vger.kernel.org
Subject: Re: DVB-S2 card recommendation?
References: <D2EBA0C6-9E47-4473-935E-4CF96553AB29@rlucier-home2.stanford.edu>
In-Reply-To: <D2EBA0C6-9E47-4473-935E-4CF96553AB29@rlucier-home2.stanford.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Durket wrote:
> Is there a DVB-S2 card on the market yet with these features:
>
>     1) DVB-S2 (QPSK, 8PSK) and DVB-S modes fully supported in Linux
>         (i.e. not experimental, not requiring sifting through 
> different driver sources
>         to try to find one that works)
>
>     2) Has no software/hardware data rate limitations (i.e. all symbol 
> rates supported, no problems locking
>         any symbol rate the card supports)
>
>     3) Available to U.S. purchasers (no country restrictions when 
> trying to buy the card)
>
>     4) Delivers a full transport stream without filtering of any kind 
> by the hardware.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
I've been using the Turbosight TBS6920 for a while now, with very good 
results. It's a PCI device based on the Conexant CX23885 chipset. I'm 
pretty sure it meets all your requirements.

I've also used the TechnoTrend TT-S3200 which is PCI based but there do 
appear some problems with some of the more exotic symbol rates. I've 
used a patch to support high symbol rates but my question as to the 
safety of doing this remains unanswered. There should be a new S2 card 
from TechnoTrend, the TT-S6400 but it has been delayed since early in 
the year and who knows if it will ever see the light of day.

All the best,

Lou





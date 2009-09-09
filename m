Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53610 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbZIIR5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2009 13:57:15 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MlRPq-0002Xv-9o
	for linux-media@vger.kernel.org; Wed, 09 Sep 2009 19:57:10 +0200
Received: from 204.50.17.95.dynamic.jazztel.es ([204.50.17.95.dynamic.jazztel.es])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 19:57:10 +0200
Received: from eduardhc by 204.50.17.95.dynamic.jazztel.es with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 19:57:10 +0200
To: linux-media@vger.kernel.org
From: Eduard Huguet <eduardhc@gmail.com>
Subject: Re: Nova-T 500 Dual DVB-T and h.264
Date: Wed, 9 Sep 2009 17:56:47 +0000 (UTC)
Message-ID: <loom.20090909T195347-576@post.gmane.org>
References: <4AA7AE23.2040601@nildram.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lou Otway <lotway <at> nildram.co.uk> writes:

> 
> Hi,
> 
> Does anyone have experience of using the Hauppuage Nova-T 500 with DVB-T 
> broadcasts with h.264 and AAC audio?
> 
> DTT in New Zealand uses these formats and I'm seeing poor performance 
> from the Nova-T card. My thinking is that it was probably not conceived 
> for dealing with dual h264 streams.
> 
> Has the PCIe HVR-2200 been tested with dual h.264? I was wondering if 
> this card might have better performance.
> 
> Thanks,
> 
> Lou
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Hi, 
    AFAIK the card just tunes to the desired frequency, applies configured
filters (to select the desired station through its PID number), and handles the
received transport stream to the calling application. It's up to the lastest to
properly decode it. Check that the software you are using is properly capable of
decoding this kind of content.

Best regards, 
  Eduard Huguet





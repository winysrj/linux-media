Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41811 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbeCNPLu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 11:11:50 -0400
Message-ID: <1521040308.4490.10.camel@pengutronix.de>
Subject: Re: [CN] Re: [DE] Re: coda: i.MX6 decoding performance issues for
 multi-streaming
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Javier Martin <javiermartin@by.com.es>,
        linux-media <linux-media@vger.kernel.org>
Date: Wed, 14 Mar 2018 16:11:48 +0100
In-Reply-To: <2df2ad29-6173-08ea-e0d1-bf54c93ee456@by.com.es>
References: <c18549be-d55e-54d2-1524-1c51d05807ec@by.com.es>
         <1520940054.3965.10.camel@pengutronix.de>
         <dfd0fe98-4e5e-bc28-c325-6c52f1964a03@by.com.es>
         <1521035853.4490.7.camel@pengutronix.de>
         <2df2ad29-6173-08ea-e0d1-bf54c93ee456@by.com.es>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Wed, 2018-03-14 at 15:35 +0100, Javier Martin wrote:
[...]
> The encoder is running on a different system with an older 4.1.0 kernel. 
> Altough the firmware version in the code is 3.1.1 as well.
> 
> Do you think I should try updating the system in the encoder to kernel 
> 4.15 too and see if that makes any difference?

I don't think that should matter. It'd be more interesting if GOP size
has a significant influence. Does the Problem also appear in I-frame
only streams?

regards
Philipp

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f107.google.com ([209.85.221.107]:54236 "EHLO
	mail-qy0-f107.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZDPIUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 04:20:38 -0400
Received: by qyk5 with SMTP id 5so286634qyk.33
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2009 01:20:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090415100642.GA2895@www.viadmin.org>
References: <20090411221740.GB12581@www.viadmin.org>
	 <20090412175352.GC12581@www.viadmin.org>
	 <49E4B07A.4030205@metatux.net> <20090415100642.GA2895@www.viadmin.org>
Date: Thu, 16 Apr 2009 18:14:35 +1000
Message-ID: <e4e86fbf0904160114u37badea2ucf4047c893f9d0d2@mail.gmail.com>
Subject: Re: [linux-dvb] DVB-T USB dib0700 device recomendations?
From: covert covert <thecovert@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> Thats wierd. So the usb controler on the Nova-TD and the host controler on
> the SB700 are incompatible?
>

I tried a few different USB tuners with a SB700 based motherboard
until I found out the drivers where not up to scratch for the USB on
the SB700 and caused a lot of "dvb-usb: bulk message failed"

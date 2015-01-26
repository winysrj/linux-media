Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33825 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653AbbAZVFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 16:05:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1YFqqF-0006tX-L4
	for linux-media@vger.kernel.org; Mon, 26 Jan 2015 22:05:03 +0100
Received: from or-71-0-52-80.sta.embarqhsd.net ([71.0.52.80])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 22:05:03 +0100
Received: from v4l by or-71-0-52-80.sta.embarqhsd.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 22:05:03 +0100
To: linux-media@vger.kernel.org
From: David Harty <v4l@dharty.com>
Subject: Re: Hauppage HVR-2250 - No Free Sequences
Date: Mon, 26 Jan 2015 20:40:51 +0000 (UTC)
Message-ID: <loom.20150126T212905-538@post.gmane.org>
References: <CACsaVZLs6-iypj1ZU13iVqBdNWY63NCt3f_+SqdpaLjqupPiNQ@mail.gmail.com> <CACsaVZKJm-oxOKCsiqp-w4TGCiL91okjyi7d3F0O1i0E47KCeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kyle Sanderson <kyle.leet <at> gmail.com> writes:

> >
> > [585870.001641] saa7164_cmd_send() No free sequences
> > [585870.001645] saa7164_api_i2c_write() error, ret(1) = 0xc
> > [585870.001650] tda10048_writereg: writereg error (ret == -5)
> >
> > Any tips? I've tried a couple horrible kernel patches but didn't get
anywhere.
> > Kyle.
> 


I simply wanted to add the I have also started seeing this error recently so
Kyle is not alone in this.

I have tried combinations of all of the firmwares on the steventoth site in
conjunction with the saa7164 driver in the vanilla 3.11.10-25 kernel.

It requires a reboot to effectively reload the firmware.

Regards,



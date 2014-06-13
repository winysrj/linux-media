Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56704 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbaFMIw0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 04:52:26 -0400
Date: Fri, 13 Jun 2014 10:52:32 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Jason.Dong@ite.com.tw, tephra@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: AF9033 / IT913X: Avermedia A835B(1835) only works sporadically
Message-ID: <20140613085232.GB12672@wolfgang>
References: <20140610125059.GA1930@wolfgang>
 <97D30D57D08C2C49A26A3312F17290483B008B5E@TPEMAIL2.internal.ite.com.tw>
 <CAM187nBbeZJyG-4K+N4nicaYjcvrgXB5u10J7gHOp=xrbO9Bkg@mail.gmail.com>
 <97D30D57D08C2C49A26A3312F17290483B008D96@TPEMAIL2.internal.ite.com.tw>
 <539A1B5A.60804@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539A1B5A.60804@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 13, 2014 at 12:27:54AM +0300, Antti Palosaari wrote:
> Moikka,
> 
> The reason is that Avermedia has programmed wrong tuner ID to device
> eeprom. For one IT9135BX device I have it is set 0x38 (whilst Windows
> driver programs 0x60), no idea how others. That same issues was for
> AF9015 too, where I added USB ID based overrides for certain Avermedia
> models. I think I will do same for AF9035 driver.

Hello Antti,

Thank you for the patch. Problem solved.

I checked with both versions 3.42.3.3 and 3.39.1.0 of
dvb-usb-it9135-02.fw. With 3.39.1.0 I usually get some blocks when
zapping (they disappear after a short while when staying on the same
channel). With 3.42.3.3 I don't have this issue. Looks like 3.42.3.3 is
an improvement.

Kind regards,
Sebastian

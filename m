Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43927 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2CLBUH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 21:20:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1S6tvf-0002N7-Lr
	for linux-media@vger.kernel.org; Mon, 12 Mar 2012 02:20:03 +0100
Received: from p4ffe12dc.dip.t-dialin.net ([79.254.18.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2012 02:20:03 +0100
Received: from steve by p4ffe12dc.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2012 02:20:03 +0100
To: linux-media@vger.kernel.org
From: Steve Markgraf <steve@steve-m.de>
Subject: Re: SDR FM demodulation
Date: Mon, 12 Mar 2012 02:09:36 +0100
Message-ID: <jjjicf$n6s$1@dough.gmane.org>
References: <4F33DFB8.4080702@iki.fi> <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com> <4F36632A.3010700@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: <4F36632A.3010700@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11.02.2012 13:46, Antti Palosaari wrote:
> Now someone should make Linux driver that can tune that device to
> different frequencies and look what it really can do.

I sniffed the Windows driver and wrote a small libusb-based program
[1], which can tune to a given frequency and record the I/Q-samples to
a file.

So far FM radio reception with GNU Radio, as well as GMR-1 satellite
(Thuraya) reception [2] at 1,525GHz with 1,8MHz bandwidth have been
tested. Despite the 8 bit ADC, the stick seems to perform quite well.

The program so far supports the "ezcap USB 2.0 DVB-T/DAB/FM stick" with
the Elonics E4000 tuner, and the "Terratec NOXON DAB/DAB+ USB-Stick"
with the Fitipower FC0013 tuner.

The code is still somewhat hackish and experimental, since not all of
the demodulator registers are known, and especially the tuner setup has
room for improvement.

Regards,
Steve

[1] http://cgit.osmocom.org/cgit/rtl-sdr/
[2] http://gmr.osmocom.org/


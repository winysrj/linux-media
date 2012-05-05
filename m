Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38140 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab2EERCp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 13:02:45 -0400
Message-ID: <1b011124fb0c6b0c11e8fd99bc2d2e37.squirrel@webmail.kapsi.fi>
In-Reply-To: <CAKZ=SG_ZEM7n8Xifeq_GWGfVzJP=6GCdfep0fp=eHyzA7HQ-xw@mail.gmail.com>
References: <4F9E5D91.30503@gmail.com>
    <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com>
    <4F9F8752.40609@gmail.com> <4FA232CE.8010404@gmail.com>
    <4FA249DE.7000702@gmail.com> <4FA33084.7050204@gmail.com>
    <4FA3DE7A.1080709@gmail.com> <4FA47568.5070906@gmail.com>
    <CAKZ=SG_ZEM7n8Xifeq_GWGfVzJP=6GCdfep0fp=eHyzA7HQ-xw@mail.gmail.com>
Date: Sat, 5 May 2012 20:02:42 +0300
From: "Antti Palosaari" <crope@iki.fi>
To: "Thomas Mair" <thomas.mair86@googlemail.com>
Cc: "poma" <pomidorabelisima@gmail.com>, gennarone@gmail.com,
	linux-media@vger.kernel.org, "Antti Palosaari" <crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

la 5.5.2012 19:01 Thomas Mair kirjoitti:
> I am currently finishing up the work at the demod driver and will
> probably send a new version to the list tomorrow.

Nice! I will try to review it on Monday...
I looked quickly your old patch last week and tuner driver was done by
Hans-Frieder Vogt. I think he should send tuner patch first and then your
rtl2832 applied top of that.

> As I don't own a device with a different tuner than the fc0012 I will
> include an error message about the unsupported tuner and print its
> type. So It is easier to get the information about the tuners.

Sounds good.

> Right now I am writing the signal_strength callback and stumbled upon
> the following problem:
> The signal strength is read from the fc0012 tuner (only for fc0012).
> How should the driver implement this situation. Is there a callback I
> could implement within the tuner or should I just read the tuner
> registers from the demodulator?

Demod should report signal strength, normally based IF AGC. But that
estimation is very poor, tuner could report it more accurate.

On optimal situation you should implement demod callback for signal
strength and if there is tuner callback then override demod callback in
order to get better reports. IMHO that override should be done in DVB-USB
driver, in that case dvb-usb-rtl2832u. So when you attach rtl2832u just
after that override demod callback with tuner.

regards
Antti


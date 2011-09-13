Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37523 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab1IMWB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 18:01:26 -0400
Received: by bkbzt4 with SMTP id zt4so963491bkb.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 15:01:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315949644.10987.25.camel@ares>
References: <4E68EE98.90201@iki.fi>
	<4E69EE5E.8080605@rd.bbc.co.uk>
	<4E6FC41A.5030803@iki.fi>
	<1315949644.10987.25.camel@ares>
Date: Tue, 13 Sep 2011 18:01:24 -0400
Message-ID: <CAGoCfiy69Mk6qCtQ0w6CtGsiba+WbZ9isk2y4J4Rh6vNRhOLnQ@mail.gmail.com>
Subject: Re: recursive locking problem
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Kerrison <steve@stevekerrison.com>
Cc: Antti Palosaari <crope@iki.fi>,
	David Waring <davidjw@rd.bbc.co.uk>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 13, 2011 at 5:34 PM, Steve Kerrison <steve@stevekerrison.com> wrote:
> At the risk of sounding silly, why do we rely on i2c gating so much? The
> whole point of i2c is that you can sit a bunch of devices on the same
> pair of wires and talk to one at a time.

Steve,

There are essentially two issues here.  To address the general
question, many tuner chips require an i2c gate because their onboard
i2c controller is implemented using interrupts, and servicing the
interrupts to even check if the traffic is intended for the tuner can
interfere with the core tuning function.  In other words, the cost of
the chip "watching for traffic" can adversely effect tuning quality.
As a result, most hardware designs are such that the demodulator gates
the i2c traffic such that the tuner only *ever* sees traffic intended
for it.

The second issue is that within the LinuxTV drivers there is
inconsistency regarding whether the i2c gate is opened/closed by the
tuner driver or whether it's done by the demod.  Some drivers have the
demod driver open the gate, issue the tuning request, and then close
the gate, while in other drivers the tuner driver opens/closes the
gate whenever there are register reads/writes to the tuner.  It's all
about the granularity of implementation (the demod approach only
involves one open/close but it's for potentially a longer period of
time, versus the tuner approach which opens/closes the gate repeatedly
as needed, which means more open/closes but the gate is open for the
bare minimum of time required).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

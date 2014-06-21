Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f193.google.com ([209.85.223.193]:43075 "EHLO
	mail-ie0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163AbaFUIt2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jun 2014 04:49:28 -0400
Received: by mail-ie0-f193.google.com with SMTP id rd18so1186828iec.8
        for <linux-media@vger.kernel.org>; Sat, 21 Jun 2014 01:49:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 21 Jun 2014 10:49:28 +0200
Message-ID: <CAPGDFHDL51MuNMV2z5kchC906jLqf8FPnC-TyTZwHFjeb7KSOg@mail.gmail.com>
Subject: DVB-T pre amplifier management
From: Tybos SA <sa.tybos@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

When using pre amplifier to improve DVB-T reception, there is a need
for a power supply.
Satellite reception handles power directly in reception device (which
is handled by DVB frontend API) but for DVB-T, these are two separate
things (DVB tuner on one side, power supply on the other) and DVB-T
frontends do not implement SET_VOLTAGE API (at least the ones I've
looked into).

I wondered if there was a way to switch a power supply ON and OFF
depending on tuner usage.
I'm not very familiar with Linux drivers philosophy but would it be
possible to have "composite" frontend (main dvb frontend using tuner
driver + complementary driver to handle power supply if not
implemented by main frontend) ?

Regards,

Tybos

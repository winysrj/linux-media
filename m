Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40860 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1HHRGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 13:06:39 -0400
Received: by ewy4 with SMTP id 4so709939ewy.19
        for <linux-media@vger.kernel.org>; Mon, 08 Aug 2011 10:06:38 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Aug 2011 21:36:38 +0430
Message-ID: <CAPpMX7Sw5bO8fiYq+u_Zdv8BBsS6qahQ0Rw+_CjD+ikXH5-w3g@mail.gmail.com>
Subject: Structure of DiSEqC Command
From: Nima Mohammadi <nima.irt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,
I was reading the source code of various dvb related utilities and I
was wondering about forming up the message which instructs the DiSEqC
switch. But I found out that different programs produce the command
differently.
The confusing thing is that according to the DiSEqC specification
documents that I've read, the least significant bit (lsb) must
indicate the band (low/high), not the polarity (ver/hor), but as you
see it only applies to some of these programs:

getstrean abd dvbstream:
int i = 4 * switch_pos + 2 * hiband + (voltage_18 ? 1 : 0);

szap and mplayer:
(((sat_no * 4) & 0x0f) | (hi_lo ? 1 : 0) | (polv ? 0 : 2));

scan:
4 * switch_pos + 2 * hiband + (voltage_18 ? 1 : 0)

gstdvbsrc:
(((sat_no * 4) & 0x0f) | (tone == SEC_TONE_ON ? 1 : 0) | (voltage ==
SEC_VOLTAGE_13 ? 0 : 2));


-- Nima Mohammadi

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65338 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LTQ0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 11:26:03 -0500
Received: by eekc4 with SMTP id c4so6693190eek.19
        for <linux-media@vger.kernel.org>; Tue, 20 Dec 2011 08:26:02 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL FOR 3.3] HDIC HD29L2 DMB-TH demodulator driver
Date: Tue, 20 Dec 2011 17:25:57 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <4EE929D5.6010106@iki.fi> <4EF0A92B.6010504@redhat.com> <4EF0ACFD.6040903@iki.fi>
In-Reply-To: <4EF0ACFD.6040903@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112201725.57381.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Tuesday 20 December 2011 16:42:53 Antti Palosaari wrote:
> Adding those to API is not mission impossible. Interleaver is only
> new parameter and all the rest are just extending values. But my
> time is limited... and I really would like to finally got Anysee
> smart card reader integrated to USB serial first.

And if it is added we should not forget to discuess whether DMB-TH is 
the "right" name. (If this has already been addressed in another thread 
please point me to it).

I know this standard under at least 2 different names: CTTB and DTMB. 

Which is the one to choose?

best regards,
--
Patrick

Kernel Labs Inc.
http://www.kernellabs.com/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:57154 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaCWUrp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Mar 2014 16:47:45 -0400
Message-ID: <532F486C.9030307@gentoo.org>
Date: Sun, 23 Mar 2014 21:47:40 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] si2165: Add first driver version
References: <1386918133-21628-1-git-send-email-zzam@gentoo.org> <1386918133-21628-3-git-send-email-zzam@gentoo.org> <52BA6B27.2040401@iki.fi> <532DBAC5.5040407@iki.fi>
In-Reply-To: <532DBAC5.5040407@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.03.2014 17:31, Antti Palosaari wrote:
> Moi Matthias
> 
Hi Antti,

> So what is status of your work?
> 
The current status is:
I compared parts of my code to si2161 documentation.
I extracted firmware to an extra file.
I disassembled parts of the windows driver to verify some assumptions.

So the calculations should be almost correct for dvb-t.
But for dvb-c I need some more knowledge or more disassembling to know
how to calculate some register values.

e.g. What is the equivalence to this dvb-t value: DVB_rate = BW * 8/7
I guess it should depend on the symbol rate of the dvb-c channel.

I hope I manage to send out the current state as patches the next days.

Regards
Matthias


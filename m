Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37071 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbbCPW5e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 18:57:34 -0400
Message-ID: <55075FDC.1030507@iki.fi>
Date: Tue, 17 Mar 2015 00:57:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH] rtl2832: PID filter support for slave demod
References: <55075559.50100@southpole.se>
In-Reply-To: <55075559.50100@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/17/2015 12:12 AM, Benjamin Larsson wrote:
> Is this structure ok for the slave pid implementation? Or should there
> be only one filters parameter? Will the overlaying pid filter framework
> properly "flush" the set pid filters ?
>
> Note that this code currently is only compile tested.

I am fine with it.

byw. Have you tested if your QAM256 (DVB-C or DVB-T2) stream is valid 
even without a PID filtering? IIRC mine stream is correct and PID 
filtering is not required (but surely it could be implemented if you wish).

regards
Antti

-- 
http://palosaari.fi/

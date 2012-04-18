Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41352 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab2DRUAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 16:00:49 -0400
Message-ID: <4F8F1D6E.3000705@iki.fi>
Date: Wed, 18 Apr 2012 23:00:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com> <4F804CDC.3030306@gmail.com> <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com> <4F85D787.2050403@iki.fi> <4F85F89A.80107@schinagl.nl> <4F85FE63.1030700@iki.fi> <4F86C66A.4010404@schinagl.nl> <CAKZ=SG8gHbnRGFrajp2=Op7x52UcMT_5CFM5wzgajKCXkggFtA@mail.gmail.com> <4F86CE09.3080601@schinagl.nl> <CAKZ=SG95OA3pOvxM6eypsNaBvzX1wfjPR4tucc8725bnhE3FEg@mail.gmail.com> <4F86D4B8.8060005@iki.fi> <CAKZ=SG8G8w1J_AF-bOCn2n8gcEogGPQ1rmp45wCtmwFgOUPifA@mail.gmail.com> <4F8EFD7B.2020901@iki.fi> <CAKZ=SG8=z6c4-n8wkMK1YmTzWs9rN9JrbM907+K+X0k4ampSJA@mail.gmail.com> <4F8F0975.10605@iki.fi>
In-Reply-To: <4F8F0975.10605@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.04.2012 21:35, Antti Palosaari wrote:
> The method should be selected based of knowledge if GPIO used for
> controlling FC0012 tuner OR controlling some other part (LNA, anatenna
> switch, etc.) So you have to identify meaning first. Look inside FC0012
> driver to see if there is some mention about that GPIO.

It is tuner VHF/UHF filter(?). You should use frontend callback with 
DVB_FRONTEND_COMPONENT_TUNER and add handler for it. See example from 
FC0011 & AF9035.

regards
Antti
-- 
http://palosaari.fi/

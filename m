Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60880 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbZL3Ucz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 15:32:55 -0500
Message-ID: <4B3BB8EF.7020103@iki.fi>
Date: Wed, 30 Dec 2009 22:32:47 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?Tm92w6FrIExldmVudGU=?= <lnovak@dragon.unideb.hu>
CC: linux-media@vger.kernel.org
Subject: Re: AverMedia A577 (cx23385, xc3028, af9013)
References: <1262203922.13686.36.camel@szisz-laptop>
In-Reply-To: <1262203922.13686.36.camel@szisz-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/30/2009 10:12 PM, Novák Levente wrote:
> cx23885 (PCIe A/V decoder)
> xc3028  (hybrid tuner)
> af9013  (demod)
>
> all of these individual chips are already supported under Linux, only
> the "glue" is missing between them, I think.

Yes. Also some code changes for af9013 could be needed. There is no any 
af9013 device currently supported, only af9015 which integrates af9013.

> I would like to ask for help, what is the next step I should take in
> order to make this card work?

Take USB sniff, parse it and comment out data flow command by command. 
Look meaning of those bytes from existing drivers. Then use debugs to 
see data flow is correct.

Antti
-- 
http://palosaari.fi/

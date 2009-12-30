Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-mail.opticon.hu ([85.90.160.75]:48838 "EHLO
	mx-mail.opticon.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbZL3Uvz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 15:51:55 -0500
Subject: Re: AverMedia A577 (cx23385, xc3028, af9013)
From: =?ISO-8859-1?Q?Nov=E1k?= Levente <lnovak@dragon.unideb.hu>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B3BB8EF.7020103@iki.fi>
References: <1262203922.13686.36.camel@szisz-laptop>
	 <4B3BB8EF.7020103@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 21:51:51 +0100
Message-ID: <1262206311.13686.38.camel@szisz-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009. 12. 30, szerda keltezéssel 22.32-kor Antti Palosaari ezt írta:
> On 12/30/2009 10:12 PM, Novák Levente wrote:
> > cx23885 (PCIe A/V decoder)
> > xc3028  (hybrid tuner)
> > af9013  (demod)
> >
> > all of these individual chips are already supported under Linux, only
> > the "glue" is missing between them, I think.
> 
> Yes. Also some code changes for af9013 could be needed. There is no any 
> af9013 device currently supported, only af9015 which integrates af9013.
> 

Ah, I thought af9013 is already supported.

> > I would like to ask for help, what is the next step I should take in
> > order to make this card work?
> 
> Take USB sniff, parse it and comment out data flow command by command. 
> Look meaning of those bytes from existing drivers. Then use debugs to 
> see data flow is correct.

OK, but this card is not USB but ExpressCard.

Levente



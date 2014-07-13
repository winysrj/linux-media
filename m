Return-path: <linux-media-owner@vger.kernel.org>
Received: from champagne.papayaltd.net ([82.129.38.126]:35032 "EHLO
	www.n4tv.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaGMLNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jul 2014 07:13:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by www.n4tv.org.uk (Postfix) with ESMTP id 74F50820EF
	for <linux-media@vger.kernel.org>; Sun, 13 Jul 2014 12:13:35 +0100 (BST)
Received: from www.n4tv.org.uk ([127.0.0.1])
	by localhost (ch.dinkum.org.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u3RvTxGN6AEM for <linux-media@vger.kernel.org>;
	Sun, 13 Jul 2014 12:13:33 +0100 (BST)
Received: from 145.129.187.81.in-addr.arpa (145.129.187.81.in-addr.arpa [81.187.129.145])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: andre)
	by www.n4tv.org.uk (Postfix) with ESMTPSA id B0C98820ED
	for <linux-media@vger.kernel.org>; Sun, 13 Jul 2014 12:13:33 +0100 (BST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: PCTV T292e whole DVBT2 mux/Ultra HD performance question
From: Andre Newman <linux-media@dinkum.org.uk>
In-Reply-To: <53BD95A3.2050509@iki.fi>
Date: Sun, 13 Jul 2014 12:13:33 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D6115C9F-E9B7-4E74-91E4-3F6492218ABD@dinkum.org.uk>
References: <35906397-E8F4-4229-966F-7ED578441C10@dinkum.org.uk> <53BD95A3.2050509@iki.fi>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 9 Jul 2014, at 20:18, Antti Palosaari <crope@iki.fi> wrote:

> Moikka
> 
> 
> On 07/09/2014 04:14 PM, Andre Newman wrote:
>> I’m using a T290e for whole mux DVBT2 capture, using this to record the current BBC World Cup Ultra HD tests, works well. :-)
>> 
>> It seems impossible to buy more T290e’s, everyone want to sell me a T292e, I understand there is a driver now, thanks Antti. I read on Antti’s blog that there is a limit on raw TS performance with the T292, that it didn’t work well with QAM256 because of this...
>> 
>> I am wondering if this is a hardware limit, or a performance problem that may have been resolved now the driver is a little tiny bit more mature?
>> 
>> I am very happy to get a T292e and make some tests, help debug if there is a hope that it can handle 40Mbps in hardware.If there is a hardware limit I’d rather not be stuck with a limited tuner!
>> 
>> The mux I need to record is QAM256 at ~40Mbps and the UHD video is ~36Mbps of this.
>> 
>> Otherwise what other DVBT2 tuners are there that can capture a raw QAM256 mux at 40Mbps?
> 
> You simply confused two different devices. There is no such limit on PCTV 292e as far as I know. It is another DVB-T2 device having RTL2832P bridge having problem with stream bandwidth.

And just for the record, as Google seems to find this page first for any mention of the PCTV T292e:

I have a T292e now and it records a full DVBT2 mux at ~40Mbps with no problem at all. I’m using Ubuntu 14.04 with yesterday's media_build script. 

Thanks again to Antti and anyone else working on this driver.

Andre




> 
> regards
> Antti
> 
> 
> -- 
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


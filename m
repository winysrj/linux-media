Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47839 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZBSTlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 14:41:47 -0500
Message-ID: <499DB5B7.8080802@s5r6.in-berlin.de>
Date: Thu, 19 Feb 2009 20:40:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	Christian Dolzer <c.dolzer@digital-everywhere.com>,
	Andreas Monitzer <andy@monitzer.com>,
	Manu Abraham <manu@linuxtv.org>,
	Fabio De Lorenzo <delorenzo.fabio@gmail.com>,
	Robert Berger <robert.berger@reliableembeddedsystems.com>,
	Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>,
	Rambaldi <Rambaldi@xs4all.nl>
Subject: Re: [review patch 0/1] add firedtv driver for FireWire-attached DVB
 receivers
References: <tkrat.265ed076d414bd49@s5r6.in-berlin.de>	<tkrat.63c8bdca2465364b@s5r6.in-berlin.de> <20090217102951.21dab08c@pedra.chehab.org>
In-Reply-To: <20090217102951.21dab08c@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> The driver looks sane to my eyes. I found just one minor issue (see bellow).
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Thanks for checking.

>> +
>> +		/*
>> +		 * AV/C specs say that answers should be sent within 150 ms.
>> +		 * Time out after 200 ms.
>> +		 */
>> +		if (wait_event_timeout(fdtv->avc_wait,
>> +				       fdtv->avc_reply_received,
>> +				       HZ / 5) != 0) {
> 
> Instead of using HZ, it would be better to use:
> 	msecs_to_jiffies(200)

OK, I switch this.

(Hmm, what if msecs_to_jiffies could be rolled out to a constant
expression if called on a constant argument...?)
-- 
Stefan Richter
-=====-==--= --=- =--==
http://arcgraph.de/sr/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35864 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab3AOI42 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 03:56:28 -0500
Message-ID: <50F51994.1030703@iki.fi>
Date: Tue, 15 Jan 2013 10:55:48 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com> <20130115082008.GA30007@linuxtv.org>
In-Reply-To: <20130115082008.GA30007@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2013 10:20 AM, Johannes Stezenbach wrote:
> On Tue, Jan 15, 2013 at 12:30:46AM -0200, Mauro Carvalho Chehab wrote:
>> Add DVBv5 methods to retrieve QoS statistics.
>
> According to http://en.wikipedia.org/wiki/Qos:
> "Quality of service in computer network trafficking refers
> to resource reservation control mechanisms"
>
> I think it is misleading to use the term QoS for DVB, what
> the patch series seems to be about is receiption or signal quality.

I totally agree that (and I have used name signal statistics).

regards
Antti

-- 
http://palosaari.fi/

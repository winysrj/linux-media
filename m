Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60697 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab3BST7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 14:59:01 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so3666550eek.34
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2013 11:59:00 -0800 (PST)
Message-ID: <5123D93E.9050602@gmail.com>
Date: Tue, 19 Feb 2013 20:57:50 +0100
From: =?UTF-8?B?R2HDq3RhbiBDYXJsaWVy?= <gcembed@gmail.com>
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: linux-media@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Rob Herring <rob.herring@calxeda.com>
Subject: Re: coda: support of decoding
References: <5122D999.3070405@gmail.com> <20130219184749.GD30071@pengutronix.de>
In-Reply-To: <20130219184749.GD30071@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
On 02/19/2013 07:47 PM, Robert Schwebel wrote:
> On Tue, Feb 19, 2013 at 02:47:05AM +0100, Gaëtan Carlier wrote:
>> I see in code source of coda driver that decoding is not supported.
>>
>> ctx->inst_type = CODA_INST_DECODER;
>> v4l2_err(v4l2_dev, "decoding not supported.\n");
>> return -EINVAL;
>>
>> Is there any technical reason or the code has not been written ?
>
> We have a lot of encoder + decoder patches for Coda in the queue, but
> unfortunately not all of that is ready-for-primetime yet.
MX27. I have not yet tested if encoding is working or not.
Where can I find this set of patches ? I will test it with pleasure.
>
> Which processor are you interested in? MX27 or MX5/MX6?
>
> rsc
>
Thank you.
Best regards,
Gaëtan Carlier.

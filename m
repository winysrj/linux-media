Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3368 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaIVJw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 05:52:57 -0400
Message-ID: <541FF16A.9060902@xs4all.nl>
Date: Mon, 22 Sep 2014 11:52:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: James Harper <james@ejbdigital.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: buffer delivery stops with cx23885
References: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com> <541D469B.4000306@xs4all.nl> <609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5220.4050107@xs4all.nl> <a349a970f1d445538b52eb4d0e98ee2c@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5CD0.1000207@xs4all.nl> <9cc65ceabd05475d89a92c5df04cc492@SIXPR04MB304.apcprd04.prod.outlook.com> <541D61D7.3080202@xs4all.nl> <d1c6567fa03c4e27ba5534514a762631@SIXPR04MB304.apcprd04.prod.outlook.com> <59dd9f7eb4414e3e8683e52c559a8c45@SIXPR04MB304.apcprd04.prod.outlook.com> <e0f1371641b2497f9d3e91c9605702ec@HKXPR04MB295.apcprd04.prod.outlook.com> <541FDFB4.6070201@xs4all.nl> <01776abac53640498b8fc87ac8d36fd1@HKXPR04MB295.apcprd04.prod.outlook.com>
In-Reply-To: <01776abac53640498b8fc87ac8d36fd1@HKXPR04MB295.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/22/2014 11:46 AM, James Harper wrote:
>>
>>>
>>> Any hints on what I can do to figure out what layer it's stalling at?
>>
>> I have no idea. I would do a git bisect to try and narrow it down.
>>
> 
> Problem with the bisect is that I can't be sure what version it actually worked on. It certainly predates when my patch for my card was committed.
> 
> I have a hunch that it might be the two tuners stomping on each other, possibly in the i2c code. Sometimes recording just stops, other times I get i2c errors.

Is that two tuners in the same device, or two tuners in different devices?

	Hans

> 
> With one tuner disabled in MythTV I can't seem to reproduce the problem anymore. I haven't let it run for long enough to be sure, but it normally would have crashed by now.
> 
> James


Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1888 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaIVIhX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 04:37:23 -0400
Message-ID: <541FDFB4.6070201@xs4all.nl>
Date: Mon, 22 Sep 2014 10:37:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: James Harper <james@ejbdigital.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: buffer delivery stops with cx23885
References: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com> <541D469B.4000306@xs4all.nl> <609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5220.4050107@xs4all.nl> <a349a970f1d445538b52eb4d0e98ee2c@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5CD0.1000207@xs4all.nl> <9cc65ceabd05475d89a92c5df04cc492@SIXPR04MB304.apcprd04.prod.outlook.com> <541D61D7.3080202@xs4all.nl> <d1c6567fa03c4e27ba5534514a762631@SIXPR04MB304.apcprd04.prod.outlook.com> <59dd9f7eb4414e3e8683e52c559a8c45@SIXPR04MB304.apcprd04.prod.outlook.com> <e0f1371641b2497f9d3e91c9605702ec@HKXPR04MB295.apcprd04.prod.outlook.com>
In-Reply-To: <e0f1371641b2497f9d3e91c9605702ec@HKXPR04MB295.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/22/2014 10:30 AM, James Harper wrote:
>>
>> I'll test out the downgrade to 73d8102298719863d54264f62521362487f84256
>> just to be sure, then see if I can take it further back.
>>
> 
> 73d8102298719863d54264f62521362487f84256 still breaks for me, so it's definitely not related to the conversion.

Good.

> 
> Any hints on what I can do to figure out what layer it's stalling at?

I have no idea. I would do a git bisect to try and narrow it down.

Regards,

	Hans

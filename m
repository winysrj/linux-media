Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22045 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab2DCOMQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 10:12:16 -0400
Message-ID: <4F7B053B.9@linux.intel.com>
Date: Tue, 03 Apr 2012 17:12:11 +0300
From: David Cohen <david.a.cohen@linux.intel.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: Reduce number of retries
References: <20120403110503.392c8432@milhouse> <4F7AC9B8.50200@linux.intel.com> <20120403120712.14fea16f@milhouse>
In-Reply-To: <20120403120712.14fea16f@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/2012 01:07 PM, Michael Büsch wrote:
> On Tue, 03 Apr 2012 12:58:16 +0300
> David Cohen<david.a.cohen@linux.intel.com>  wrote:
>>> -	while (!(vco_cal&   FC11_VCOCAL_OK)&&   vco_retries<   6) {
>>> +	while (!(vco_cal&   FC11_VCOCAL_OK)&&   vco_retries<   3) {
>>
>> Do we need to retry at all?
>
> It is not an i2c retry. It retries the whole device configuration operation
> after resetting it.
> I shouldn't have mentioned i2c in the commit log, because this really only was
> a side effect.
>

Hm, got it. :)

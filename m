Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:49576 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1JZT6e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 15:58:34 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9QJwWqw022764
	for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 15:58:33 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 626791E01A6
	for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 15:58:32 -0400 (EDT)
Message-ID: <4EA86668.6090508@lockie.ca>
Date: Wed, 26 Oct 2011 15:58:32 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: femon signal strength
References: <4EA78E3C.2020308@lockie.ca> <CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com> <4EA86366.1020906@lockie.ca> <CAGoCfiww_5pF_S3M_mpN4gk1qqLYn7H7PPcieZXZNnjvK-RHHA@mail.gmail.com>
In-Reply-To: <CAGoCfiww_5pF_S3M_mpN4gk1qqLYn7H7PPcieZXZNnjvK-RHHA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/26/11 15:49, Devin Heitmueller wrote:
> On Wed, Oct 26, 2011 at 3:45 PM, James<bjlockie@lockie.ca>  wrote:
>> How many different formats are there (do I have to go through the archive)?
>> Would it be feasable to change femon to handle different formats?
> There are three or four common formats, and there is no real way for
> an application to know which format was used unless it perhaps
> hard-codes some table of demodulator driver names into the source
> (which by the way will cause breakage if efforts are made to change
> the demods to use a common format).
>
> Devin
>
I was thinking of a table. :-)

How about adding switches to femon, it won't be automatic?

I'm going to make femon work for my card, anyways. :-)


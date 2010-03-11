Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:42468 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab0CKOWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 09:22:43 -0500
Received: by gxk9 with SMTP id 9so50684gxk.8
        for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 06:22:42 -0800 (PST)
Message-ID: <4B98FABB.1040605@gmail.com>
Date: Thu, 11 Mar 2010 11:14:19 -0300
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	hdegoede@redhat.com,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: v4l-utils: i2c-id.h and alevt
References: <201003090848.29301.hverkuil@xs4all.nl> <1268197457.3199.17.camel@pc07.localdom.local>
In-Reply-To: <1268197457.3199.17.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2010 02:04 AM, hermann pitton wrote:
> Hi Hans, both,
> 
> Am Dienstag, den 09.03.2010, 08:48 +0100 schrieb Hans Verkuil:
>> It's nice to see this new tree, that should be make it easier to develop
>> utilities!
>>
>> After a quick check I noticed that the i2c-id.h header was copied from the
>> kernel. This is not necessary. The only utility that includes this is v4l2-dbg
>> and that one no longer needs it. Hans, can you remove this?
>>
>> The second question is whether anyone would object if alevt is moved from
>> dvb-apps to v4l-utils? It is much more appropriate to have that tool in
>> v4l-utils.
> 
> i wonder that this stays such calm, hopefully a good sign.
> 
> In fact alevt analog should come with almost every distribution, but the
> former alevt-dvb, named now only alevt, well, might be ok in some
> future, is enhanced for doing also dvb-t-s and hence there ATM.
> 
>> Does anyone know of other unmaintained but useful tools that we might merge
>> into v4l-utils? E.g. xawtv perhaps?
> 
> If for xawtv could be some more care, ships also since close to ever
> with alevtd, that would be fine, but I'm not sure we are talking about
> tools anymore in such case, since xawtv4x, tvtime and mpeg4ip ;) for
> example are also there and unmaintained.
> 

I think would be nice to hear a word from Devin, which have been working in tvtime. Devin?

Cheers
Douglas


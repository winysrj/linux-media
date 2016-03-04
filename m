Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47059 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbcCDLL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 06:11:57 -0500
Subject: Re: tw686x driver
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
 <56D7E87B.1080505@xs4all.nl> <m3lh5zohsf.fsf@t19.piap.pl>
 <56D83E16.1010907@xs4all.nl> <m3h9gnod3t.fsf@t19.piap.pl>
 <56D84CA7.4050800@xs4all.nl> <m3d1raojqq.fsf@t19.piap.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D96D77.4060707@xs4all.nl>
Date: Fri, 4 Mar 2016 12:11:51 +0100
MIME-Version: 1.0
In-Reply-To: <m3d1raojqq.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/2016 07:11 AM, Krzysztof Hałasa wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>>> Staging is meant for completely different situation - for immature,
>>> incomplete code. It has nothing to do with the case.
>>
>> It can be for anything that prevents it from being mainlined. It was (still is?)
>> used for mature android drivers, for example.
> 
> What is preventing my driver from being mainlined?

I have two drivers with different feature sets. Only one can be active
at a time. I have to make a choice which one I'll take and Ezequiel's
version has functionality (audio, interlaced support) which matches best
with existing v4l applications and the typical use cases. I'm not going
to have two drivers for the same hw in the media subsystem since only
one can be active anyway. My decision, although Mauro can of course decide
otherwise.

I am OK with adding your driver to staging in the hope that someone will
merged the functionalities of the two to make a new and better driver.

Whether that means that Ezequiel's code is merged into yours or vice versa,
I really don't care.

My goal is to provide the end-user with the best experience, and this is
IMHO the best option given the hand I've been dealt.

I ordered a tw6869-based PCIe card so I can do testing myself once it has
arrived.

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38629 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbcCCNhV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 08:37:21 -0500
Subject: Re: tw686x driver
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
 <56D7E87B.1080505@xs4all.nl> <m3lh5zohsf.fsf@t19.piap.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D83E16.1010907@xs4all.nl>
Date: Thu, 3 Mar 2016 14:37:26 +0100
MIME-Version: 1.0
In-Reply-To: <m3lh5zohsf.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/16 13:41, Krzysztof Hałasa wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> When a driver is merged for the first time in the kernel it is always as
>> a single change, i.e. you don't include the development history as that
>> would pollute the kernel's history.
> 
> We don't generally add new drivers with long patch series, that's right.
> That's because there is usually no reason to do so. This situation is
> different, there is a very good reason.
> 
> I'm not asking for doing this with a long patch set. A single patch from
> me + single patch containing the Ezequiel changes would suffice.
> 
>> Those earlier versions have never
>> been tested/reviewed to the same extent as the final version
> 
> This is not a real problem, given the code will be changed immediately
> again.
> 
>> and adding
>> them could break git bisect.
> 
> Not really. You can apply the version based on current media tree,
> I have posted it a week ago or so. This doesn't require any effort.
> 
> BTW applying the thing in two consecutive patches (the old version +
> changes) doesn't break git bisect at all. It only breaks the compiling,
> and only in the very case when git bisect happens to stop between the
> first and second patch, and the driver is configured in. Very unlikely,
> though the remedy is very easy as shown in "man git-bisect".
> This is a common thing when you do git bisect, though the related
> patches are usually much more distant and thus the probability that the
> kernel won't compile is much much greater.
> 
> Alternatively one could apply the original version to an older kernel and
> merge the product. Less trivial and I don't know why one would want to
> do so, given #1.
> 
> One could also disable the CONFIG_VIDEO_TW686X in Kconfig (at the
> original patch). Possibilities are endless.
> 
> We have to face it: there is absolutely no problem with adding the
> driver with two patches, either using my original patch or the updated
> one. And it doesn't require any effort, just a couple of git commands.
> 
>> It is a quite unusual situation and the only way I could make it worse would
>> by not merging anything.
> 
> Not really.
> There is a very easy way out. You can just add the driver properly with
> two patches.
> 
> 
> Though I don't know why do you think my driver alone doesn't qualify to
> be merged (without subsequent Ezequiel's changes). It's functional
> and stable, and I have been using it (in various versions) for many
> months. It's much more mature than many other drivers which make it to
> the kernel regularly.
> 
> It is definitely _not_ my driver that is problematic.
> 

There is no point whatsoever in committing a driver and then replacing it
with another which has a different feature set. I'm not going to do that.

One option that might be much more interesting is to add your driver to
staging with a TODO stating that the field support should be added to
the mainline driver. So the code is there and having it in staging makes
it a bit easier to do the migration. And if nothing is done about it
after 1-2 years, then it is removed again since that indicates that there
is not enough interest in the features specific to your driver version.

I'm not sure if Mauro would go for it, but I think this is a fair option.

Regards,

	Hans

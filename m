Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37812 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab2EUQO0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 12:14:26 -0400
Message-ID: <6dc3e929311568a87d15350a3756af7c.squirrel@webmail.kapsi.fi>
In-Reply-To: <4FBA5140.1060102@redhat.com>
References: <201205062256.55468.hfvogt@gmx.net> <4FB92224.2010008@iki.fi>
    <4FB9A7B3.1030605@redhat.com>
    <48b2cb9f19b1063eb7b8d8bd8dbfc957.squirrel@webmail.kapsi.fi>
    <4FBA5140.1060102@redhat.com>
Date: Mon, 21 May 2012 19:14:19 +0300
From: "Antti Palosaari" <crope@iki.fi>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"Hans-Frieder Vogt" <hfvogt@gmx.net>, linux-media@vger.kernel.org,
	"Thomas Mair" <thomas.mair86@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Re: [PATCH 2/3] fc001x: tuner driver for FC0012, version 0.5
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ma 21.5.2012 17:29 Mauro Carvalho Chehab kirjoitti:
> Em 21-05-2012 00:16, Antti Palosaari escreveu:
>> ma 21.5.2012 5:25 Mauro Carvalho Chehab kirjoitti:
>>> Em 20-05-2012 13:56, Antti Palosaari escreveu:
>>>> Hmm,
>>>> Mauro just merged those FC0012 and FC0013 drivers via my RTL2831U
>>>> tree... It was not my meaning to do that like this.
>>>
>>> This was due to a pull request that you sent me on May, 18, requesting
>>> to pull from:
>>>
>>>   git://linuxtv.org/anttip/media_tree.git rtl2831u
>>
>> http://www.spinics.net/lists/linux-media/msg47992.html
>>
>> I asked to pull last 6 patches. There was few other patches bottom of
>> that
>> due to fact it is always some extra work to jump from tree to other,
>> sync
>> and resolve compilation issues. Those tuner patches were there because I
>> tested and reviewed rtl2832 driver multiple times and tuners were needed
>> for the rtl2832.
>
> Please, don't apply patches you don't intend to go upstream on a branch
> that
> you request me to pull. As I said several times, my import scripts won't
> check
> if the patches match the diffstat of the pull request.
>
> I may eventually add such check on day, but, in that case, what I would do
> is
> to simply reject pull requests with wrong diffstats, as other any logic
> would be
> too complex to implement, as a pull request doesn't contain changeset
> hashes,
> and sometimes the same patch name might be used on two separate changesets
> (this
> is a bad practice, but I've seen it some times).
>
> With regard to the merged patches, if they are really broken, please
> submit
> me a patch removing them.

They are not broken mean of broken. Let those be as it is now and apply
fixes top of that.

regards
Antti


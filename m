Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62328 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3ADFiC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 00:38:02 -0500
Received: by mail-ob0-f182.google.com with SMTP id 16so14328754obc.41
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 21:38:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7C2qiGFc2CaVGaVFwe3kQ697ME2uCpjEF8e5yJhbrt5sKOAA@mail.gmail.com>
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
	<CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
	<20130101130041.52dee65f@redhat.com>
	<CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com>
	<20130101152932.3873d4cc@redhat.com>
	<CAHFNz9LzBX0G9G0G_6C+WHooaQ1ridG1pkCcOPyzPG+FgOZKxw@mail.gmail.com>
	<20130103112044.4267b274@redhat.com>
	<50E5A142.2090807@tvdr.de>
	<20130103141429.03766540@redhat.com>
	<20130103142959.3d838015@redhat.com>
	<50E5F93D.1000302@iki.fi>
	<CAA7C2qiGFc2CaVGaVFwe3kQ697ME2uCpjEF8e5yJhbrt5sKOAA@mail.gmail.com>
Date: Fri, 4 Jan 2013 11:00:31 +0530
Message-ID: <CAHFNz9KiaHbypyDGSAy+FktF6ALXtLFJ6DKyV1R7Bzu8xd-NLA@mail.gmail.com>
Subject: Re: [linux-media] Re: [PATCH RFCv3] dvb: Add DVBv5 properties for
 quality parameters
From: Manu Abraham <abraham.manu@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 4, 2013 at 10:33 AM, VDR User <user.vdr@gmail.com> wrote:
> On Thu, Jan 3, 2013 at 1:33 PM, Antti Palosaari <crope@iki.fi> wrote:
>> I would not like to define exact units for BER and USB as those are quite
>> hard to implement and also non-sense. User would like just to see if there
>> is some (random) numbers and if those numbers are rising or reducing when he
>> changes antenna or adjusts gain. We are not making a professional signal
>> analyzers - numbers does not need to be 100% correctly.
>
> Just a small comment here. Since this may finally be done, why not do
> it the best way? In the end I think that's better and I don't see any
> harm in having the capability to make a pro-grade signal analyzer.
> After years of waiting, I don't think half-assing is a good idea.

The problem is not in creating an API for such a thing. The problem arises
from the fact that all devices need to worked to comply to the API. It might
not factually possible to do that, since most drivers are reverse engineered
or written in a crude way.. In a lot many cases, there are not even the right
documents to do that. An API alone doesn't solve anything at all. Here we
are talking about making pro grade software based on home grade silicon,
for which most don't have proper documentation.

Manu

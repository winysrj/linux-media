Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54214 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3ADFDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 00:03:13 -0500
Received: by mail-ie0-f179.google.com with SMTP id k14so19379514iea.10
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 21:03:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50E5F93D.1000302@iki.fi>
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
Date: Thu, 3 Jan 2013 21:03:12 -0800
Message-ID: <CAA7C2qiGFc2CaVGaVFwe3kQ697ME2uCpjEF8e5yJhbrt5sKOAA@mail.gmail.com>
Subject: Re: [linux-media] Re: [PATCH RFCv3] dvb: Add DVBv5 properties for
 quality parameters
From: VDR User <user.vdr@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 3, 2013 at 1:33 PM, Antti Palosaari <crope@iki.fi> wrote:
> I would not like to define exact units for BER and USB as those are quite
> hard to implement and also non-sense. User would like just to see if there
> is some (random) numbers and if those numbers are rising or reducing when he
> changes antenna or adjusts gain. We are not making a professional signal
> analyzers - numbers does not need to be 100% correctly.

Just a small comment here. Since this may finally be done, why not do
it the best way? In the end I think that's better and I don't see any
harm in having the capability to make a pro-grade signal analyzer.
After years of waiting, I don't think half-assing is a good idea.

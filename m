Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36177 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3AQD0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 22:26:30 -0500
Received: by mail-ob0-f172.google.com with SMTP id za17so2151487obc.31
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2013 19:26:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130116201113.5394cd14@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<CAHFNz9K7EJWjmeU8ViW_bnxO-inNuSU4S+=vH_FHnCF9Aq+kBg@mail.gmail.com>
	<20130116201113.5394cd14@redhat.com>
Date: Thu, 17 Jan 2013 08:56:29 +0530
Message-ID: <CAHFNz9Kn1jZoNL=RAcaxUG=pqab+f_v7-GGGpK-r5zivA=u46w@mail.gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Simon Farnsworth <simon.farnsworth@onelan.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 17, 2013 at 3:41 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Thu, 17 Jan 2013 03:07:21 +0530
> Manu Abraham <abraham.manu@gmail.com> escreveu:
>
>> With ISDB-T, with the 3 layers, you have BER/UNC for each of the layers, though
>> the rate difference could be very little.
>
> Where? There's no way to report per-layer report with DVBv3.


To retrieve on a per layer basis, you will need exactly one control for that.
Nothing more. You don't need such an intrusive patch.


>
> And no, the difference is not very little:
>
> $ dmesg|grep -e mb86a20s_get_main_CNR -e "bit error before" -e "bit count before"


Maybe the difference is small or big. Honestly, I have little trust in
code output by you,
after all the antics in recent threads.


Manu

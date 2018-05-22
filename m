Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:48806 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbeEVKsr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 06:48:47 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <m37eobudmo.fsf@t19.piap.pl>
        <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
        <m3tvresqfw.fsf@t19.piap.pl>
        <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
        <m3fu2oswjh.fsf@t19.piap.pl> <m3603hsa4o.fsf@t19.piap.pl>
        <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com>
Date: Tue, 22 May 2018 12:48:45 +0200
In-Reply-To: <db162792-22c2-7225-97a9-d18b0d2a5b9c@gmail.com> (Steve
        Longerbeam's message of "Mon, 21 May 2018 14:25:40 -0700")
Message-ID: <m3wovwq836.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Steve Longerbeam <slongerbeam@gmail.com> writes:

> Hi Krzysztof, I've been on vacation, just returned today. I will
> find the time this week to attempt to reproduce your results on
> a SabreAuto quad with the adv7180.

Great. Please let me know if I can assist you somehow.

> Btw, if you just need to capture an interlaced frame (lines 0,1,2,...)
> without motion compensation, there is no need to use the VDIC
> path. Capturing directly from ipu2_csi1 should work, I've tested
> this many times on a SabreAuto. But I will try to reproduce your
> results.

That's what I was thinking. Thanks a lot.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland

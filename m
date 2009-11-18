Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2882 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZKRIUs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 03:20:48 -0500
Message-ID: <630a05e93817ce501eb6a0ddd6246a39.squirrel@webmail.xs4all.nl>
In-Reply-To: <20091118084516.375817ff@devenv1>
References: <20091118084516.375817ff@devenv1>
Date: Wed, 18 Nov 2009 09:20:53 +0100
Subject: Re: Driver for NXP SAA7154
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Andreas Feuersinger" <andreas.feuersinger@spintower.eu>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

>
> Hi,
>
> I wonder if there is work in progress for a Linux driver supporting
> the NXP SAA7154 Multistandard video decoder with comb filter, component
> input and RGB output chip. The chip provides some improvements of the
> SAA7119 chip which is (partially?) supported by the kernel right now.
> (I'm not so sure about that)

I'm pretty sure no one is working on that device. Actually, I don't think
the saa7119 is supported either.

> I work for a very small startup company developing an arm based embedded
> system and would very much be interested in the development of that
> driver.
>
> We would especially be interested in
>
> * De-interlacing for progressive displays
>
> NXP Product page:
> http://www.nxp.com/#/pip/pip=[pip=SAA7154E_SAA7154H]|pp=[t=pip,i=SAA7154E_SAA7154H]
> Datasheet:
> http://www.nxp.com/documents/data_sheet/SAA7154E_SAA7154H.pdf
>
> Any help appreciated!

I think it will have to be a new driver, partially based on the current
saa7115.c driver (at least the composite/S-Video input part seems to be
very similar to that one). The good news is that the datasheet is
available, that will help a lot.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom


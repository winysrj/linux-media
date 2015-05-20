Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38175 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbbETLqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 07:46:48 -0400
Received: by wichy4 with SMTP id hy4so56885562wic.1
        for <linux-media@vger.kernel.org>; Wed, 20 May 2015 04:46:48 -0700 (PDT)
Message-ID: <555C7425.9040101@gmail.com>
Date: Wed, 20 May 2015 12:46:45 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@posteo.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL v3] for 4.2: add support for cx24120/Technisat SkyStar
 S2
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>	<20150427171628.5ba22752@recife.lan>	<20150518121115.07d37b78@dibcom294.coe.adi.dibcom.com> <20150520100506.10a46054@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <20150520100506.10a46054@dibcom294.coe.adi.dibcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/05/15 09:05, Patrick Boettcher wrote:
> Hi Mauro,
>
> This is an updated version (v3) of the pull-request for integrating the
> cx24120-driver.
>
> Jemma (and partially me) addressed all strict-conding-style-issues and
> fixed several things regarding signal-stats and demod-issues + some code
> cleaning in general.
>
> Yesterday night Jemma implemented everything related to the UNC and
> BER-stuff. I also integrated your smatch-patches on my branch.
>
> In this mail you'll also find the complete patch, please feel free to
> review it.
>
>

Mauro, I have realised I might have made a mistake in how UCB is 
calculated - I have a patch for this already, should I just send this 
through to the list on it's own?


Jemma.

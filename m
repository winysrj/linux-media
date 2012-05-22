Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34394 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2EVNm2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 09:42:28 -0400
Received: by wibhj8 with SMTP id hj8so3484543wib.1
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 06:42:27 -0700 (PDT)
Message-ID: <4FBB97BE.4090904@gmail.com>
Date: Tue, 22 May 2012 15:42:22 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: SNR status for demods
References: <412bdbff0903171945m680218d9xa39982efb1a17728@mail.gmail.com> <4FBB57C4.4040601@iki.fi>
In-Reply-To: <4FBB57C4.4040601@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 22/05/2012 11:09, Antti Palosaari ha scritto:
> 
> Basically, but not every case, there seems to be 3 different way:
> 1) return raw register value without any calculation
> 2) 0.1 dB
> 3) scaled to 0-0xffff using some formula
> 
> Very many drivers seems to do some dB handling even finally scaling it
> to some value.
> 
> regards
> Antti

Another one (from staging):

as102-fe.c:        Pierrick Hascoet, Devin Heitmueller            linear MER

I can provide a trivial patch to convert it to the more common 0.1 dB
format, if you think it's useful.

This note comes from the driver:

/*
 * Note:
 * - in AS102 SNR=MER
 *   - the SNR will be returned in linear terms, i.e. not in dB
 *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
 *   - the accuracy is >2dB for SNR values outside this range
 */

Regards,
Gianluca

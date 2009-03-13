Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:60603 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZCMCXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 22:23:19 -0400
Received: by yw-out-2324.google.com with SMTP id 5so113113ywh.1
        for <linux-media@vger.kernel.org>; Thu, 12 Mar 2009 19:23:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49B9BC93.8060906@nav6.org>
References: <49B9BC93.8060906@nav6.org>
Date: Thu, 12 Mar 2009 19:23:17 -0700
Message-ID: <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: VDR User <user.vdr@gmail.com>
To: Ang Way Chuang <wcang@nav6.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2009 at 6:53 PM, Ang Way Chuang <wcang@nav6.org> wrote:
> Hi all,
>        I've looked through the mailing list and there seems to be no
> standard
> way to interpret to content of SNR, signal strength and BER returned
> from the DVB API. So, I wonder if someone knows how to interpret these
> values at least for HVR 4000 Lite? Thanks.

I've seen talk about converting everything to report SNR/STR in dB
which is a great idea if it ever happens.  I know a lot of guys not on
the mailing list who've been waiting for that.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:51263 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZBSPIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 10:08:16 -0500
Received: by rv-out-0506.google.com with SMTP id g37so451530rvb.1
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 07:08:14 -0800 (PST)
From: Andreas <linuxdreas@dslextreme.com>
To: CityK <cityk@rogers.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
Date: Thu, 19 Feb 2009 05:30:08 -0800
Cc: linux-media@vger.kernel.org
References: <200902180441.40316.linuxdreas@dslextreme.com> <499CD3F3.9010803@rogers.com>
In-Reply-To: <499CD3F3.9010803@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902190530.08328.linuxdreas@dslextreme.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, 18. Februar 2009 19:37:23 schrieb CityK:
>
> It should be noted that a common element here in the two cases is the
> Nxt2004 (demod for both the A180 and 11x cards).

Yes, that's right. After testing different configurations, I believe 
that the problem with corrupted QAM recordings has more than one 
source:
* A driver problem (ivtv, maybe also nxt2004)
* Mainboards which are "dma-challenged" (one of mine definitely has 
probs in that department) 
* RF interference / general reception problems.

At the end of the day, it comes down to lots of testing and a bit of 
luck to find a combination of cards & mainboards which work nicely 
together.

-- 
Gruﬂ
Andreas

Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:35586 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZCTNHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 09:07:08 -0400
Received: by yx-out-2324.google.com with SMTP id 31so966632yxl.1
        for <linux-media@vger.kernel.org>; Fri, 20 Mar 2009 06:07:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C33DE7.1050906@gmail.com>
References: <49B9BC93.8060906@nav6.org>
	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
	 <20090319101601.2eba0397@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>
Date: Fri, 20 Mar 2009 09:07:04 -0400
Message-ID: <412bdbff0903200607m4667554ehef78c710eac2f096@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 20, 2009 at 2:55 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> When you position an antenna, you do not get a LOCK in most cases.
> The signal statistics for any demodulator are valid only with a
> frontend LOCK.

This is absolutely true, and a very common problem in the drivers (at
least with the ATSC/QAM devices).  Most of the drivers blindly return
whatever value is in the register regardless of whether there is lock.
 One of the things I plan to do for the ATSC devices is go through
each of them and make sure they properly return ENOSIGNAL when there
is not a lock (this is actually already the defined behavior in the
dvb v3 spec), as well as submitting patches for Kaffeine to properly
reflect this state to the user.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

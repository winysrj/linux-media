Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:45495 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbaKSTuR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 14:50:17 -0500
Date: Wed, 19 Nov 2014 20:50:19 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Stephan Raue <mailinglists@openelec.tv>
Cc: linux-input@vger.kernel.org, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: bisected: IR press/release behavior changed in 3.17, repeat
 events
Message-ID: <20141119195019.GA20784@hardeman.nu>
References: <54679469.1010500@openelec.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54679469.1010500@openelec.tv>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 15, 2014 at 06:59:05PM +0100, Stephan Raue wrote:
>Hi
>
>with kernel 3.17 using a RC6 remote with a buildin nuvoton IR receiver (not
>tested others, but i think its a common problem) when pressing/releasing the
>same button often within 1 second there will no release event sent. Instead
>we get repeat events. To get the release event i must press the same button
>with a delay of ~ 1sec.
>
>the evtest output for kernel with the difference 3.16 and 3.17 looks like

Hi,

could you try the working and non-working versions with debugging output
enabled from the in-kernel rc6 decoder (i.e. set debug for the rc-core
module) and post the two different outputs?

//David


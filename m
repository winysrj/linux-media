Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:45515 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbaKSXph (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Nov 2014 18:45:37 -0500
Date: Thu, 20 Nov 2014 00:45:39 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Stephan Raue <mailinglists@openelec.tv>
Cc: linux-input@vger.kernel.org, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: bisected: IR press/release behavior changed in 3.17, repeat
 events
Message-ID: <20141119234539.GB16939@hardeman.nu>
References: <54679469.1010500@openelec.tv>
 <20141119195019.GA20784@hardeman.nu>
 <546D25D7.9050703@openelec.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546D25D7.9050703@openelec.tv>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 20, 2014 at 12:20:55AM +0100, Stephan Raue wrote:
>with kernel 3.17: (you dont see the messages with "toggle 1" here)
>if i press once and wait:

Ummm...kinda embarassing...try swapping the order of the scancode and
toggle lines in the rc6 decoder (drivers/media/rc/ir-rc6-decoder.c).

They're somewhere around line 259, right after the case 32 statement.

case 32:
	if ((scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
		protocol = RC_TYPE_RC6_MCE;
                scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
		toggle = !!(scancode & RC6_6A_MCE_TOGGLE_MASK);



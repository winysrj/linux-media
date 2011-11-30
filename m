Return-path: <linux-media-owner@vger.kernel.org>
Received: from web244.extendcp.co.uk ([79.170.40.244]:58983 "EHLO
	web244.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1K3TNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 14:13:17 -0500
To: Abylay Ospan <aospan@netup.ru>
Subject: Re: LinuxTV ported to Windows
MIME-Version: 1.0
Date: Wed, 30 Nov 2011 18:46:54 +0000
From: Walter Van Eetvelt <walter@van.eetvelt.be>
Cc: <linux-media@vger.kernel.org>
In-Reply-To: <4ED65C46.20502@netup.ru>
References: <4ED65C46.20502@netup.ru>
Message-ID: <912e38aa28e2ea4d2723d65c93135397@mail.eetvelt.be>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nice!

How is the CI implementation?  Can both CI's be used by both tuners?  Or
is one CI bound to one tuner?  

Walter

On Wed, 30 Nov 2011 19:39:34 +0300, Abylay Ospan <aospan@netup.ru> wrote:
> Hello,
> 
> We have ported linuxtv's cx23885+CAM en50221+Diseq to Windows OS (Vista,

> XP, win7 tested). Results available under GPL and can be checkout from 
> git repository:
> https://github.com/netup/netup-dvb-s2-ci-dual
> 
> Binary builds (ready to install) available in build directory. Currently

> NetUP Dual DVB-S2 CI card supported ( 
> http://www.netup.tv/en-EN/dual_dvb-s2-ci_card.php ).
> 
> Driver based on Microsoft BDA standard, but some features (DiSEqC, CI) 
> supported by custom API, for more details see netup_bda_api.h file.
> 
> Any comments, suggestions are welcome.

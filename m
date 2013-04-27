Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:56318 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab3D0PTE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Apr 2013 11:19:04 -0400
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.5/8.14.5) with ESMTP id r3REpV8A003949
	for <linux-media@vger.kernel.org>; Sat, 27 Apr 2013 16:51:32 +0200
Received: from [192.168.100.11] (falcon.tvdr.de [192.168.100.11])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id r3REpQxv028458
	for <linux-media@vger.kernel.org>; Sat, 27 Apr 2013 16:51:26 +0200
Message-ID: <517BE5EE.6050004@tvdr.de>
Date: Sat, 27 Apr 2013 16:51:26 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] stb0899: no lock on dvb-s2 transponders in SCR
 environment
References: <517BC11E.50105@gmx.de>
In-Reply-To: <517BC11E.50105@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.04.2013 14:14, Reinhard Nissl wrote:
> Hi,
>
> my stb0899 card works properly on dvb-s and dvb-s2 transponders when using a direct port on my sat multiswitch.
>
> When using a SCR port on that multiswitch and changing VDR's config files accordingly, it only locks on dvb-s transponders.
>
> A SCR converts the selected transponder's frequency after the LNB (IF1) to a fixed frequency (for example 1076 MHz) by mixing the signal with a local oscialator frequency above IF1 so that the lower sideband of the mixing product appears at 1076 MHz.
>
> The lower sideband's spectrum is mirrored compared to the upper sideband, which is identical to the original spectrum on the original IF1.
>
> Could that be the reason why the stb0899 cannot lock on dvb-s2 transponders in an SCR environment?
>
> Any ideas on how to get a lock on dvb-s2 transponders?

Just wanted to let you know that I can confirm the problem with
the stb0899. On my TT S2-6400 I can receive DVB-S and DVB-S2 just
fine with SCR. During development of SCR support for VDR I guess
I did all tests with the 6400, so I didn't come across this problem.
However, as a reaction to your posting I explicitly tested it with
my budget cards, and there I indeed can only tune to DVB-S transponders.

No idea how to solve this, though...

Klaus

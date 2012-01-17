Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2AQQQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 11:16:24 -0500
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/4] DVB: dib0700, move Nova-TD Stick to a separate set
Date: Tue, 17 Jan 2012 17:16:17 +0100
Cc: mchehab@infradead.org, mikekrufky@gmail.com,
	linux-media@vger.kernel.org, jirislaby@gmail.com,
	linux-kernel@vger.kernel.org
References: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201171716.17365.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

H Jiri,

On Tuesday 10 January 2012 18:11:22 Jiri Slaby wrote:
> To properly support the three LEDs which are on the stick, we need
> a special handling in the ->frontend_attach function. Thus let's have
> a separate ->frontend_attach instead of ifs in the common one.
> 
> The hadnling itself will be added in further patches.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
> [..]

Thanks. I reviewed and added those commits to my tree (apparently Mike 
did the same and asked Mauro to pull as well).

We will see how it turns out. :)

best regards,
--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from [89.146.194.165] ([89.146.194.165]:51928 "EHLO mx02.posteo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbbEZNrW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:47:22 -0400
Date: Tue, 26 May 2015 11:05:45 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Jemma Denson <jdenson@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCH 3/4] cx24120: Take control of b2c2 receive stream
Message-ID: <20150526110545.32c71335@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <1432326508-6825-4-git-send-email-jdenson@gmail.com>
References: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
	<1432326508-6825-4-git-send-email-jdenson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jemma,

On Fri, 22 May 2015 21:28:27 +0100 Jemma Denson <jdenson@gmail.com>
wrote:

> Now that b2c2 has an option to allow us to do so, turn off the
> flexcop receive stream when we turn off mpeg output whilst tuning.

Does this not fix (and your '[PATCH 2/4]') the problem of receiving
PAT from the previously tuned transport-stream?

Then patch 1 and 4 should not be necessary, should they?!

--
Patrick.




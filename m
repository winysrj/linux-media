Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:24224 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbZCEUup (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 15:50:45 -0500
Date: Thu, 5 Mar 2009 21:50:33 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix race in infrared polling on rmmod
Message-ID: <20090305215033.1fda662e@hyperion.delvare>
In-Reply-To: <412bdbff0903051003o15d4d269s3b05b01a6b06b47a@mail.gmail.com>
References: <20090305103930.25b18638@hyperion.delvare>
	<412bdbff0903051003o15d4d269s3b05b01a6b06b47a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Thu, 5 Mar 2009 13:03:00 -0500, Devin Heitmueller wrote:
> On Thu, Mar 5, 2009 at 4:39 AM, Jean Delvare <khali@linux-fr.org> wrote:
> I would suggest that this patch be broken into three separate patches,
> and then they can go in as the individual maintainers have the
> opportunity to test them out. This will ensure that no totally
> untested code goes into the codebase.

OK, will do. This is how I had it originally, BTW... and then I merged
all 3 patches because they are really fixing the same bug. But I'll
split them again, no problem.

> I'll volunteer to do the em28xx patch.

Thanks!

-- 
Jean Delvare

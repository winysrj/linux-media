Return-Path: <SRS0=d3EJ=PA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DE4C43612
	for <linux-media@archiver.kernel.org>; Sun, 23 Dec 2018 16:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 909FD2184D
	for <linux-media@archiver.kernel.org>; Sun, 23 Dec 2018 16:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbeLWQPe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 23 Dec 2018 11:15:34 -0500
Received: from muru.com ([72.249.23.125]:59142 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbeLWQPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Dec 2018 11:15:34 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id F198E8119;
        Sun, 23 Dec 2018 16:15:37 +0000 (UTC)
Date:   Sun, 23 Dec 2018 08:15:30 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
Message-ID: <20181223161530.GL6707@atomide.com>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221180205.GH6707@atomide.com>
 <20181222024753.d4mge5m3x3vqfrt6@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181222024753.d4mge5m3x3vqfrt6@earth.universe>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [181222 02:48]:
> On Fri, Dec 21, 2018 at 10:02:05AM -0800, Tony Lindgren wrote:
> > Hmm so looks like nothing to configure for the clocks or
> > CPCAP_BIT_ST_L_TIMESLOT bits for cap for the EXT? So the
> > wl12xx audio is wired directly to cpcap EXT then and not a
> > TDM slot on the mcbsp huh?
> 
> For FM radio it's directly wired to EXT with no DAI being required.
> I think that EXT is only used by FM radio and not by bluetooth. BT
> seems to use TDM.

OK then it sounds like we just need a diff -u of the cpcap regs
from Android with cpcaprw --all before and after using a bluetooth
headset during a voice call to configure it for voice calls for the
TDM. I think snd-soc-motmd just needs the voice output specified
in the mixer in addition to the cpcap configuration.

I don't think have any bluetooth audio gear though, maybe somebody
using a headset can post the diff.

Regards,

Tony

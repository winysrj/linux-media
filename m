Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F56AC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 09:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA48E21841
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 09:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfCTJWf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 05:22:35 -0400
Received: from gofer.mess.org ([88.97.38.141]:47585 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbfCTJWf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 05:22:35 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 037AC60570; Wed, 20 Mar 2019 09:22:33 +0000 (GMT)
Date:   Wed, 20 Mar 2019 09:22:33 +0000
From:   Sean Young <sean@mess.org>
To:     Adam Di Carlo <a.p.dicarlo@gmail.com>
Cc:     linux-media@vger.kernel.org
Subject: Re: ir-keytable known bug -- fails to work when device specified
Message-ID: <20190320092233.sljmbxt2jzsi3psz@gofer.mess.org>
References: <8736njzpep.fsf@gw.coo>
 <20190319101217.6uictrbyhyednzxj@gofer.mess.org>
 <87imwexuyy.fsf@gw.coo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imwexuyy.fsf@gw.coo>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 19, 2019 at 08:14:45PM -0400, Adam Di Carlo wrote:
> Sean Young <sean@mess.org> writes:
> > Adam wrote:
> >> Rather than document all this, isn't better to clean it up in the
> >> source?  I can probably come up with a patch for this issue in fairly
> >> short order, if that's welcome.
> >
> > You're right, this is broken. For this to work it would have to get all
> > the details for the all the rc devices and find the one that has an
> > input device with that name.
> >
> > That command line above implies that the protocol is a property of the
> > input device which it is not. Actually I think the whole -d option is
> > misleading and not really useful. I think the right solution is to just
> > remove it completely.
> 
> Ok, the patch looks good, I definately think this is a step in the right
> direction.
> 
> In cases where there is multiple devices, one would select it with, for
> instance, '-s rc1' -- is that the intent?

That's right. I'm not sure that `ir-keytable --help` or the man page
expresses that very clearly, though. Not sure what it should read..


Sean

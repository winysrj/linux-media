Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40939
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751386AbdH3WR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 18:17:57 -0400
Date: Wed, 30 Aug 2017 19:17:48 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 2/2] media: dvb-core: fix demux.h non-ASCII characters
Message-ID: <20170830191748.40a16438@vento.lan>
In-Reply-To: <20170830152430.068b13ce@lwn.net>
References: <5fb15c64-e376-f461-8a7c-d0c6776870c9@infradead.org>
        <20170830152430.068b13ce@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 30 Aug 2017 15:24:30 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Mon, 28 Aug 2017 16:10:16 -0700
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
> > Fix non-ASCII charactes in kernel-doc comment to prevent the kernel-doc
> > build warning below.
> > 
> > WARNING: kernel-doc '../scripts/kernel-doc -rst -enable-lineno ../drivers/media/dvb-core/demux.h' processing failed with: 'ascii' codec can't decode byte 0xe2 in position 6368: ordinal not in range(128)  
> 
> I'll leave this one for Mauro to decide on.  My inclination would be to
> apply it, though, my previous comments on handling non-ASCII text
> notwithstanding.  The weird quotes don't buy us anything here.

Yeah, it doesn't make sense to have this character there.

I'll apply it on my tree. Yet, I'm considering adding an UTF-8
character on a kernel-doc markup.

One DVB parameter is called "Rolloff", and its usual symbol is
the greek letter alpha. There, it would make sense to use a
non-ascII character.

By coincidence, I just wrote such patch earlier today.

Regards,
Mauro

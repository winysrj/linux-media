Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59973
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932461AbdA3Q0O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 11:26:14 -0500
Date: Mon, 30 Jan 2017 14:26:07 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 1/5] [media] ir-rx51: port to rc-core
Message-ID: <20170130142607.1c8411e9@vento.lan>
In-Reply-To: <20170116201358.GA29381@amd>
References: <cover.1482255894.git.sean@mess.org>
        <f5262cc638a494f238ef96a80d8f45265ca2fd02.1482255894.git.sean@mess.org>
        <5878d916-6a60-d5c3-b912-948b5b970661@gmail.com>
        <20161230130752.GA7377@gofer.mess.org>
        <20161230133030.GA7861@gofer.mess.org>
        <1e4fa726-5dec-028e-9f0f-1c53d58df981@gmail.com>
        <20170116101053.GA24265@gofer.mess.org>
        <750f3570-8acb-1707-c929-421518a38516@gmail.com>
        <20170116201358.GA29381@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Jan 2017 21:13:58 +0100
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > On 16.01.2017 12:10, Sean Young wrote:  
> > >
> > >Have you had a chance to test the ir-rx51 changes?
> > >
> > >Thanks
> > >Sean
> > >  
> > 
> > Still no, and afaik there are issues booting n900 with current kernel. Will
> > try to find time over the weekend.  
> 
> v4.10-rc3 (?) works for me on n900. Do you want a working .config?

I'm merging this patch at the media tree. Please report if you
find any issues for us to fix in time for 4.11.

Thanks,
Mauro

Thanks,
Mauro

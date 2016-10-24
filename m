Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48030 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965406AbcJXU43 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 16:56:29 -0400
Date: Mon, 24 Oct 2016 21:56:21 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
Message-ID: <20161024205621.GA25320@dell-m4800.home>
References: <m360powc4m.fsf@t19.piap.pl>
 <20160922152356.nhgacxprxtvutb67@zver>
 <m3ponri5ky.fsf@t19.piap.pl>
 <20160926091831.cp6qkv77oo5tinn5@zver>
 <m337kldi92.fsf@t19.piap.pl>
 <20160927074009.3kcvruynnapj6y3q@zver>
 <m3y42dbmqq.fsf@t19.piap.pl>
 <20160927142244.rocwg36f2bsfl3n6@zver>
 <m3ponobnvb.fsf@t19.piap.pl>
 <20161024173233.5daabac4@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161024173233.5daabac4@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 24, 2016 at 05:32:33PM -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 28 Sep 2016 07:21:44 +0200
> khalasa@piap.pl (Krzysztof Hałasa) escreveu:
> 
> > Andrey Utkin <andrey_utkin@fastmail.com> writes:
> > 
> > > Lockup happens only on 6010. In provided log you can see that 6110
> > > passes just fine right before 6010. Also if 6010 PCI ID is removed from
> > > solo6x10 driver's devices list, the freeze doesn't happen.  
> > 
> > Probably explains why I don't see lockups :-)
> > 
> > I will have a look.
> 
> Any news on this? Should the patch be applied or not? If not, are there
> any other patch to fix this regression?

Actual patch is

Subject: [PATCH v2] media: solo6x10: fix lockup by avoiding delayed register write
Message-Id: <20161022153436.12076-1-andrey.utkin@corp.bluecherry.net>
Date: Sat, 22 Oct 2016 16:34:36 +0100

Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:37852 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbZCKOOl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 10:14:41 -0400
Received: by yx-out-2324.google.com with SMTP id 8so26302yxm.1
        for <linux-media@vger.kernel.org>; Wed, 11 Mar 2009 07:14:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0903110842570.1207@pedra.chehab.org>
References: <1236612894.5982.72.camel@miki-desktop>
	 <20090309204308.10c9afc6@pedra.chehab.org>
	 <1236771396.5991.24.camel@miki-desktop>
	 <alpine.LRH.2.00.0903110842570.1207@pedra.chehab.org>
Date: Wed, 11 Mar 2009 10:14:39 -0400
Message-ID: <412bdbff0903110714o6f92c8cax96009226d033c611@mail.gmail.com>
Subject: Re: Improve DKMS build of v4l-dvb?
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alain Kalker <miki@dds.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 11, 2009 at 7:47 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>> After the test build, all you have to do is run "modinfo -F alias" on
>> all the modules, add the principal module name, and you will end up with
>> a modaliases list which is directly usable with Jockey. For users
>> without it, another simple script will select the correct principal
>> module to build.
>
> IMO, a perl script searching for PCI and USB tables at the driver would do a
> faster job than doing a module build. You don't need to do a test build to
> know what modules compile, since v4l/versions.txt already contains the
> minimum supported version for each module. If the module is not there, then
> it will build since kernel 2.6.16.

I hate to be the one to point this out, but isn't the notion of
automatically rebuilding the modules for *your* hardware broken right
from the start?  What this would mean that if I own a laptop and my
USB based capture device happens to not be connected when I upgrade my
kernel, then my drivers are going to be screwed up?

Maybe I'm just missing something.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

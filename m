Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59948
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932529AbdIHVwH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 17:52:07 -0400
Date: Fri, 8 Sep 2017 18:51:58 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Stephen Hemminger <stephen@networkplumber.org>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [PATCH] media: default for RC_CORE should be n
Message-ID: <20170908185158.2b7a79d9@vento.lan>
In-Reply-To: <20170908120648.291b2c02@xeon-e3>
References: <20170908163929.9277-1-sthemmin@microsoft.com>
        <20170908185247.un3c7bjnety6uja3@gofer.mess.org>
        <20170908120648.291b2c02@xeon-e3>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 8 Sep 2017 12:06:48 -0700
Stephen Hemminger <stephen@networkplumber.org> escreveu:

> On Fri, 8 Sep 2017 19:52:47 +0100
> Sean Young <sean@mess.org> wrote:
> 
> > On Fri, Sep 08, 2017 at 09:39:29AM -0700, Stephen Hemminger wrote:  
> > > The Linus policy on Kconfig is that the default should be no
> > > for all new devices. I.e the user rebuild a new kernel from an
> > > old config should not by default get a larger kernel.    
> > 
> > That might make sense for new config, but RC_CORE has been present for
> > 7 years; I don't see how changing defaults for existing config makes
> > sense.
> >   
> 
> I took existing config for 4.13 and did 'make oldconfig' and just
> hitting return caused it to turned on.
> 
> The problem is that in my config media is disabled, and now your new
> reconfiguration makes RC_CORE not dependent on media.
> 
> It is a common problem, developers never test with their subsystem disabled.

Hi Sean,

Yes, it makes sense to default 'n' for RC_CORE now that this is an
independent menu option and it builds the RC core when enabled.

Regards,
Mauro

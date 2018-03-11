Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-00272701.pphosted.com ([208.86.201.61]:47646 "EHLO
        mx0b-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932161AbeCKTv0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 15:51:26 -0400
Date: Sun, 11 Mar 2018 14:51:16 -0500
From: Nick French <naf@ou.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Message-ID: <20180311195116.GB4645@tivo.lan>
References: <DM5PR03MB3035EE1AFCEE298AFB15AC46D3C60@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180301171936.GU14069@wotan.suse.de>
 <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180307190205.GA14069@wotan.suse.de>
 <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180308040601.GQ14069@wotan.suse.de>
 <20180308041411.GR14069@wotan.suse.de>
 <DM5PR03MB3035CCBF9718D7E42B35357FD3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <MWHPR03MB30402C0F8B8F457F5F760412D3DD0@MWHPR03MB3040.namprd03.prod.outlook.com>
 <67E7293F-6045-4EA1-8AEF-E4B92E046581@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67E7293F-6045-4EA1-8AEF-E4B92E046581@amacapital.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 10, 2018 at 10:20:23AM -0800, Andy Lutomirski wrote:
>>> Perhaps the easy answer is to change the fatal is-pat-enabled check to just
>>> a warning like "you have PAT enabled, so wc is disabled for the framebuffer.
>>> if you want wc, use the nopat parameter"?
>>
>> I like this idea more and more. I haven't experience any problems running
>> with PAT-enabled and no write-combining on the framebuffer. Any objections?
>>
>
> None from me.
>
> However, since you have the hardware, you could see if you can use the
> change_page_attr machinery to change the memory type on the framebuffer once
> you figure out where it is.

I am certainly willing to try this, but my understanding of the goal of the
changes that disabled ivtvfb originally is that it was trying to hide the
architecture-specific memory management from the driver.

Wouldn't (figuring out a way to) expose x86/mm/pageattr internals to the
driver be doing the opposite? (or maybe I misunderstand your suggestion)

- Nick

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-00272701.pphosted.com ([67.231.145.144]:40158 "EHLO
        mx0a-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932334AbeCKWId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 18:08:33 -0400
Date: Sun, 11 Mar 2018 17:08:24 -0500
From: Nick French <naf@ou.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Message-ID: <20180311220823.GA4074@tivo.lan>
References: <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180307190205.GA14069@wotan.suse.de>
 <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180308040601.GQ14069@wotan.suse.de>
 <20180308041411.GR14069@wotan.suse.de>
 <DM5PR03MB3035CCBF9718D7E42B35357FD3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <MWHPR03MB30402C0F8B8F457F5F760412D3DD0@MWHPR03MB3040.namprd03.prod.outlook.com>
 <67E7293F-6045-4EA1-8AEF-E4B92E046581@amacapital.net>
 <20180311195116.GB4645@tivo.lan>
 <38CB7D59-7F11-4BC3-B73C-C2F0BF16EFF8@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38CB7D59-7F11-4BC3-B73C-C2F0BF16EFF8@amacapital.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 11, 2018 at 01:19:03PM -0700, Andy Lutomirski wrote:
> From memory, I see two potentially reasonable real fixes. One is to find a way to punch a hole in an ioremap.
> So you’d find the framebuffer, remove it from theproblematic mapping, and then make a new mapping. 
> The second is to change the mapping type in place. 

For the changing-in-place method, is there already an exported API that exposes change_page_attr_set without first
calling reserve_memtype? I can't seem to find one.

> Or maybe you could just iounmap the whole thing after firmware is loaded and the framebuffer is found and then
> redo the mapping right. 

I guess this would require a lock so that the ivtv-driver proper wasn't accessing the decoder's mapped memory 
during ivtvfb's iounmap-ioremap window. And a way to notify ivtv-driver proper if things go wrong? I think this method
would be very awkward because its not even memory owned by ivtvfb itself.

- Nick

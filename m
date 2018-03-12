Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-00272701.pphosted.com ([208.86.201.61]:58586 "EHLO
        mx0b-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750725AbeCLEEQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 00:04:16 -0400
Date: Sun, 11 Mar 2018 23:04:02 -0500
From: Nick French <naf@ou.edu>
To: Ian Armstrong <mail01@iarmst.co.uk>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Message-ID: <20180312040401.GA4814@tivo.lan>
References: <20180301171936.GU14069@wotan.suse.de>
 <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180307190205.GA14069@wotan.suse.de>
 <DM5PR03MB30352350D588A81D2D02BE93D3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180308040601.GQ14069@wotan.suse.de>
 <20180308041411.GR14069@wotan.suse.de>
 <DM5PR03MB3035CCBF9718D7E42B35357FD3DF0@DM5PR03MB3035.namprd03.prod.outlook.com>
 <MWHPR03MB30402C0F8B8F457F5F760412D3DD0@MWHPR03MB3040.namprd03.prod.outlook.com>
 <CAB=NE6VvDNbe=XsfG0tYeFcxcXzsRkHnZxVHM79-V+1t6foU5g@mail.gmail.com>
 <20180311232438.2b204c51@spike.private.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180311232438.2b204c51@spike.private.network>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 11, 2018 at 11:24:38PM +0000, Ian Armstrong wrote:
> On Sat, 10 Mar 2018 16:57:41 +0000
> "French, Nicholas A." <naf@ou.edu> wrote:
> 
> > > > No what if the framebuffer driver is just requested as a
> > > > secondary step after firmware loading?  
> > >
> > > Its a possibility. The decoder firmware gets loaded at the
> > > beginning of the decoder memory range and we know its length, so
> > > its possible to ioremap_nocache enough room for the firmware only
> > > on init and then ioremap the remaining non-firmware decoder memory
> > > areas appropriately after the firmware load succeeds...  
> > 
> > I looked in more detail, and this would be "hard" due to the way the
> > rest of the decoder offsets are determined by either making firmware
> > calls or scanning the decoder memory range for magic bytes and other
> > mess.
> 
> The buffers used for yuv output are fixed. They are located both before
> and after the framebuffer. Their offset is fixed at 'base_addr +
> IVTV_DECODER_OFFSET + yuv_offset[]'. The yuv offsets can be found in
> 'ivtv-yuv.c'. The buffers are 622080 bytes in length.
> 
> The range would be from 'base_addr + 0x01000000 + 0x00029000' to
> 'base_addr + 0x01000000 + 0x00748200 + 0x97dff'. This is larger than
> required, but will catch the framebuffer and should not cause any
> problems. If you wanted to render direct to the yuv buffers, you would
> probably want this region included anyway (not that the current driver
> supports that).

Am I correct that you are talking about the possibility of re-ioremap()-ing
the 'yuv-fb-yuv' area *after* loading the firmware, not of mapping ranges
correctly on the first go-around?

Because unless my math is letting me down, the decoder firmware is already
loaded from 'base_addr + 0x01000000 + 0x0' to 'base_addr + 0x01000000 + 0x3ffff'
which overlaps the beginning of the yuv range.

- Nick

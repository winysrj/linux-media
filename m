Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49335 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754786AbeDWMNG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:13:06 -0400
Date: Mon, 23 Apr 2018 13:13:04 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org,
        Warren Sturm <warren.sturm@gmail.com>,
        Andy Walls <awalls.cx18@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH stable v4.15 1/3] media: staging: lirc_zilog: broken
 reference counting
Message-ID: <20180423121303.d5cptxr5c7h6r67g@gofer.mess.org>
References: <cover.1523785117.git.sean@mess.org>
 <2bd4184fbea37ecdfcb0a334c6bef45786feb486.1523785117.git.sean@mess.org>
 <20180416075228.GB2121@kroah.com>
 <20180416084344.k4e3tx4jd5lswfh3@gofer.mess.org>
 <20180416085015.GA2598@kroah.com>
 <20180416091527.ryx7vdekzjwcrpxo@gofer.mess.org>
 <20180422094751.GC26895@kroah.com>
 <20180423090420.tvb6danodfbc55m2@gofer.mess.org>
 <20180423073422.05014710@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423073422.05014710@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 07:34:22AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 23 Apr 2018 10:04:20 +0100
> Sean Young <sean@mess.org> escreveu:
> 
> > On Sun, Apr 22, 2018 at 11:47:51AM +0200, Greg KH wrote:
> > > On Mon, Apr 16, 2018 at 10:15:28AM +0100, Sean Young wrote:  
> > > > On Mon, Apr 16, 2018 at 10:50:15AM +0200, Greg KH wrote:  
> > > > > On Mon, Apr 16, 2018 at 09:43:45AM +0100, Sean Young wrote:  
> > > > > > On Mon, Apr 16, 2018 at 09:52:28AM +0200, Greg KH wrote:  
> > > > > > > What is the git commit id of this patch, and the other patches in this
> > > > > > > series and the 4.14 patch series that you sent out?  
> > > > > > 
> > > > > > lirc_zilog was dropped in v4.16, so this can't be patched upstream.  
> > > > > 
> > > > > Ah you are right, should we just ditch them here as well as they
> > > > > obviously do not work? :)
> > > > >   
> > > > > > > Please read:
> > > > > > >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > > > > > > for how to do this in a way that I can pick them up.  
> > > > > > 
> > > > > > These patches have been tested with different types of hardware. Is there
> > > > > > anything else I can do to get these patches included?  
> > > > > 
> > > > > When submitting patches to stable, you need to be explicit as to why
> > > > > they are needed, and if they are not upstream, why not.
> > > > > 
> > > > > In this case, for obviously broken code that is not used anymore (as
> > > > > it is gone in 4.16), why don't we just take the patch that removed the
> > > > > driver to the stable trees as well?  
> > > > 
> > > > Well in v4.16 the ir-kbd-i2c.c driver can do what the lirc_zilog does in
> > > > v4.15 (and earlier), so it wasn't ditched as such. It's a case of replaced
> > > > by mainline.
> > > > 
> > > > Since I was getting bug reports on it, there must be users of the lirc_zilog
> > > > driver.
> > > > 
> > > > That being said, the old lirc_dev and lirc_zilog is pretty awful code.  
> > > 
> > > Ok, I've queued these up for 4.14.y now.  4.15 is end-of-life, so I
> > > can't apply these patches there, sorry.  
> > 
> > Ok, thanks.
> > 
> > I wonder why Ubuntu picked 4.15 as the kernel for their upcoming 18.04 LTS
> > release.
> 
> I've no idea. Maybe it might be due to spectre/meltdown? Anyway, they'll
> need to maintain it for a long time. So, I won't be surprised if they
> decide to take over LTS maintainership upstream. In the mean time, if the
> bug is seriously enough, you may consider sending them fixup patches
> directly, although I guess that they use a bugzilla instead for patches
> to the distro, with makes harder/painful to send them fixups.
> 
> The Ubuntu FAQ (https://wiki.ubuntu.com/Kernel/FAQ) points to an IRC
> freenode channel (#ubuntu-kernel). Perhaps you could ping them there
> and ask them about that.

Following their advice, I've resent the patches to 
kernel-team@lists.ubuntu.com; I'm afraid stable got cc'ed again in the
process, please ignore (sorry!)


Sean

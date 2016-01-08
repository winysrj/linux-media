Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:44879 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbcAHMYq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jan 2016 07:24:46 -0500
Date: Fri, 8 Jan 2016 13:18:52 +0100
From: Martin Witte <emw-linux-media-2016@nocabal.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [REGRESSION/bisected] kernel panic after "rmmod cx23885" by "si2157:
 implement signal strength stats"
Message-ID: <20160108121852.GA29971@[192.168.115.1]>
Reply-To: emw-linux-media-2016@nocabal.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

First apologies if  this bug report is not perfect  ...  It's my first
time hunting a kernel bug and doing the bisect.

My way to reliably reproduce the issue:

  * relevance / use-case:

    HTPC going into sleep (currently  requires rmmod as isolated here)
    when not being used.

  * base system:
    - Ubuntu 15.10 (arch: amd64)
    - PCIe DVB-C card DVBSky T982 (2 DVB-C/T tuners)
    - starting point: Ubuntu kernel 4.2.x / x86_64
    
  * run tvheadend  4.x using the  DVB-C tuners (from git/master  in my
    case, but actual release should  not be that relevant) ...  likely
    any other DVB-C application would be sufficient.

  * trigger kernel panic:
  
    - stop tvheadend
    
    - rmmod cx23885
    
      Please note: It seems to be  relevant that the DVB-C tuners were
      in use (and released) before the call to rmmod.  During testing,
      I  had situations  where I  could successfully  do the  rmmod if
      tvheadend was not yet started after a fresh boot.

      The kernel  panic happens  after the rmmod  with a  little delay
      (less than a second) - in some completely unrelated parts of the
      kernel, but reproducible locations, e.g. a stack frame like:

          call_timer_fn+0x35/0xf0
          __run_timers (inlined)
          run_timer_softirq+0x221/0x2d0
          __do_softirq+0x0f6/0250

          (unable to handle paging request, aka invalid pointer)

      or

          call_timer_fn+0x35/0xf0
          __run_timers (inlined)
          run_timer_softirq+0x162/0x2d0
          __do_softirq+0x0f6/0250

          (null pointer dereference)

      The faulting line is a call to NULL or invalid function pointer,
      namely line 1178 in media_tree/kernel/time/timer.c

      1177         trace_timer_expire_entry(timer);
      1178         fn(data);
      1179         trace_timer_expire_exit(timer);

      fn is a  null pointer if called within the  "if (irqsafe)" block
      or an invalid pointer if  called from the respective else branch
      (ll. 1284 in media_tree/kernel/time/timer.c)

  * Affected:
  
       - v4.2.x
       
       - v4.3.x
       
       - v4.4.rcX
       
       - media-tree/master (after  workaround for  regression identified
                            by   Matthias   Schwarzott    on   Jan.   6,
                            "[REGRESSION/bisected]   kernel    oops   in
                            vb2_core_qbuf")
  
  * Not affected: v4.1.x

  * Bisect   result    on   git://github.com/torvalds/linux.git/master
    between v4.1 and v4.2
    
    2f1ea29fca781b8e6600f3ece1f2dd98ae276294 is the first bad commit
    commit 2f1ea29fca781b8e6600f3ece1f2dd98ae276294
    Author: Antti Palosaari <crope@iki.fi>
    Date:   Sun Sep 7 11:20:34 2014 -0300

        [media] si2157: implement signal strength stats
    
        Implement DVBv5 signal strength stats. Returns dBm.
    
        Signed-off-by: Antti Palosaari <crope@iki.fi>
        Tested-by: Adam Baker <linux@baker-net.org.uk>
        Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

    :040000 040000 1fc70a3d18532f91289e8b581081ee59feefc321 5130e9b011e9c4ba683cd4db3eae8dca67c3ef0e M      drivers

  * Workaround:

    Reverting this patch on my tested kernels (incl. 4.4.rc8) prevents
    the kernel panic.

  * Guesses (Conclusion would be far too much ;-)

    - Memory  corruption by  some of  the media  drivers? Without  any
      personal background in linux  kernel development, it's currently
      my only idea how those  far-apart code locations can affect each
      other. If it is memory corruption - is it
      
      * caused by the identified patch? ... or
      
      * caused  by some  other  part  of the  media  drivers but  made
        "observable" by the identified patch?

    - Are there kernel  timers created by the media  drivers which are
      not cleaned up properly upon rmmmod?

    ...just few ideas (...  without any background on kernel dev ;-)


BR and many thx for your kernel development work!
  Martin



P.S.: Bisect log:

user@host:/a/b/c$ git bisect log
# bad: [64291f7db5bd8150a74ad2036f1037e6a0428df2] Linux 4.2
# good: [b953c0d234bc72e8489d3bf51a276c5c4ec85345] Linux 4.1
git bisect start 'v4.2' 'v4.1'
# bad: [c11d716218910c3aa2bac1bb641e6086ad649555] Merge tag 'armsoc-cleanup' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect bad c11d716218910c3aa2bac1bb641e6086ad649555
# good: [8a8c35fadfaf55629a37ef1a8ead1b8fb32581d2] mm: kmemleak_alloc_percpu() should follow the gfp from per_alloc()
git bisect good 8a8c35fadfaf55629a37ef1a8ead1b8fb32581d2
# good: [14738e03312ff1137109d68bcbf103c738af0f4a] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good 14738e03312ff1137109d68bcbf103c738af0f4a
# good: [4570a37169d4b44d316f40b2ccc681dc93fedc7b] Merge tag 'sound-4.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 4570a37169d4b44d316f40b2ccc681dc93fedc7b
# bad: [78aad7f81aa6dfccdb2804ac35db6fc371d265cf] [media] vivid-tpg: precalculate colorspace/xfer_func combinations
git bisect bad 78aad7f81aa6dfccdb2804ac35db6fc371d265cf
# good: [356484cabe44984d2dc66a90bd5e3465ba1f64fb] [media] dw2102: resync fifo when demod locks
git bisect good 356484cabe44984d2dc66a90bd5e3465ba1f64fb
# good: [e4aa18d33c3a05f9ac51a8c8c7863318c807650f] [media] DocBook: Improve the description of the properties API
git bisect good e4aa18d33c3a05f9ac51a8c8c7863318c807650f
# good: [e01dfc01914ab9a078ca8d08287c19c6663b5438] [media] videodev2.h: add COLORSPACE_DEFAULT
git bisect good e01dfc01914ab9a078ca8d08287c19c6663b5438
# good: [dc9ef7d11207a04514ca195f0c9f4d2ac56696e1] [media] DocBook media: rewrite frontend open/close
git bisect good dc9ef7d11207a04514ca195f0c9f4d2ac56696e1
# bad: [5ac417efe66ddd7cd70a98f7f4e32a14ae40a651] [media] sh_vou: avoid going past arrays
git bisect bad 5ac417efe66ddd7cd70a98f7f4e32a14ae40a651
# bad: [171fe6d1270d535eae798e4b5acc9f5d25e6e17e] [media] media: davinci_vpfe: set minimum required buffers to three
git bisect bad 171fe6d1270d535eae798e4b5acc9f5d25e6e17e
# good: [d2b72f6482b9a3c57f036c11786a2489dcc81176] [media] si2168: Implement own I2C adapter locking
git bisect good d2b72f6482b9a3c57f036c11786a2489dcc81176
# bad: [694f9963edd831e4ed6fdbcb7134525cf5715a79] [media] media: davinci_vpfe: clear the output_specs
git bisect bad 694f9963edd831e4ed6fdbcb7134525cf5715a79
# bad: [2f1ea29fca781b8e6600f3ece1f2dd98ae276294] [media] si2157: implement signal strength stats
git bisect bad 2f1ea29fca781b8e6600f3ece1f2dd98ae276294
# first bad commit: [2f1ea29fca781b8e6600f3ece1f2dd98ae276294] [media] si2157: implement signal strength stats

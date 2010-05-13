Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:42843 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104Ab0EMHsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 03:48:02 -0400
Subject: Re: Mercurial x git tree sync - was: Re: Remote control at Zolid
	Hybrid TV Tuner
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sander Pientka <cumulus0007@gmail.com>,
	linux-media@vger.kernel.org, Douglas Landgraf <dougsland@gmail.com>
In-Reply-To: <4BEB84F5.5030506@redhat.com>
References: <db09c9681002161116k52278916ob68884ddc989044@mail.gmail.com>
	 <1266375385.3176.5.camel@pc07.localdom.local>
	 <db09c9681002170838tdb15cbbu67cd45a518c11b4b@mail.gmail.com>
	 <1266445236.7202.17.camel@pc07.localdom.local>
	 <AANLkTin6b9JT1j0iNBmrp0UIhN9Z2Y-V6xdrEy7g5NQb@mail.gmail.com>
	 <4BEAFA76.5070809@redhat.com>
	 <1273721312.10695.12.camel@pc07.localdom.local>
	 <4BEB84F5.5030506@redhat.com>
Content-Type: text/plain
Date: Thu, 13 May 2010 09:37:33 +0200
Message-Id: <1273736253.3197.71.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Donnerstag, den 13.05.2010, 01:49 -0300 schrieb Mauro Carvalho
Chehab:
> hermann pitton wrote:
> > Am Mittwoch, den 12.05.2010, 15:59 -0300 schrieb Mauro Carvalho Chehab:
> >> Sander Pientka wrote:
> >>> Hi Hermann,
> >>>
> >>> I am going to revive this old thread, I completely forgot about it and
> >>> I still want to solve this problem.
> >>>
> >>> Yes, with the IR transmitter not plugged in, the gpio is reported as
> >>> 00000 by dmesg.
> >>>
> >>> I am aware there is a picture of the backside missing on the wiki, I
> >>> will try to make one a.s.a.p.
> >>>
> >>> NEC IR support seems to be built-in already: drivers/media/IR/ir-nec-decoder.c.
> >>>
> >>> Besides, dmesg outputs a section of error messages I don't understand:
> >>>
> >>> [ 1585.548221] tda18271_write_regs: ERROR: idx = 0x5, len = 1,
> >>> i2c_transfer returned: -5
> >>> [ 1585.548229] tda18271_toggle_output: error -5 on line 47
> >>> [ 1585.720118] tda18271_write_regs: ERROR: idx = 0x5, len = 1,
> >>> i2c_transfer returned: -5
> >>> [ 1585.720129] tda18271_init: error -5 on line 826
> >>> [ 1585.720136] tda18271_tune: error -5 on line 904
> >>> [ 1585.720141] tda18271_set_analog_params: error -5 on line 1041
> >>> [ 1586.381026] tda18271_write_regs: ERROR: idx = 0x6, len = 1,
> >>> i2c_transfer returned: -5
> >>> [ 1586.500589] tda18271_write_regs: ERROR: idx = 0x1d, len = 1,
> >>> i2c_transfer returned: -5
> >>> [ 1586.629447] tda18271_write_regs: ERROR: idx = 0x10, len = 1,
> >>> i2c_transfer returned: -5
> >>> [ 1586.629458] tda18271_channel_configuration: error -5 on line 160
> >>> [ 1586.629465] tda18271_set_analog_params: error -5 on line 1041
> >>>
> >>>
> >>> Do you have any idea about the origin of these errors? Do you think
> >>> they affect the IR functionality?
> >> The above errors won't change anything at IR side. For IR, the better approach
> >> is to start using raw_decode mode. I've enabled it only for Avermedia M135A, 
> >> since this is the board I'm using at the IR refactoring tests, but the same approach
> >> should work fine for any other saa7134 board that uses GPIO18 or GPIO16. For GPIO18,
> >> all you need is to use something like:
> >>
> >>         case SAA7134_BOARD_AVERMEDIA_M135A:
> >>                 ir_codes     = RC_MAP_AVERMEDIA_M135A_RM_JX;
> >>                 mask_keydown = 0x0040000;
> >>                 mask_keyup   = 0x0040000;
> >>                 mask_keycode = 0xffff;
> >>                 raw_decode   = 1;
> >>                 break;
> >>
> >> (Of course, replacing the board name by your board name (SAA7134_BOARD_ZOLID_HYBRID_PCI?),
> >> and pointing to the proper ir_codes table. You'll likely need to write one table for
> >> the IR that were shipped with your board.
> >>
> >> To do that, you'll need to enable debug at ir_core (modprobe ir_core debug=1), and type every
> >> key on your keyboard, associating the scancode number with a key name. See http://www.linuxtv.org/wiki/index.php/Remote_Controllers for a reference of the most comon keycodes.
> >>
> >> For example, pressing the power button of an IR I have here (for Leadtek PVR3000), it
> >> gives this info at the dmesg log:
> >> ir_nec_decode: NEC scancode 0x0300
> >>
> >> All I need to do is to write a new keymap:
> >>
> >> add a new media/rc-map.h
> >>
> >>
> >>  as, for example:
> >> 	drivers/media/IR/keymaps/rc-leadtek_pvr3000.c
> >> (copying one of the existing keymaps) and add:
> >>
> >> static struct ir_scancode leadtek_winfast_pvr3000_dlx[] = {
> >> 	{ 0x300, KEY_POWER2 },
> >>
> >> for every key that it is there. Then, add the new file at drivers/media/IR/keymaps/Makefile.
> >>
> >> I've tried to summarize the above patches on a change I just did at the wiki page. Feel 
> >> free to improve it, if needed.
> >>
> >> Cheers,
> >> Mauro
> > 
> > Hi Mauro,
> > 
> > what I did try to point to, with some sarcasm involved, is that I can't
> > advice any v4l-dvb as reference anymore.
> > 
> > To start to look such up, with all patches involved, per user, who
> > likely does not know himself on what he exactly is, find the last
> > building kernel for him then, guess on pending pull requests that time,
> > and so on, is not making any sense for me.
> > 
> > Should we not state, that is nothing against Douglas at all or Hans with
> > his build reports, please be on latest .rc and git to test anything we
> > have around?
> > 
> > We are out of sync else.
> 
> Hermann,
> 
> Sorry, but, sometimes, it is very hard to understand your English. I'm suspecting
> that you're referring to the sync between hg and git.
> 
> Short answer:
> ============
> 
>  - AFAIK, Douglas finished syncing the trees at the night of May, 12.
> 
>  - Developers primary reference tree:
> 	http://git.linuxtv.org/v4l-dvb.git
> 
>  - Backport tree:
> 	http://linuxtv.org/hg/v4l-dvb
> 
>    As the backport is manual, some delay is expected at the backport tree. Also,
> backports are made at the best efforts basis. So, nobody can warrant that the
> drivers will behave correctly with an old kernel. Also, eventually, the backport tree
> can break when compiled with an older kernel.
> 
>    Developers are encouraged to use git for development, but patches and pull
> requests against the backport tree are accepted.
> 
> Long answer:
> ===========
> 
> As I have about 100 pending patches at Patchwork, plus 4 or 5 pull requests not
> handled yet, mercurial tree will be soon out of sync. I'll try to merge most of the
> pending stuff during this weekend.
> 
> The main developers reference is -git. We merge all patches there. 
> So, new stuff arrives there before being backported.
> 
> That's said, we should be using git since 2.6.12, together with the kernel 
> community. By not using it, our merge process became very complex
> and it weren't scaling anymore. It is also impossible to merge the current
> embedded patches with -hg, since we would need to keep several arch trees
> inside hg, properly synchronized, which would make -hg tree very big
> and full of hacks.
> 
> Due to our late adoption of git on our development trees, we're still
> needing to adjust the process. I'll likely need to do some improvements for
> the next kernel cycle, since I'm still suffering some merge issues upstream,
> that will likely affect developers if I don't adjust the procedures.
> 
> The solution will likely be merging at git inside separate branches for separate
> topics.
> 
> I'm trying to keep one branch (currently, master) with the latest final kernel 
> version. For example, if you use it right now, it is the vanilla 2.6.33 kernel, 
> plus v4l-dvb new stuff. This allows not only developers to use, but also advanced
> users that know how to compile a kernel (that's not that hard: in general,
> "make oldconfig && make" is enough, if the distro kernel is not very old).
> 
> Unfortunately, I don't have any time anymore to maintain the backport tree. We've
> broke our record in terms of number of patches per release at -rc6: almost 
> 800 patches for linux next, on a shorter kernel development cycle. So, we had about
> 19 patches committed by day, 7 days by week, plus the ones that needed to be 
> re-designed, due to some troubles, plus all architectural discussions we're having
> about videobuf, events interface, mem2mem, etc.
> 
> I suspect that part of growth on the number of patches is due to the usage of git, as
> I'm seeing more upstream kernel hackers sending patches to drivers/media lately.
> 
> So, Douglas assumed the maintainership of the hg tree. As all upstream patches
> need to be backported, he's likely having a high demand bandwidth, because of the high 
> number of patches.
> 
> As far as I know (Douglas, please correct me if I'm wrong), he started by
> applying patches, testing against a selected number of legacy kernels and publish
> after the tests. Also, he needs to identify the origin of a patch before applying
> on his tree, to avoid breaking developers tree based on mercurial to require rebasing
> after his merge. Life would probably be easier for him if everybody would be generating
> patches against git when submitting upstream.
> 
> As people complained about the high delay, he decided just a few days ago 
> to just sync the tree, and then adding backport patches with the help of the 
> community. Of course, this means that the current -hg tree will compile only 
> against 2.6.33, until someone backports the tree to the earlier kernels.
> 
> I suspect that people will also complain about that. Not sure what strategy would
> be the better.
> 
> The fact is that, even with -hg, when we were close to the next merge window, the
> number of patches tend to increase (as everybody tries to send their code for the
> next merge window), and the need for backport increases, as other maintainers are
> always improving the kernel ABI's. So, during a period of up to 4 weeks (one or 
> two weeks before and the two weeks of the merge window), it would almost certain
> that backport support would be broken.
> 
> Anyway, it is up to Douglas to define what would be the better way to maintain the
> backport tree, as he is the one that is feeling all the pain of backporting
> stuff, of course listening to the community feedback. It would be nice if
> people could also help him by sending backport patches were needed.
> 

Hi Mauro, Sander, Douglas,

I can see all that.

But the question was very simple.

What revision of v4l-dvb I should have suggested to Sander on the day of
his request to work further on it?

I don't know, without very detailed input and a lot of looking up and
broken build as next condition. So I do suggest to go to .rc and latest
git. De facto it happened already.

If this is within Sander's plans, not only Devin did list some
shortcomings already for being on latest, I doubt. And a well maintained
2.6.18 seems to have still many fans :)

I also can see, on a first look, that Sander is not in sync with
Michael's latest.

More patches still come in from older stuff. (Compro T750/T750F, we run
into detection troubles again)

Until Douglas should complain, I'll stay quiet, but I guess it will turn
into some "stable" mercurial v4l-dvb release every few weeks and I doubt
to be interested to dig around in such and compare.

Gerd did hold the v4l backward compat on 2.4.x during the introduction
of v4l2, xawtv and nvrec have been the only working v4l2 apps for long,
tvtime followed then, somehow forced, and much later mplayer, with lots
of cries in between.

Full v4l1 compat, it always had bugs like the mute ioctl on saa713x, is
broken anyway since long on hybrid tuners, see fmtools on recent tuners.

I always was for it, to have the broadest possible testing base, but if
there is no clear fall back anymore, I luckily can miss support for a
few cards the OEMs never did care about.

Cheers,
Hermann
 





Cheers,
Hermann















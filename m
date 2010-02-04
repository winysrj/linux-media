Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36658 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105Ab0BDMyo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 07:54:44 -0500
Subject: Re: Videotext application crashes the kernel due to DVB-demux patch
From: Andy Walls <awalls@radix.net>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Chicken Shack <chicken.shack@gmx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>, obi@linuxtv.org
In-Reply-To: <1265158862.3194.22.camel@pc07.localdom.local>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 07:54:02 -0500
Message-Id: <1265288042.3928.9.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-02-03 at 02:01 +0100, hermann pitton wrote:
> Am Dienstag, den 02.02.2010, 07:52 -0500 schrieb Andy Walls:
> > On Tue, 2010-02-02 at 10:11 +0100, Chicken Shack wrote:
> > > Am Montag, den 01.02.2010, 21:00 -0500 schrieb Andy Walls:
> > > > On Mon, 2010-02-01 at 07:41 -0500, Andy Walls wrote:
> > > > > On Mon, 2010-02-01 at 10:56 +0100, Chicken Shack wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > here is a link to a patch which breaks backwards compatibility for a
> > > > > > teletext software called alevt-dvb.
> > > > > > 
> > > > > > http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg04638.html
> > > > > > 
> > > > > > The kernel patch was introduced with kernel 2.6.32-rc1.
> > > > > > It was Signed-off-by Brandon Philips, Mauro Carvalho Chehab and its
> > > > > > author, Andreas Oberritter.
> > > > > > 
> > > > 
> > > > > > Regards
> > > > > > 
> > > > > > CS
> > > > > > 
> > > > > > P. S.: This is how the kernel crash looks like:
> > > > > 
> > > > > The information below can get me started.  Could you please provide
> > > > > whole Ooops from the output dmesg or from your /var/log/messages file?
> > > > > 
> > > > > I'll try to look at this tonight.
> > > > > 
> > > > > Regards,
> > > > > Andy
> > > > > 
> > > > > > brian:~# alevt
> > > > > > alevt: SDT: service_id 0xcf24 not in PAT
> > 
> > > > > > alevt: ioctl: DMX_SET_PES_FILTER Invalid argument (22)
> > > > > > Getötet
> > > > > > brian:~# 
> > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > >  kernel:[  116.563487] Oops: 0000 [#1] PREEMPT SMP 
> > > > > > 
> > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > >  kernel:[  116.563492] last sysfs
> > > > > > file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-0:1.0/uevent
> > > > > > 
> > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > >  kernel:[  116.563589] Process alevt (pid: 1780, ti=e7934000
> > > > > > task=e7915be0 task.ti=e7934000)
> > > > > > 
> > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > >  kernel:[  116.563592] Stack:
> > > > > > 
> > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > >  kernel:[  116.563622] Call Trace:
> > > > > > 
> > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > >  kernel:[  116.563650] Code: f2 da 4c c8 8d 56 78 89 54 24 04 89 d0 e8
> > > > > > e4 da 4c c8 89 f0 e8 31 ff ff ff 83 7e 4c 01 76 73 83 7e 48 02 75 49 8b
> > > > > > 46 04 8d 48 f8 <8b> 41 08 8d 58 f8 8d 7e 04 eb 28 8b 41 08 8b 51 0c 89
> > > > > > 50 04 89 
> > > > 
> > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > >  kernel:[  116.563697] EIP: [<f8cec1b2>] dvb_demux_release+0x43/0x183
> > > > > > [dvb_core] SS:ESP 0068:e7935f58
> > > > > > 
> > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > >  kernel:[  116.563706] CR2: 0000000000000000
> > > > 
> > > > I don't have a 32 bti machine set up to compile the module and compare
> > > > the disassembly directly.  However, the kernel code above disassembles
> > > > to this, and is supposedly in dvb_demux_release() but things have been
> > > > inlined by the compiler:
> > > > 
> > > >   1c:	8d 56 78             	lea    0x78(%esi),%edx
> > > >   1f:	89 54 24 04          	mov    %edx,0x4(%esp)
> > > >   23:	89 d0                	mov    %edx,%eax
> > > >   25:	e8 e4 da 4c c8       	call   0xc84cdb0e
> > > >   2a:	89 f0                	mov    %esi,%eax
> > > >   2c:	e8 31 ff ff ff       	call   0xffffff62
> > > > 					(dmxdev.c:dvb_dmxdev_filter_reset() appears to be inlined starting here
> > > > 					 %esi holds dmxdevfilter)
> > > >   31:	83 7e 4c 01          	cmpl   $0x1,0x4c(%esi)    if (dmxdevfilter->state < DMXDEV_STATE_SET)
> > > >   35:	76 73                	jbe    0xaa               	return 0;
> > > >   37:	83 7e 48 02          	cmpl   $0x2,0x48(%esi)    if (dmxdevfilter->type == DMXDEV_TYPE_PES)
> > > >   3b:	75 49                	jne    0x86
> > > > 					(dvb_dmxdev_delete_pids() appears to be inlined starting here
> > > > 					 %esi still holds dmxdevfilter)
> > > >   3d:	8b 46 04             	mov    0x4(%esi),%eax     %eax gets loaded with &dmxdevfilter->feed.ts  for list_for_each_entry_safe(feed, tmp, &dmxdevfilter->feed.ts, ...
> > > >   40:	8d 48 f8             	lea    -0x8(%eax),%ecx    %ecx is "feed" and gets loaded with the next struct dmxdev_feed pointed to by the &dmxdevfilter->feed.ts list
> > > >   43:	8b 41 08             	mov    0x8(%ecx),%eax     Oops appears to happen here: %ecx and hence "feed" was (craftily?) set to 0xfffffff8 based on CR2 above
> > > >   46:	8d 58 f8             	lea    -0x8(%eax),%ebx
> > > >   49:	8d 7e 04             	lea    0x4(%esi),%edi
> > > >   4c:	eb 28                	jmp    0x76
> > > >   4e:	8b 41 08             	mov    0x8(%ecx),%eax
> > > >   51:	8b 51 0c             	mov    0xc(%ecx),%edx
> > > >   54:	89 50 04             	mov    %edx,0x4(%eax)
> > > > 
> > > > 
> > > > So there is something wrong with the list manipulations or, if needed,
> > > > locking around the the list manipulations of the list that was
> > > > introduced in the patch you identified as the problem.  That is what is
> > > > causing the Ooops on close().  It will take a some more scrutiny to see
> > > > what exactly is wrong.
> > 
> > With further thought, a very likely of a list's "next" pointer being
> > NULL would be either:
> > 
> > 1. Failing to init the "struct list_head" dmxdevfilter->feed.ts after
> > dmxdevfilter is first kzalloc()'ed.
> > 
> > 2. The other member of the dmxdevfilter->feed union being set to NULL
> > unexpectedly.  (less likely)
> > 
> > I'll look at these possibilities on Wednesday evening.
> > 

Schedule update: I'll be looking at this tonight (Thursday evening).
But maybe that was obvious by now....


> > > > There also may be another different problem.  I note that alevt outputs
> > > > this perror() message:
> > > > 
> > > > 	alevt: ioctl: DMX_SET_PES_FILTER Invalid argument (22)
> > > 
> > > > There may possibly have been an unintended change in ioctl() semantics
> > > > with the patch.  I have not investigated this at all yet.
> > > 
> > > 
> > > Voila!
> > > 
> > > This is the context of the perror message:
> > > 
> > > a. this is the title of the function:
> > > 
> > > static int vbi_dvb_open(struct vbi *vbi, const char *vbi_name,
> > > 	const char *channel, char *outfile, u_int16_t sid, int ttpid)
> > > 
> > > b. and this is the immediate context of the perror message:
> > > 
> > > 	memset(&filterpar, 0, sizeof(filterpar));
> > > 	filterpar.pid = vbi->ttpid;
> > >         filterpar.input = DMX_IN_FRONTEND;
> > >         filterpar.output = DMX_OUT_TAP;
> > >         filterpar.pes_type = DMX_PES_OTHER;
> > >         filterpar.flags = DMX_IMMEDIATE_START;
> > >         if (ioctl(vbi->fd, DMX_SET_PES_FILTER, &filterpar) < 0) {
> > >         error("ioctl: DMX_SET_PES_FILTER %s (%u)", strerror(errno),
> > > errno);
> > >         goto outerr;
> > >         }
> > > 	return 0;
> > > 
> > >  outerr:
> > > 	close(vbi->fd);
> > > 	vbi->fd = -1;
> > > 	return -1;
> > > }
> > > 
> > > If you compare that to other teletext applications you will easily find
> > > out that there is absolutely nothing irregular about it: all standard
> > > calls, free from bugs or syntax errors.
> > 
> > 
> > OK.  Thank you for hunting down the application call into the driver.
> > That should reduce the time to find the cause
> > 
> > 
> > > a. What is the "Invalid argument"?
> > > b. And what does "22" mean?
> > 
> > 22 is the errno value for EINVAL which means loosely mean "Invalid
> > Argument", but can often be used when something internally is just
> > "Invalid".
> > 
> > /usr/include/asm-generic/errno-base.h:#define	EINVAL		22	/* Invalid argument */
> > 
> > Given the ioctl() call you've documented above, it should be easy enough
> > to find where in the DVB subsystem the EINVAL is coming from.  And it is
> > likely that it is coming from code added by the patch, but I won't know
> > until I can examine further.
> > 
> > 
> > > Thanks for your engagement, Andy!
> > 
> > You're welcome.
> > 
> > 
> > > It's a golden donation to have people like you around!
> > 
> > Thank you.
> > 
> > Regards,
> > Andy
> 
> Hi Andy,
> 
> take care, such golden donations can turn into g**** s***** very soon.
                                                 
Hi Hermann,

You might want to avoid that two-word slang phrase in polite company,
with American English speakers at least.  Unless you are trying to make
a really shocking point. ;)

Language and cultural divides can be amusing at times. :)


> 
> Prefer to stay with the original author.
> 
> I think he is still alive ;)

I've added him to the Cc: list.

Regards,
Andy

> Cheers,
> Hermann



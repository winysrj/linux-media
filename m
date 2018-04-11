Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63236 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751546AbeDKQNv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 12:13:51 -0400
Date: Wed, 11 Apr 2018 13:13:44 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 04/29] media-request: core request support
Message-ID: <20180411131344.67b782a2@vento.lan>
In-Reply-To: <20180411153513.5r6foyfpzuipjfxw@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-5-hverkuil@xs4all.nl>
        <20180410073206.12d4c67d@vento.lan>
        <20180410123234.ifo6v23wztsslmdp@valkosipuli.retiisi.org.uk>
        <20180410115143.41178f68@vento.lan>
        <20180411132116.lmirivlarpy5lcv4@valkosipuli.retiisi.org.uk>
        <20180411104935.5f566f0f@vento.lan>
        <20180411150219.iywopjmdpytamfgy@valkosipuli.retiisi.org.uk>
        <20180411121727.60133066@vento.lan>
        <20180411153513.5r6foyfpzuipjfxw@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Apr 2018 18:35:14 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> On Wed, Apr 11, 2018 at 12:17:27PM -0300, Mauro Carvalho Chehab wrote:
> > Em Wed, 11 Apr 2018 18:02:19 +0300
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > On Wed, Apr 11, 2018 at 10:49:35AM -0300, Mauro Carvalho Chehab wrote:  
> > > > Em Wed, 11 Apr 2018 16:21:16 +0300
> > > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > > > 
> > > >     
> > > > > > > > Btw, this is a very good reason why you should define the ioctl to
> > > > > > > > have an integer argument instead of a struct with a __s32 field
> > > > > > > > on it, as per my comment to patch 02/29:
> > > > > > > > 
> > > > > > > > 	#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, int)
> > > > > > > > 
> > > > > > > > At 64 bit architectures, you're truncating the file descriptor!        
> > > > > > > 
> > > > > > > I'm not quite sure what do you mean. int is 32 bits on 64-bit systems as
> > > > > > > well.      
> > > > > > 
> > > > > > Hmm.. you're right. I was thinking that it could be 64 bits on some
> > > > > > archs like sparc64 (Tru64 C compiler declares it with 64 bits), but,
> > > > > > according with:
> > > > > > 
> > > > > > 	https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html
> > > > > > 
> > > > > > This is not the case on gcc.      
> > > > > 
> > > > > Ok. The reasoning back then was that what "int" means varies across
> > > > > compilers and languages. And the intent was to codify this to __s32 which
> > > > > is what the kernel effectively uses.    
> > > > 
> > > > ...
> > > >     
> > > > > The rest of the kernel uses int rather liberally in the uAPI so I'm not
> > > > > sure in the end whether something desirable was achieved. Perhaps it'd be
> > > > > good to go back to the original discussion to find out for sure.
> > > > > 
> > > > > Still binaries compiled with Tru64 C compiler wouldn't work on Linux anyway
> > > > > due to that difference.
> > > > > 
> > > > > Well, I stop here for this begins to be off-topic. :-)    
> > > > 
> > > > Yes. Let's keep it as s32 as originally proposed. Just ignore my comments
> > > > about that :-)
> > > >     
> > > > > > > > > +	get_task_comm(comm, current);
> > > > > > > > > +	snprintf(req->debug_str, sizeof(req->debug_str), "%s:%d",
> > > > > > > > > +		 comm, fd);        
> > > > > > > > 
> > > > > > > > Not sure if it is a good idea to store the task that allocated
> > > > > > > > the request. While it makes sense for the dev_dbg() below, it
> > > > > > > > may not make sense anymore on other dev_dbg() you would be
> > > > > > > > using it.        
> > > > > > > 
> > > > > > > The lifetime of the file handle roughly matches that of the request. It's
> > > > > > > for debug only anyway.
> > > > > > > 
> > > > > > > Better proposals are always welcome of course. But I think we should have
> > > > > > > something here that helps debugging by meaningfully making the requests
> > > > > > > identifiable from logs.      
> > > > > > 
> > > > > > What I meant to say is that one PID could be allocating the
> > > > > > request, while some other one could be actually doing Q/DQ_BUF.
> > > > > > On such scenario, the debug string could provide mislead prints.      
> > > > > 
> > > > > Um, yes, indeed it would no longer match the process. But the request is
> > > > > still the same. That's actually a positive thing since it allows you to
> > > > > identify the request.
> > > > > 
> > > > > With a global ID space this was trivial; you could just print the request
> > > > > ID and that was all that was ever needed. (I'm not proposing to consider
> > > > > that though.)
> > > > >     
> > > > 
> > > > IMO, a global ID number would work better than get_task_comm().
> > > > 
> > > > Just add a static int monotonic counter and use it for the debug purposes,
> > > > e. g.:
> > > > 
> > > > {
> > > > 	static unsigned int req_count = 0;
> > > > 
> > > > 	snprintf(req->debug_str, sizeof(req->debug_str), "%u:%d",
> > > > 		req_count++, fd);    
> > > > 
> > > > Ok, eventually, it will overflow, but, it will be unique within
> > > > a reasonable timeframe to be good enough for debugging purposes.    
> > > 
> > > Yes, but you can't figure out which process allocated it anymore, making
> > > associating kernel debug logs with user space process logs harder.
> > > 
> > > How about process id + file handle? That still doesn't tell which process
> > > operated on the request though, but I'm not sure whether that's really a
> > > crucial piece of information.  
> > 
> > You don't need that. With dev_dbg() - and other *_dbg() macros - you can
> > enable process ID for all debug messages.  
> 
> With this, the problem again is that it does not uniquely identify the
> request: the request is the same request independently of which process
> would operate on it. Or whether it is being processed in an interrupt
> context.
> 
> AFAICT, the allocator PID (or process name) + file handle are both required
> to match a request between user and kernel space logs.

Sorry, I was unable to understand what you're saying.

If you set the debug string with:

	snprintf(req->debug_str, sizeof(req->debug_str), "%u:%d", req_count++, fd);  

With the remaining stuff at patch 04/29, e. g. those two printks:

	dev_dbg(mdev->dev, "request: allocated %s\n", req->debug_str);
	dev_dbg(mdev->dev, "request: release %s\n", req->debug_str);

And use "+pt" to enable those debug messages, for the request #1 with fd #45, 
created by PID 16613 you would have a log like:

	[  269.021116] [16613] request: allocated 1:45
	[  269.024118] [16613] request: release 1:45

(assuming that the same PID would create and release)

The "1:45" is an unique global ID that would allow tracking it, even
if Q/DQ_BUF is done by some other PID.

E. g. if a PID#16618 were responsible for Q/DQ_BUF, you would have
something like:

	[  269.021116] [16613] request: allocated 1:45
	[  269.021117] [16618] request: Q_BUF 1:45
	[  269.021118] [16618] request: DQ_BUF 1:45
	[  269.024118] [16613] request: release 1:45

(assuming that you would have a Q_BUF/DQ_BUF similar dev_dbg())

That seems good enough to track it.

Yet, in order to make easier to track, I would actually change the
dev_dbg() parameter order everywhere to something like:

	dev_dbg(mdev->dev, "request#%s: allocated\n", req->debug_str)
	dev_dbg(mdev->dev, "request#%s: release\n", req->debug_str);

In order to print something like:

	[  269.021116] [16613] request#1:45: allocated 
	[  269.021117] [16618] request#1:45: Q_BUF
	[  269.021118] [16618] request#1:45: DQ_BUF
	[  269.024118] [16613] request#1:45: release

Then, getting everything related to the first request would be as simple as:

	$ dmesg|grep request#1:

That will provide the PID for both processes: the one that
created/released and the one that queued/dequeued.

Thanks,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46356
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbcGLNXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 09:23:11 -0400
Date: Tue, 12 Jul 2016 10:23:00 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 03/20] [media] lirc.h: remove several unused ioctls
Message-ID: <20160712102300.3bb0e6c4@recife.lan>
In-Reply-To: <20160712131406.GB10242@gofer.mess.org>
References: <cover.1468327191.git.mchehab@s-opensource.com>
	<d55f09abe24b4dfadab246b6f217da547361cdb6.1468327191.git.mchehab@s-opensource.com>
	<20160712131406.GB10242@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 Jul 2016 14:14:06 +0100
Sean Young <sean@mess.org> escreveu:

> On Tue, Jul 12, 2016 at 09:41:57AM -0300, Mauro Carvalho Chehab wrote:
> > While reviewing the documentation gaps on LIRC, it was
> > noticed that several ioctls aren't used by any LIRC drivers
> > (nor at staging or mainstream).
> > 
> > It doesn't make sense to document them, as they're not used
> > anywhere. So, let's remove those from the lirc header.  
> 
> Good to see these go.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  include/uapi/linux/lirc.h | 39 ++-------------------------------------
> >  1 file changed, 2 insertions(+), 37 deletions(-)
> > 
> > diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
> > index 4b3ab2966b5a..991ab4570b8e 100644
> > --- a/include/uapi/linux/lirc.h
> > +++ b/include/uapi/linux/lirc.h
> > @@ -90,20 +90,11 @@
> >  
> >  #define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
> >  #define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
> > -#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, __u32)
> > -#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, __u32)
> > -#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, __u32)
> > -#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, __u32)
> >  #define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
> >  
> >  #define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
> >  #define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
> >  
> > -#define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, __u32)
> > -#define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, __u32)
> > -#define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, __u32)
> > -#define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, __u32)
> > -
> >  /* code length in bits, currently only for LIRC_MODE_LIRCCODE */
> >  #define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
> >  
> > @@ -113,7 +104,6 @@
> >  #define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
> >  #define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
> >  #define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
> > -#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, __u32)  
> 
> Also remove LIRC_CAN_SET_REC_DUTY_CYCLE and 
> LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE.

Removing the "LIRC_CAN" macros can break userspace, as some app could
be using it to print the LIRC features. That's why I opted to keep
them, but to document that those features are unused - this is at
the next patch (04/20).

Thanks,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33390 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753523AbeF2M2K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:28:10 -0400
Date: Fri, 29 Jun 2018 09:28:04 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 02/10] media-ioc-g-topology.rst: document new 'index'
 field
Message-ID: <20180629092804.39892128@coco.lan>
In-Reply-To: <3a8508d8-29e4-3c0c-cf66-7a5e3d02dd83@xs4all.nl>
References: <20180628131208.28009-1-hverkuil@xs4all.nl>
        <20180628131208.28009-3-hverkuil@xs4all.nl>
        <20180629065415.2f0d7ec4@coco.lan>
        <3a8508d8-29e4-3c0c-cf66-7a5e3d02dd83@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 29 Jun 2018 12:26:50 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 06/29/18 11:54, Mauro Carvalho Chehab wrote:
> > Em Thu, 28 Jun 2018 15:12:00 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Document the new struct media_v2_pad 'index' field.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >>  .../media/uapi/mediactl/media-ioc-g-topology.rst      | 11 +++++++++--
> >>  1 file changed, 9 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> >> index a3f259f83b25..24ab34b22df2 100644
> >> --- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> >> +++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
> >> @@ -176,7 +176,7 @@ desired arrays with the media graph elements.
> >>      *  -  struct media_v2_intf_devnode
> >>         -  ``devnode``
> >>         -  Used only for device node interfaces. See
> >> -	  :c:type:`media_v2_intf_devnode` for details..
> >> +	  :c:type:`media_v2_intf_devnode` for details.
> >>  
> >>  
> >>  .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
> >> @@ -218,7 +218,14 @@ desired arrays with the media graph elements.
> >>         -  Pad flags, see :ref:`media-pad-flag` for more details.
> >>  
> >>      *  -  __u32
> >> -       -  ``reserved``\ [5]
> >> +       -  ``index``
> >> +       -  0-based pad index. Only valid if ``MEDIA_V2_PAD_HAS_INDEX(media_version)``
> >> +	  returns true. The ``media_version`` is defined in struct
> >> +	  :c:type:`media_device_info` and can be retrieved using
> >> +	  :ref:`MEDIA_IOC_DEVICE_INFO`.  
> > 
> > "0-based pad index"...
> > 
> > what you mean by that? If what you want to say is that it starts
> > with zero, I would use a clearer text, like:
> > 
> > "Pad index, starting from zero."  
> 
> This text is copied from media-ioc-enum-links.rst. I can rephrase it in both
> cases to this text. Although I don't think '0-based' is unclear, this even
> has its own wiki page: https://en.wikipedia.org/wiki/Zero-based_numbering

Well, it took me a while to understand what it was meant. As this is
a spec file, I prefer to use a more verbose word, in order to make
easier for people to understand what is written there.
> 
> > 
> > It is probably worth saying that the pad index could vary on newer
> > versions of the Kernel.  
> 
> I'll have to think how to phrase this.

Yeah, sure.

> 
> Regards,
> 
> 	Hans
> 
> >   
> >> +
> >> +    *  -  __u32
> >> +       -  ``reserved``\ [4]
> >>         -  Reserved for future extensions. Drivers and applications must set
> >>  	  this array to zero.
> >>    
> > 
> > 
> > 
> > Thanks,
> > Mauro
> >   
> 



Thanks,
Mauro

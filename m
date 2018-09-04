Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40206 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727104AbeIDUJC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 16:09:02 -0400
Date: Tue, 4 Sep 2018 18:43:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 1/3] uapi/linux/media.h: add property support
Message-ID: <20180904154320.xlbsrfxp4ex5nj47@valkosipuli.retiisi.org.uk>
References: <20180807102847.13200-1-hverkuil@xs4all.nl>
 <20180807102847.13200-2-hverkuil@xs4all.nl>
 <20180904130107.habwc3cti53eodqb@valkosipuli.retiisi.org.uk>
 <5a2e9988-6e9e-cfcb-ab35-9d2c7e734683@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a2e9988-6e9e-cfcb-ab35-9d2c7e734683@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Sep 04, 2018 at 03:50:33PM +0200, Hans Verkuil wrote:
> On 09/04/18 15:01, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > Thanks for the set.
> > 
> > On Tue, Aug 07, 2018 at 12:28:45PM +0200, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Add a new topology struct that includes properties.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  include/uapi/linux/media.h | 40 ++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 40 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> >> index 36f76e777ef9..1910c091601e 100644
> >> --- a/include/uapi/linux/media.h
> >> +++ b/include/uapi/linux/media.h
> >> @@ -342,6 +342,40 @@ struct media_v2_link {
> >>  	__u32 reserved[6];
> >>  } __attribute__ ((packed));
> >>  
> >> +#define MEDIA_PROP_TYPE_U64	1
> >> +#define MEDIA_PROP_TYPE_S64	2
> >> +#define MEDIA_PROP_TYPE_STRING	3
> >> +
> >> +/**
> >> + * struct media_v2_prop - A media property
> >> + *
> >> + * @id:		The unique non-zero ID of this property
> >> + * @owner_id:	The ID of the object this property belongs to
> > 
> > This assumes everything has a graph object ID. Speaking of "everything",
> > one of the use cases for this could be telling the user whether the media
> > device registration is finished.
> > 
> > One approach could be to create a special graph object with a constant ID
> > for that purpose. As the type is a part of the ID field, we could simply
> > create a new type of constant objects.
> 
> Why would you use properties for that? Why not just allow polling for
> exceptions (i.e. new events) on the media device node, similar to events
> for V4L2? It's very easy to use with select() et al.

Yes, that's needed; there was actually a support for media events on an
older version of my take of the request API.

But events are not all that's needed: how does the user know registration
has finished if it has already happened when the user opens a device?
Event-wise, I think a "topology change" event is all that's needed.

> 
> > On a sidenote, the proposed API effectively prohibits conveying structured
> > data. One use case for that would be to tell about camera modules. We don't
> > have that right now as part of the uAPI as there's nothing the kernel
> > currently knows about camera modules --- because there's nothing to control
> > there. The user space would still be interested in knowing quite a few
> > parameters of these devices which means the concept of the camera module
> > would be good to have in precisely this kind of an interface. What should
> > be there could in practice be what does the module contain (some of the
> > components are sub-devices whereas some would not be, such as an IR filter
> > or the lens) and their parameters (e.g. focal length).
> 
> You can easily (but indeed not yet implemented in this initial version) create
> hierarchical properties by simply setting the owner_id to a parent property.

Good point. For arrays we could e.g. add a new field to struct
media_v2_prop, called e.g. payload_length. I also think we should have the
size (and length) of the property in a specific unit, such as bytes, so the
parser does not have to know a given property type to determine it
correctly.

> 
> And you obviously need to carefully define and document how data is
> represented in properties.
> 
> If people feel strongly enough about this, then I can implement it in the
> next RFC. But I want feedback on this RFC first.

Feel free to go ahead with that but I'm fine with the current scope as
well. Just remember it was one of the use cases. :-)

> 
> > I'm not demanding this must be a part of the API in the beginning, however
> > this was one of the reasons why I originally proposed using JSON:
> > 
> > <URL:https://www.spinics.net/lists/linux-media/msg90160.html>
> > 
> > The downside with JSON would be that it does not fit very well with the
> > rest of the MC API.
> > 
> >> + * @type:	Property type
> >> + * @flags:	Property flags
> >> + * @payload_size: Property payload size, 0 for U64/S64
> >> + * @payload_offset: Property payload starts at this offset from &prop.id.
> >> + *		This is 0 for U64/S64.
> >> + * @reserved:	Property reserved field, will be zeroed.
> >> + * @name:	Property name
> >> + * @uval:	Property value (unsigned)
> >> + * @sval:	Property value (signed)
> >> + */
> >> +struct media_v2_prop {
> >> +	__u32 id;
> >> +	__u32 owner_id;
> >> +	__u32 type;
> >> +	__u32 flags;
> >> +	__u32 payload_size;
> >> +	__u32 payload_offset;
> >> +	__u32 reserved[18];
> > 
> > That's plenty. What is the typical size of the properties array for a media
> > device with, say, a few hundred entities with some four pads each, linked
> > with a single link on average?
> > 
> >> +	char name[32];
> > 
> > Is 32 enough? For controls and formats it's been sometimes a bit limiting.
> > 
> > Another approach could be to make this variable size, but that would make
> > parsing a little bit more complicated. As you already have separated the
> > property descriptor and the payload, that wouldn't be a major change
> > anymore.
> 
> I'll have to experiment a bit with that.
> 
> Thanks for looking at this!

Thanks for working on this! :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi

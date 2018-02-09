Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49106 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751071AbeBINE3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 08:04:29 -0500
Date: Fri, 9 Feb 2018 15:04:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 11/15] media-device.c: zero reserved field
Message-ID: <20180209130427.ocsu35areqlfawlo@valkosipuli.retiisi.org.uk>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-12-hverkuil@xs4all.nl>
 <20180209121700.67gibke64bgcewkn@valkosipuli.retiisi.org.uk>
 <8203381a-c3f1-d836-4ed1-54874ac7845e@xs4all.nl>
 <20180209124644.a6ygvfuamuspaqkm@valkosipuli.retiisi.org.uk>
 <22829e31-8bd5-5c49-5999-dc0e088e8309@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22829e31-8bd5-5c49-5999-dc0e088e8309@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Feb 09, 2018 at 01:52:50PM +0100, Hans Verkuil wrote:
> On 02/09/18 13:46, Sakari Ailus wrote:
> > On Fri, Feb 09, 2018 at 01:20:41PM +0100, Hans Verkuil wrote:
> >> On 02/09/18 13:17, Sakari Ailus wrote:
> >>> On Thu, Feb 08, 2018 at 09:36:51AM +0100, Hans Verkuil wrote:
> >>>> MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
> >>>> struct. Do so in media_device_setup_link().
> >>>>
> >>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>> ---
> >>>>  drivers/media/media-device.c | 2 ++
> >>>>  1 file changed, 2 insertions(+)
> >>>>
> >>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >>>> index e79f72b8b858..afbf23a19e16 100644
> >>>> --- a/drivers/media/media-device.c
> >>>> +++ b/drivers/media/media-device.c
> >>>> @@ -218,6 +218,8 @@ static long media_device_setup_link(struct media_device *mdev,
> >>>>  	if (link == NULL)
> >>>>  		return -EINVAL;
> >>>>  
> >>>> +	memset(linkd->reserved, 0, sizeof(linkd->reserved));
> >>>> +
> >>>
> >>> Doesn't media_device_enum_links() need the same for its reserved field?
> >>
> >> enum_links() already zeroes this (actually the whole media_link_desc struct is zeroed).
> > 
> > I can't see that being done in here and I also don't mean the compat
> > variant. Can you point me to it?
> > 
> 
> static long media_device_enum_links(struct media_device *mdev,
>                                     struct media_links_enum *links)
> {
>         struct media_entity *entity;
> 
>         entity = find_entity(mdev, links->entity);
>         if (entity == NULL)
>                 return -EINVAL;
> 
>         if (links->pads) {
> ...
>         }
> 
>         if (links->links) {
>                 struct media_link *link;
>                 struct media_link_desc __user *ulink_desc = links->links;
> 
>                 list_for_each_entry(link, &entity->links, list) {
>                         struct media_link_desc klink_desc;
> 
>                         /* Ignore backlinks. */
>                         if (link->source->entity != entity)
>                                 continue;
>                         memset(&klink_desc, 0, sizeof(klink_desc));
> 			// ^^^^^^^^^^^ zeroed here
> 	
>                         media_device_kpad_to_upad(link->source,
>                                                   &klink_desc.source);
>                         media_device_kpad_to_upad(link->sink,
>                                                   &klink_desc.sink);
>                         klink_desc.flags = link->flags;
>                         if (copy_to_user(ulink_desc, &klink_desc,
>                                          sizeof(*ulink_desc)))
> 			// ^^^^^^^ copied back to userspace (including zeroed reserved array) here

We are indeed talking about a different reserved field. I mean the one in
struct media_links_enum .

>                                 return -EFAULT;
>                         ulink_desc++;
>                 }
>         }
> 
>         return 0;
> }
> 
> Regards,
> 
> 	Hans

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

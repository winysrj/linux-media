Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:27118 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751689AbdLALR6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 06:17:58 -0500
Date: Fri, 1 Dec 2017 13:17:55 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: notifier is skipped in some situations
Message-ID: <20171201111755.7gzjymv3hsldanho@paasikivi.fi.intel.com>
References: <CAFLEztQg2R0oLcSfRKsQGFWTC1pTzPVqoksdKtGAYEYV6nAf9A@mail.gmail.com>
 <7578236.BQvekhbvUq@macbookair>
 <20171129122903.2lotgehifhs66bvh@paasikivi.fi.intel.com>
 <8641274.XBun1tTRXh@macbookair>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8641274.XBun1tTRXh@macbookair>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

On Thu, Nov 30, 2017 at 09:37:06AM +0800, Jacob Chen wrote:
> Hi Sakari,
> 
> On 2017年11月29日星期三 CST 下午2:29:03 you wrote:
> > Hi Jacob,
> > 
> > On Mon, Nov 27, 2017 at 03:03:59PM +0800, Jacob Chen wrote:
> > > Hi,
> > > 
> > > On 2017年11月25日星期六 CST 下午1:05:42 you wrote:
> > > > Hi,
> > > > 
> > > > On 2017年11月24日星期五 CST 下午6:19:36 you wrote:
> > > > > On Fri, Nov 24, 2017 at 6:17 PM, Sakari Ailus
> > > > > 
> > > > > <sakari.ailus@linux.intel.com> wrote:
> > > > > > Hi Tomasz,
> > > > > > 
> > > > > > On Fri, Nov 24, 2017 at 06:03:26PM +0900, Tomasz Figa wrote:
> > > > > >> Hi Sakari,
> > > > > >> 
> > > > > >> We have the following graph:
> > > > > >>     ISP (registers notifier for v4l2_dev)
> > > > > >>     
> > > > > >>     
> > > > > >>     
> > > > > >>     PHY (registers notifier for v4l2_subdev, just like sensors for
> > > > > >> 
> > > > > >> flash/focuser)
> > > > > >> 
> > > > > >>   |       \
> > > > > >> 
> > > > > >> sensor0   sensor1
> > > > > >> 
> > > > > >> ...
> > > > > >> 
> > > > > >> Both ISP and PHY are completely separate drivers not directly aware
> > > > > >> of
> > > > > >> each other, since we have several different PHY IP blocks that we
> > > > > >> need
> > > > > >> to support and some of them are multi-functional, such as CSI+DSI
> > > > > >> PHY
> > > > > >> and need to be supported by drivers independent from the ISP
> > > > > >> driver.
> > > > > > 
> > > > > > That should work fine. In the above case there are two notifiers,
> > > > > > indeed,
> > > > > > but they're not expecting the *same* sub-devices.
> > > > > 
> > > > > Got it.
> > > > > 
> > > > > Jacob, could you make sure there are no mistakes in the Device Tree
> > > > > source?
> > > > > 
> > > > > Best regards,
> > > > > Tomasz
> > > > 
> > > > I see...
> > > > This problem might be sloved by moving
> > > > `v4l2_async_subdev_notifier_register` after
> > > > `v4l2_async_register_subdev`. I will test it.
> > > > 
> > > > > > What this could be about is that in some version of the set I
> > > > > > disabled
> > > > > > the
> > > > > > complete callback on the sub-notifiers for two reasons: there was no
> > > > > > need
> > > > > > seen for them and the complete callback is problematic in general
> > > > > > (there's
> > > > > > been discussion on that, mostly related to earlier versions of the
> > > > > > fwnode
> > > > > > parsing patchset, on #v4l and along the Renesas rcar-csi2
> > > > > > patchsets).
> > > > > > 
> > > > > >> Best regards,
> > > > > >> Tomasz
> > > > > >> 
> > > > > >> 
> > > > > >> On Fri, Nov 24, 2017 at 5:55 PM, Sakari Ailus
> > > > > >> 
> > > > > >> <sakari.ailus@linux.intel.com> wrote:
> > > > > >> > Hi Jacob,
> > > > > >> > 
> > > > > >> > On Fri, Nov 24, 2017 at 09:00:14AM +0800, Jacob Chen wrote:
> > > > > >> >> Hi Sakari,
> > > > > >> >> 
> > > > > >> >> I encountered a problem when using async sub-notifiers.
> > > > > >> >> 
> > > > > >> >> It's like that:
> > > > > >> >>     There are two notifiers, and they are waiting for one
> > > > > >> >>     subdev.
> > > > > >> >>     When this subdev is probing, only one notifier is completed
> > > > > >> >>     and
> > > > > >> >> 
> > > > > >> >> the other one is skipped.
> > > > > >> > 
> > > > > >> > Do you have a graph that has two master drivers (that register
> > > > > >> > the
> > > > > >> > notifier) and both are connected to the same sub-device? Could
> > > > > >> > you
> > > > > >> > provide
> > > > > >> > exact graph you have?
> > > > > >> > 
> > > > > >> >> I found that in v15 of patch "v4l: async: Allow binding
> > > > > >> >> notifiers to
> > > > > >> >> sub-devices", "v4l2_async_notifier_complete" is replaced by
> > > > > >> >> v4l2_async_notifier_call_complete, which make it only complete
> > > > > >> >> one
> > > > > >> >> notifier.
> > > > > >> >> 
> > > > > >> >> Why is it changed? Can this be fixed?
> > > > > >> > 
> > > > > >> > --
> > > > > >> > Sakari Ailus
> > > > > >> > sakari.ailus@linux.intel.com
> > > > > > 
> > > > > > --
> > > > > > Sakari Ailus
> > > > > > sakari.ailus@linux.intel.com
> > > 
> > > I make a mistake, they are not expecting same subdev.....
> > > 
> > > The problem is that a notifier regsitered by
> > > `v4l2_async_subdev_notifier_register` will never be completed, becuase
> > > 1.`notifier->waiting` is always not empty, so
> > > v4l2_async_notifier_try_complete won't be called.
> > > 2. In old code, it's called by its parent, but now it won't.
> > 
> > Could you provide a bit more context, what exactly fails and in which order
> > the notifiers are registered and async sub-device matches are found?
> > 
> 
> The order doesn't matter.
> Both of below orders will fail.
> 1.
> v4l2_async_notifier_parse_fwnode_endpoints_by_port(NOTIFIER1)
> v4l2_async_subdev_notifier_register(NOTIFIER1, PHY)
> v4l2_async_register_subdev(PHY)
> 
> 1.
> v4l2_async_register_subdev(PHY)
> v4l2_async_notifier_parse_fwnode_endpoints_by_port(NOTIFIER1)
> v4l2_async_subdev_notifier_register(NOTIFIER1, PHY)
> 
> found Match:
> NOTIFIER1 --> SENSOR
> 
> dts:
> PHY --> SENSOR
> 
> By having a quick look at the code, i don't find a way that a notifier 
> regsitered by v4l2_async_subdev_notifier_register can be completed.

That's right. As I previously explained, it is a design decision not to
support complete callback for sub-device notifiers. This is also
documented in KernelDoc for struct v4l2_async_notifier_operations but it
could be added to v4l2_async_subdev_notifier_register for clarity.

Do you have a particular need for calling the complete callback for the
sub-device notifier?

> 
> 
> > > > static int v4l2_async_notifier_try_complete(
> > > > 
> > > > 	struct v4l2_async_notifier *notifier)
> > > > 
> > > > {
> > > > 
> > > > 	/* Quick check whether there are still more sub-devices here. */
> > > > 	if (!list_empty(&notifier->waiting))
> > > > 	
> > > > 		return 0;
> > > 
> > > not empty
> > > 
> > > > static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
> > > > 
> > > > 				   struct v4l2_device *v4l2_dev,
> > > > 				   struct v4l2_subdev *sd,
> > > > 				   struct v4l2_async_subdev *asd)
> > > > 
> > > > {
> > > > 
> > > > 	struct v4l2_async_notifier *subdev_notifier;
> > > > 	int ret;
> > > > 	
> > > > 	ret = v4l2_device_register_subdev(v4l2_dev, sd);
> > > > 	if (ret < 0)
> > > > 	
> > > > 		return ret;
> > > > 	
> > > > 	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
> > > > 	if (ret < 0) {
> > > > 	
> > > > 		v4l2_device_unregister_subdev(sd);
> > > > 		return ret;
> > > > 	
> > > > 	}
> > > > 	
> > > > 	/* Remove from the waiting list */
> > > > 	list_del(&asd->list);
> > > 
> > > asd is removed from the waiting list in `v4l2_async_match_notify`, but
> > > 
> > > >static int v4l2_async_notifier_try_all_subdevs(
> > > >
> > > >	struct v4l2_async_notifier *notifier)
> > > >
> > > >{
> > > >
> > > >	...
> > > >	if (!v4l2_dev)
> > > >	
> > > >		return 0;
> > > 
> > > A notifier regsitered by  `v4l2_async_subdev_notifier_register` will
> > > return in here.
> > > 
> > > >	...
> > > >	
> > > >		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
> > > >
> > > >int v4l2_async_register_subdev(struct v4l2_subdev *sd)
> > > >{
> > > >
> > > >	...
> > > >	list_for_each_entry(notifier, &notifier_list, list) {
> > > >	
> > > >		struct v4l2_device *v4l2_dev =
> > > >		
> > > >			v4l2_async_notifier_find_v4l2_dev(notifier);
> > > >		
> > > >		struct v4l2_async_subdev *asd;
> > > >		
> > > >		if (!v4l2_dev)
> > > >		
> > > >			continue;
> > > 
> > > same
> > > 
> > > >		asd = v4l2_async_find_match(notifier, sd);
> > > >		if (!asd)
> > > >		
> > > >			continue;
> > > >		
> > > >		ret = v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
> > > >		
> > > >					      asd);
> 
> 
> 
> 

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com

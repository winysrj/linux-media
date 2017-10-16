Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:25354 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdJPNCt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 09:02:49 -0400
Date: Mon, 16 Oct 2017 16:02:45 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v14 20/28] v4l: fwnode: Add a helper function to obtain
 device / integer references
Message-ID: <20171016130244.stisr7g65hcbxwiz@paasikivi.fi.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-21-sakari.ailus@linux.intel.com>
 <fbd2f71d-aa6d-08ef-1723-132864bde27b@xs4all.nl>
 <20170926113029.eh5i4sp6we6lvgow@paasikivi.fi.intel.com>
 <4363f544-d1ec-68e4-1edf-9a16b3cdb1ea@xs4all.nl>
 <20171010112710.noq6a4ktjqzt5u22@valkosipuli.retiisi.org.uk>
 <d8a48273-7a19-0f83-4a4d-8058b7a59e0e@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8a48273-7a19-0f83-4a4d-8058b7a59e0e@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Oct 10, 2017 at 03:07:29PM +0200, Hans Verkuil wrote:
> On 10/10/2017 01:27 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Mon, Oct 09, 2017 at 02:06:55PM +0200, Hans Verkuil wrote:
> >> Hi Sakari,
> >>
> >> My reply here is also valid for v15.
> >>
> >> On 26/09/17 13:30, Sakari Ailus wrote:
> >>> Hi Hans,
> >>>
> >>> Thanks for the review.
> >>>
> >>> On Tue, Sep 26, 2017 at 10:47:40AM +0200, Hans Verkuil wrote:
> >>>> On 26/09/17 00:25, Sakari Ailus wrote:
> >>>>> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> >>>>> the device's own fwnode, it will follow child fwnodes with the given
> >>>>> property-value pair and return the resulting fwnode.
> >>>>>
> >>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>>>> ---
> >>>>>  drivers/media/v4l2-core/v4l2-fwnode.c | 201 ++++++++++++++++++++++++++++++++++
> >>>>>  1 file changed, 201 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> >>>>> index f739dfd16cf7..f93049c361e4 100644
> >>>>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> >>>>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> >>>>> @@ -578,6 +578,207 @@ static int v4l2_fwnode_reference_parse(
> >>>>>  	return ret;
> >>>>>  }
> >>>>>  
> >>>>> +/*
> >>>>> + * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
> >>>>> + *					arguments
> >>>>> + * @dev: struct device pointer
> >>>>> + * @notifier: notifier for @dev
> >>>>> + * @prop: the name of the property
> >>>>> + * @index: the index of the reference to get
> >>>>> + * @props: the array of integer property names
> >>>>> + * @nprops: the number of integer property names in @nprops
> >>>>> + *
> >>>>> + * Find fwnodes referred to by a property @prop, then under that
> >>>>> + * iteratively, @nprops times, follow each child node which has a
> >>>>> + * property in @props array at a given child index the value of which
> >>>>> + * matches the integer argument at an index.
> >>>>
> >>>> "at an index". Still makes no sense to me. Which index?
> >>>
> >>> How about this:
> >>>
> >>> First find an fwnode referred to by the reference at @index in @prop.
> >>>
> >>> Then under that fwnode, @nprops times, for each property in @props,
> >>> iteratively follow child nodes starting from fwnode such that they have the
> >>> property in @props array at the index of the child node distance from the
> >>
> >> distance? You mean 'instance'?
> > 
> > No. It's a tree structure: this is the distance between a node in the tree
> > and the root node (i.e. device's fwnode).
> > 
> >>
> >>> root node and the value of that property matching with the integer argument of
> >>> the reference, at the same index.
> >>
> >> You've completely lost me. About halfway through this sentence my brain crashed :-)
> > 
> > :-D
> > 
> > Did keeping distance have any effect?
> 
> No :-)
> 
> "the index of the child node distance from the root node": I have absolutely
> no idea how to interpret that.

This index is referring to the properties array and its value is the same
as the distance of the child node from the device's root node.

> 
> > 
> >>
> >>>
> >>>>
> >>>>> + *
> >>>>> + * For example, if this function was called with arguments and values
> >>>>> + * @dev corresponding to device "SEN", @prop == "flash-leds", @index
> >>>>> + * == 1, @props == { "led" }, @nprops == 1, with the ASL snippet below
> >>>>> + * it would return the node marked with THISONE. The @dev argument in
> >>>>> + * the ASL below.
> >>>>
> >>>> I know I asked for this before, but can you change the example to one where
> >>>> nprops = 2? I think that will help understanding this.
> >>>
> >>> I could do that but then the example no longer corresponds to any actual
> >>> case that exists at the moment. LED nodes will use a single integer
> >>> argument and lens-focus nodes none.
> >>
> >> So? The example is here to understand the code and it doesn't have to be
> >> related to actual hardware for a mainlined driver.
> > 
> > This isn't about hardware, the definitions being parsed currently aren't
> > specific to any single piece of hardware. I could add an example which does
> > not exist, that's certainly possible. But I fail to see how it'd help
> > while the contrary could well be the case.
> 
> It helps to relate the code (and the comments for that matter) to what is in
> the ACPI. In fact, if you can make such an example, then I can see if I can
> come up with a better description.

Hmm. I thought about the example, and figured out the graph data structure
could be parsed using this function as well. From
Documentation/acpi/dsd/graph.txt:

    Scope (\_SB.PCI0.I2C2)
    {
	Device (CAM0)
	{
	    Name (_DSD, Package () {
		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		Package () {
		    Package () { "compatible", Package () { "nokia,smia" } },
		},
		ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
		Package () {
		    Package () { "port0", "PRT0" },
		}
	    })
	    Name (PRT0, Package() {
		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		Package () {
		    Package () { "port", 0 },
		},
		ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
		Package () {
		    Package () { "endpoint0", "EP00" },
		}
	    })
	    Name (EP00, Package() {
		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		Package () {
		    Package () { "endpoint", 0 },
		    Package () { "remote-endpoint", Package() { \_SB.PCI0.ISP, 4, 0 } },
		}
	    })
	}
    }

    Scope (\_SB.PCI0)
    {
	Device (ISP)
	{
	    Name (_DSD, Package () {
		ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
		Package () {
		    Package () { "port4", "PRT4" },
		}
	    })

	    Name (PRT4, Package() {
		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		Package () {
		    Package () { "port", 4 }, /* CSI-2 port number */
		},
		ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
		Package () {
		    Package () { "endpoint0", "EP40" },
		}
	    })

	    Name (EP40, Package() {
		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		Package () {
		    Package () { "endpoint", 0 },
		    Package () { "remote-endpoint", Package () { \_SB.PCI0.I2C2.CAM0, 0, 0 } },
		}
	    })
	}
    }

>From the EP40 node under ISP device, you could parse the graph remote
endpoint using v4l2_fwnode_reference_get_int_prop with these arguments (the
argument dev changed to fwnode in an earlier version of the patch, I'll
address that soon as well):

 @fwnode: fwnode referring to EP40 under ISP.
 @prop: "remote-endpoint"
 @index: 0
 @props: "port", "endpoint"
 @nprops: 2

And you'd get back fwnode referring to EP00 under CAM0.

The same works the other way around: if you use EP00 under CAM0 as the
fwnode, you'll get fwnode referring to EP40 under ISP.

If the remote-endpoint property would have additional references beyond the
first one, then incrementing index could be used to obtain them. The graph
bindings don't allow this though.

This function can be eventually moved to the ACPI framework, but doing that
right now would probably one kernel release delay for the functionality.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com

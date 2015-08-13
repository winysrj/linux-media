Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45170 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbbHMR2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 13:28:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helen Fornazier <helen.fornazier@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: VIMC: API proposal, configuring the topology through user space
Date: Thu, 13 Aug 2015 20:29:08 +0300
Message-ID: <3882390.gpLl9TToUt@avalon>
In-Reply-To: <CAPW4XYYLUNWw6njGJ29zzehRaZKV9uECmVEvEOBz2Y02NnRG9w@mail.gmail.com>
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com> <20150811063626.76689791@recife.lan> <CAPW4XYYLUNWw6njGJ29zzehRaZKV9uECmVEvEOBz2Y02NnRG9w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 11 August 2015 17:07:04 Helen Fornazier wrote:
> On Tue, Aug 11, 2015 at 6:36 AM, Mauro Carvalho Chehab wrote:
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >> On 08/10/15 19:21, Helen Fornazier wrote:
> >>> On Mon, Aug 10, 2015 at 10:11 AM, Hans Verkuil wrote:
> >>>> On 08/08/2015 03:55 AM, Helen Fornazier wrote:
> >>>>> Hi!
> >>>>> 
> >>>>> I've made a first sketch about the API of the vimc driver (virtual
> >>>>> media controller) to configure the topology through user space.
> >>>>> As first suggested by Laurent Pinchart, it is based on configfs.
> >>>>> 
> >>>>> I would like to know you opinion about it, if you have any suggestion
> >>>>> to improve it, otherwise I'll start its implementation as soon as
> >>>>> possible. This API may change with the MC changes and I may see other
> >>>>> possible configurations as I implementing it but here is the first
> >>>>> idea of how the API will look like.
> >>>>> 
> >>>>> vimc project link: https://github.com/helen-fornazier/opw-staging/
> >>>>> For more information: http://kernelnewbies.org/LaurentPinchart
> >>>>> 
> >>>>> /***********************
> >>>>> The API:
> >>>>> ************************/
> >>>>> 
> >>>>> In short, a topology like this one: http://goo.gl/Y7eUfu
> >>>>> Would look like this filesystem tree: https://goo.gl/tCZPTg
> >>>>> Txt version of the filesystem tree: https://goo.gl/42KX8Y
> >>>>> 
> >>>>> * The /configfs/vimc subsystem
> >>>> 
> >>>> I haven't checked the latest vimc driver, but doesn't it support
> >>>> multiple instances, just like vivid? I would certainly recommend that.
> >>> 
> >>> Yes, it does support
> >>> 
> >>>> And if there are multiple instances, then each instance gets its own
> >>>> entry in configfs: /configs/vimc0, /configs/vimc1, etc.
> >>> 
> >>> You are right, I'll add those
> >>> 
> >>>>> The vimc driver registers a subsystem in the configfs with the
> >>>>> 
> >>>>> following contents:
> >>>>>         > ls /configfs/vimc
> >>>>>         build_topology status
> >>>>> 
> >>>>> The build_topology attribute file will be used to tell the driver the
> >>>>> configuration is done and it can build the topology internally
> >>>>> 
> >>>>>         > echo -n "anything here" > /configfs/vimc/build_topology
> >>>>> 
> >>>>> Reading from the status attribute can have 3 different classes of
> >>>>> outputs
> >>>>> 1) deployed: the current configured tree is built
> >>>>> 2) undeployed: no errors, the user has modified the configfs tree
> >>>>> thus the topology was undeployed
> >>>>> 3) error error_message: the topology configuration is wrong
> >>>> 
> >>>> I don't see the status file in the filesystem tree links above.
> >>> 
> >>> Sorry, I forgot to add
> >>> 
> >>>> I actually wonder if we can't use build_topology for that: reading it
> >>>> will just return the status.
> >>> 
> >>> Yes we can, I was just wondering what should be the name of the file,
> >>> as getting the status from reading the build_topology file doesn't
> >>> seem much intuitive
> >> 
> >> I'm not opposed to a status file, but it would be good to know what
> >> Laurent thinks.
> >> 
> >>>> What happens if it is deployed and you want to 'undeploy' it? Instead
> >>>> of writing anything to build_topology it might be useful to write a
> >>>> real command to it. E.g. 'deploy', 'destroy'.
> >>>> 
> >>>> What happens when you make changes while a topology is deployed?
> >>>> Should such changes be rejected until the usecount of the driver goes
> >>>> to 0, or will it only be rejected when you try to deploy the new
> >>>> configuration?
> >>> 
> >>> I was thinking that if the user try changing the topology, or it will
> >>> fail (because the device instance is in use) or it will undeploy the
> >>> old topology (if the device is not in use). Then a 'destroy' command
> >>> won't be useful, the user can just unload the driver when it won't be
> >>> used anymore,
> > 
> > Well, we're planning to add support for dynamic addition/removal of
> > entities, interfaces, pads and links. So, instead of undeploy the
> > old topology, one could just do:
> >         rm -rf <part of the tree>
> 
> I think I misunderstood the word dynamic here. Do you mean that
> entities/interfaces/pads/link could be created/removed while their
> file handlers are opened? While an instance (lets say vimc2) is being
> used?

Let's keep in mind that what can appear or disappear at runtime in an 
uncontrolled manner are hardware blocks. The associated media_entity instances 
will of course need to be created and destroyed, but we have control over that 
in the sense that the kernel controls the lifetime of those structures.

For the vimc driver hardware addition and removal is emulated using the 
userspace API. The API thus needs to support

- adding a complete device
- removing a complete device
- adding a hardware block
- removing a hardware block

The last two operations can't be implemented before we add support for them in 
the MC core, but the API needs to be designed in a way to allow them.

> >> If you have multiple vimc instances and you want to 'destroy' the
> >> topology of only one instance, then you can't rmmod the module.
> > 
> > You can still use "rm" remove just one entire instance of the topology.
> 
> Just to be clear:
> They way I was thinking was: the user do the mkdir/rmdir/echo/cat as
> he likes, if some file handler is opened in some device then
> rmdir/mkdir/echo would fail in the folder related to that device:
> 
> Lets say we have
> /configfs/vimc/vimc0/ent/name
> /configfs/vimc/vimc1/ent/name
> /configfs/vimc/vimc1/ent_debayer/name
> 
> if some file related to vimc0 is opened, then "echo foo >
> /configfs/vimc/vimc0/ent/name" would fail.
> But "echo foo > /configfs/vimc/vimc1/ent/name" would work (assuming we
> are not using the filehandlers of vimc1)

I don't think we should support modifying properties such as names or roles at 
runtime as they're supposed to be fixed.

> If the user wants to remove vimc1 (as he is not using it anyway), then just:
> $ rmdir -r /configfs/vimc/vimc1

'rmdir -r' will recursively traverse the directories and remove all files from 
userspace, which will likely not work nicely. If configfs allows removing a 
non-empty directory then just rmdir should work, but might still not be the 
right solution.

> I don't see a big reason to explicitly undeploy a topology (without
> removing the folders) other then to modify the topology.
> Then when the user changes the filesystem tree, it undeploys the
> topology automatically:
> 
> $ echo "foo" > /configfs/vimc/vimc1/build_topology # here the topology
> of vimc1 will be deployed
> $ rmdir /configfs/vimc/vimc1/ent_debayer # here the topology will be
> undeployed, or this command will fail if vimc1 is in use
> $ echo "foo" > /configfs/vimc/vimc1/build_topology # here the topology
> of the instance vimc1 will be deployed again without the ent_debayer
> entity (assuming the previous command worked)
> 
> Unless it is interesting to easy simulate a disconnect (undeploy) and
> reconnect with the same topology (deploy) without the need to erase
> the /configfs/vimc/vimc0 and re-construct it again, is this
> interesting?
> 
> If it is interesting, then an explicit command to undeploy will indeed
> be better, otherwise we can always erase and reconstruct the folders
> tree outside the kernel with a script.

Undeploying has the advantage to make the API symmetrical, it would at least 
feel cleaner.

> >> I think I would prefer to have proper commands for the build_topology
> >> file. It would also keep the state handling of the driver simple: it's
> >> either deployed or undeployed, and changes to the topology can only
> >> take place if it is undeployed.
> 
> This is simpler to implement, and it seems secure, I could do like
> this in the first version and we see later how to improve it.
> 
> >> Commands for build_topology can be:
> >> 
> >> deploy: deploy the current topology
> >> 
> >> undeploy: undeploy the current topology. but keep the topology, allowing
> >> the user to make changes
> >> 
> >> destroy: undeploy the current topology and remove it, giving the user a
> >> clean slate.
> 
> What do you mean by "remove it" in the destroy command?
> To completely remove an instance the user could just rmdir
> /configfs/vimc5, or do you see another feature?

If destroy is indeed just undeploy + rmdir I wouldn't implement it.

> >> Feel free to come up with better command names :-)
> >> 
> >>>>> * Creating an entity:
> >>>>> 
> >>>>> Use mkdir in the /configfs/vimc to create an entity representation,
> >>>>> e.g.:
> >>>>>         > mkdir /configfs/vimc/sensor_a
> >>>>> 
> >>>>> The attribute files will be created by the driver through configfs:
> >>>>>         > ls /configfs/vimc/sensor_a
> >>>>>         name role
> >>>>> 
> >>>>> Configure the name that will appear to the /dev/media0 and what this
> >>>>> node do (debayer, scaler, capture, input, generic)
> >>>>> 
> >>>>>         > echo -n "Sensor A" > /configfs/vimc/sensor_a/name
> >>>>>         > echo -n "sensor" > /configfs/vimc/sensor_a/role
> >>>>> 
> >>>>> * Creating a pad:
> >>>>> Use mkdir inside an entity's folder, the attribute called "direction"
> >>>>> 
> >>>>> will be automatically created in the process, for example:
> >>>>>         > mkdir /configfs/vimc/sensor_a/pad_0
> >>>>>         > ls /configfs/vimc/sensor_a/pad_0
> >>>>>         direction
> >>>>>         > echo -n "source" > /configfs/vimc/sensor_a/pad_0/direction
> >>>>> 
> >>>>> The direction attribute can be "source" or "sink"
> >>>> 
> >>>> Hmm. Aren't the pads+direction dictated by the entity role? E.g. a
> >>>> sensor will only have one pad which is always a source. I think
> >>>> setting the role is what creates the pad directories + direction
> >>>> files.
> >>> 
> >>> I thought that we could add as many pads that we want, having a scaler
> >>> with two or more sink pads (for example) in the same format that
> >>> scales the frames coming from any sink pad and send it to its source
> >>> pads, no?
> >>> Maybe it is better if we don't let this choice.
> >> 
> >> I'd leave this out. Entities have a fixed number of pads that's
> >> determined by their IP or HW. I think we should match that in vimc. It
> >> also simplifies configuring the topology since these pads will appear
> >> automatically.
> >> 
> >>> I need to check if I can modify the configfs dynamically, I mean, if
> >>> the user writes "debayer" to the role file, I need to create at least
> >>> one folder (or file) to allow the user to configure the link flag
> >>> related to its source pad, but if in the future we have another entity
> >>> role (lets say "new_entity") that has more then one source pad, and
> >>> the user writes "debayer" in the role and then "new_entity", we will
> >>> need to erase the folder created by the debayer to create two new
> >>> folders, I am still not sure if I can do that.
> >> 
> >> I would expect that it's possible, but I'm not sure about it.
> >> 
> >> BTW, an alternative might be to use the build_topology file build up
> >> the topology entirely by sending commands to it:
> >> 
> >> echo "add entity debayer debayer_a" >build_topology
> >> 
> >> You can prepare a file with commands and just do:
> >> 
> >> cat my-config >build_topology.
> >> 
> >> which would be a nice feature.
> 
> yes, it would be a nice feature indeed, but the configfs doc says:
> 
> "Like sysfs, attributes should be ASCII text files, preferably
> with only one value per file.  The same efficiency caveats from sysfs
> apply. Don't mix more than one attribute in one attribute file"
> 
> That is why I thought in using the mkdir/rmdir/echo fs tree
> configuration in the first place.

It would be possible to create a single file "somewhere" that would accept 
text-based commands, but I'm not sure if that would be the best solution. 
configfs exists already and is used for this kind of purpose. I'm certainly 
open to alternative proposals, but there would need to be a good reason to 
create a custom API when a standard one already exists. Hans, what's your 
opinion on that ?

> >> I'm not saying you should do this, but it is something to think about.
> >> 
> >>>>> * Creating a link between pads in two steps:
> >>>>> Step 1)
> >>>>> Create a folder inside the source pad folder, the attribute called
> >>>>> 
> >>>>> "flag" will be automatically created in the process, for example:
> >>>>>         > mkdir /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
> >>>>>         > ls /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
> >>>>>         flags
> >>>>>         > echo -n "enabled,immutable" >
> >>>>> 
> >>>>> /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/flags
> >>>>> In the flags attribute we can have all the links attributes (enabled,
> >>>>> immutable and dynamic) separated by comma
> >>>>> 
> >>>>> Step 2)
> >>>>> Add a symlink between the previous folder we just created in the
> >>>>> source pad and the sink pad folder we want to connect. Lets say we
> >>>>> want to connect with the pad on the raw_capture_0 entity pad 0
> >>>>> 
> >>>>>         > ln -s /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
> >>>>>         /configfs/vimc/raw_capture_0/pad_0/
> >>>> 
> >>>> Can't this be created automatically? Or possibly not at all, since it
> >>>> is implicit in step 1.
> >>> 
> >>> Do you mean, create the symlink automatically? I don't think so
> >>> because the driver doesn't know a priori the entities you want to
> >>> connect together.
> >> 
> >> I don't follow. If I make a 'link_to_raw_capture_0' directory for pad_0
> >> of sensor_a, then I know there is a backlink from pad_0 of the
> >> raw_capture entity, right? At least, that's how I interpret this.
> 
> I am not sure if I got what you say.
> The user could use the
> /configfs/vimc/vimc0/sensor_a/pad_0/link_to_raw_capture_0 directory to
> link with a debayer instead of the raw_capture node. To connect with
> the debayer, the user could:
> 
> $ mkdir -p /configfs/vimc/vimc0/sensor_a/pad_0/any_name_here
> $ ln -s /configfs/vimc/vimc0/sensor_a/pad_0/any_name_here
> /configfs/vimc/vimc0/debayer_b/pad_0/
> 
> But, instead of linking with the debayer, the user could link with the
> capture:
> 
> $ ln -s /configfs/vimc/vimc0/sensor_a/pad_0/any_name_here
> /configfs/vimc/vimc0/raw_capture_1/pad_0/
> 
> Or the user could link with the scaler:
> 
> $ ln -s /configfs/vimc/vimc0/sensor_a/pad_0/any_name_here
> /configfs/vimc/vimc0/scaler/pad_0/
> 
> Thus the driver can't know in advance to which sink pad this link
> should be connected to when creating a link folder inside the pad
> folder

-- 
Regards,

Laurent Pinchart


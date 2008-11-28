Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASBS66m011747
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 06:28:06 -0500
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASBRq5s011147
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 06:27:52 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Fri, 28 Nov 2008 16:57:41 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E904EC53@dbde02.ent.ti.com>
In-Reply-To: <200811280849.14829.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: v4l <video4linux-list@redhat.com>
Subject: RE: v4l2_device/v4l2_subdev: please review
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Friday, November 28, 2008 1:19 PM
> To: Hiremath, Vaibhav
> Cc: v4l
> Subject: Re: v4l2_device/v4l2_subdev: please review
> 
> On Friday 28 November 2008 07:34:55 Hiremath, Vaibhav wrote:
> > Hi Hans,
> >
> > > -----Original Message-----
> > > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > > Sent: Wednesday, November 26, 2008 11:29 PM
> > > To: Hiremath, Vaibhav
> > > Cc: v4l
> > > Subject: Re: v4l2_device/v4l2_subdev: please review
> > >
> > > On Wednesday 26 November 2008 18:47:08 Hiremath, Vaibhav wrote:
> > > > Thanks,
> > > > Vaibhav Hiremath
> > > >
> > > > > -----Original Message-----
> > > > > From: video4linux-list-bounces@redhat.com
> [mailto:video4linux-
> > >
> > > list-
> > >
> > > > > bounces@redhat.com] On Behalf Of Hans Verkuil
> > > > > Sent: Tuesday, November 25, 2008 3:40 AM
> > > > > To: v4l
> > > > > Subject: v4l2_device/v4l2_subdev: please review
> > > > >
> > > > > Hi all,
> > > > >
> > > > > I've finally tracked down the last oops so I could make a
> new
> > >
> > > tree
> > >
> > > > > with
> > > > > all the latest changes.
> > > > >
> > > > > My http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng tree
> contains
> > >
> > > the
> > >
> > > > > following:
> > > >
> > > > [Hiremath, Vaibhav] Some quick comments I came across -
> > > >
> > > > 	- No support for enumerating/getting the input/output
> list. We
> > >
> > > do
> > >
> > > > have entry for s_routing, but how master driver will be able
> to
> > >
> > > know
> > >
> > > > about the input and output supported for sub-devices? I
> believe
> > >
> > > the
> > >
> > > > input and output supported should come from board specific
> file
> > >
> > > (from
> > >
> > > > bridge).
> > > >
> > > > Although I am not aware of sa7115 driver, but after looking to
> > >
> > > code
> > >
> > > > it looks like master driver knows about the indexes (input and
> > > > output) part. That should not be the case.
> > >
> > > The s_input and s_output ioctls deal with user level inputs and
> > > outputs
> > > (i.e. the actual connectors like HDMI, S-Video, etc.). The i2c
> > > video chip deals with input and output pins. How the two match
> up
> > > can *only*
> > > be decided by the master driver. Typically it will determine
> which
> > > board/card it is and do a lookup in some table to find the right
> > > mapping. The i2c driver definitely doesn't know. All it needs to
> > > know
> > > are the pins it has to select.
> > >
> > > > 	- Again, in my opinion it would carry more information
> if we
> > >
> > > use
> > >
> > > > v4l2_input struct for input and output.
> > > >
> > > > What is your opinion here?
> > > >
> > > > Still looking into it, may get some more points while
> migrating
> > > > to it.
> > >
> > > It's really important not to confuse the user-level inputs and
> the
> > > chip-level inputs.
> >
> > [Hiremath, Vaibhav] Hans, I read the spec for saa7115 video
> decoder
> > and I believe from input point of view the requirement/handling is
> > almost same for both TVP and SAA devices. Let me put that in
> details
> > for better understanding -
> 
> That's correct, it's a very similar device.
> 
> > SAAx (e.g. SAA7115)
> >
> > Input supported -
> > 	- 6 CVBS inputs
> > 	- 2 Y-C and 2 CVBS
> > 	- 1 Y-C and 4 CVBS
> >
> > Output Supported -
> > 	- 2 output (I-Port and X-Port out)
> >
> > TVPx (e.g. TVP5146)
> >
> > Input supported (as of now I will consider only S-Video/Composite)
> -
> > 	- 10 Composite
> > 	- 4 S-Video
> > 	- And combinations of these
> >
> > Output Supported -
> > 	- 1 output
> >
> > I believe chip-level input and user level input should be tied to
> > each other up-to some extent, meaning that -
> >
> > If say, TVP has 10 composite input connected then user should be
> able
> > to select any of them. But the user won't be knowing the chip
> level
> > details. From user point of view it is only 10-composite inputs,
> he
> > should be able to enumerate them, get the current active input and
> > set/switch the input to any of them.
> >
> > Same applies to output.
> 
> No, think about it: say that this chip is used on a board where 2 of
> the
> 10 composite input pins are hooked up to an actual composite
> connector.
> The user only cares about selecting the connector input. You don't
> want
> him to hunt through all 10 possible pins to find the two that are
> hooked up to the actual connectors. It becomes even worse when you
> consider the audio inputs: the user would have to go through the
> same
> process to match an audio input pin with an audio input connector,
> and
> than has to figure out which audio connector matches which video
> connector.
> 
[Hiremath, Vaibhav] I am not saying to export pin level details to user application, what user application will be knowing is how many inputs (at user level) are supported on that particular board/setup through ENUM_INPUT. Let me explain with live example -

(Considering the TVP514x as a example)
Board specific file information -

int no_inputs = This is highly dependent on board.
tvp514x_input_info input = details about input connector (so called user level input) and pin level input. This is an array referred with index.
int default_input = Default active input. (May not require)

With this information provided to the slave driver during probe, slave driver will handle pin level configuration on his own. Even master driver don't have to worry about this. 
User application will enumerate the inputs which are limited to "no_inputs". User won't have to hunt all the possible combinations; he will be knowing the index and type of input. So he just has to pass "index" through S_IOCTL.

> The mapping between an actual connector and the pin on a chip is
> hardwired and so is part of the bridge (host, master, whatever)
> driver
> since that driver actually knows which board it is and how it is
> hooked
> up. There is also no need to enumerate inputs from an i2c device:
> the
> bridge driver always knows what input pin to use for which physical
> input connector.
> 
> >
> > From my opinion I think, S_ROUNDING ioctl is bit confusing to me.
> I
> > would prefer generic and different interface to both input and
> output
> > - ENUM_INPUT - Enumerate all the inputs supported.
> > GET/QUERY_INPUT - Get the current active input.
> > SET_INPUT - Set/Switch the input to.
> >
> > ENUM_OUTPUT - Enumerate all the outputs supported.
> > GET/QUERY_INPUT - Get the current active output.
> > SET_OUTPUT - Set/Switch output to. This would be a requirement
> from
> > display point of view where we have multiple outputs and would
> like
> > to switch between them.
> >
> > With this, the current master drivers would need to call two slave
> > API's to route particular input to specific output (which is being
> > handled through S_ROUTING ioctl)
> 
> - Why introduce an enum ioctl?
> - Why introduce a 'get' ioctl?
> - Why make two ioctls (one for input, one for output) when the two
> have
> to be set simultaneously anyway?
> 
[Hiremath, Vaibhav] output ioctls would be required for dipsplay devices where you have multi-outputs.

> (Note that there is a G_ROUTING ioctl at the moment, but it is
> actually
> never used).
> 
[Hiremath, Vaibhav] My point is, instead of adding more confusion with S/G_ROUTING, I would prefer to have let input be handled separately and output be handled separately. The reason is, for display devices "output" is more important and for capture devices "input".

> The generic sequence is as follows:
> 
> An application calls ENUMINPUT/ENUMOUTPUT to discover which physical
> inputs and outputs there are and presents them to the user in a GUI.
> 
[Hiremath, Vaibhav] 
> When the user selects one the applications calls e.g. S_INPUT to
> select
> that input and the bridge driver looks up in a table which route
> through the video decoder chip the signal from the connector to the
> rest of the system takes. It sends that information to the i2c
> driver
> using the S_ROUTING ioctl and we are done.
> 
[Hiremath, Vaibhav] Here as per my understanding bridge driver is nothing but board specific info (or interface), where it will pass platform/board dependent data during init. Master and slave interface should be "request-get-set". With this master driver will be independent of slave.

> A good example of seeing this mapping in practice is
> drivers/media/video/ivtv/ivtv-cards.c. It supports three different
> video decoders and many boards and connector - pin mappings.
> 
[Hiremath, Vaibhav] Again I will look into this driver too.

> Regards,
> 
> 	Hans
> 
> >
> > Thanks,
> > Vaibhav Hiremath
> >
> > > Regards,
> > >
> > > 	Hans
> 
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

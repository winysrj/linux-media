Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:49477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab1GLNuJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 09:50:09 -0400
Message-ID: <4E1C515C.8070300@redhat.com>
Date: Tue, 12 Jul 2011 15:51:24 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 3.1] New SE401 driver + major pwc driver cleanup
References: <4E10CA67.1030906@redhat.com> <201107041115.13461.hansverk@cisco.com>
In-Reply-To: <201107041115.13461.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi,

On 07/04/2011 11:15 AM, Hans Verkuil wrote:
> Hi Hans,
>
> I have some notes:
>
> On Sunday, July 03, 2011 22:00:39 Hans de Goede wrote:

<snip>

>> Hans de Goede (22):
>>         videodev2.h Add SE401 compressed RGB format
>>         gspca: reset image_len to 0 on LAST_PACKET when discarding frame
>>         gspca: Add new se401 camera driver
>>         gspca_sunplus: Fix streaming on logitech quicksmart 420
>>         gspca: s/strncpy/strlcpy/
>>         pwc: better usb disconnect handling
>>         pwc: Remove a bunch of bogus sanity checks / don't return EFAULT
> wrongly
>>         pwc: remove __cplusplus guards from private header
>>         pwc: Replace private buffer management code with videobuf2
>>         pwc: Fix non CodingStyle compliant 3 space indent in pwc.h
>>         pwc: Get rid of error_status and unplugged variables
>>         pwc: Remove some unused PWC_INT_PIPE left overs
>>         pwc: Make power-saving a per device option
>>         pwc: Move various initialization to driver load and / or stream start
>>         pwc: Allow multiple opens
>
> Snippet from this patch:
>
> @@ -727,6 +740,9 @@ static int pwc_streamon(struct file *file, void *fh, enum
> v4l2_buf_type i)
>          if (!pdev->udev)
>                  return -ENODEV;
>
> +       if (pdev->capt_file != file)
> +               return -EBUSY;
> +
>          return vb2_streamon(&pdev->vb_queue, i);
>   }
>
> This really needs to be codified in vb2. I'll see if I can do some work on
> this. Drivers need to keep track of this themselves at the moment, which
> varying degrees of success :-)

I agree that having this in vb2 would be good!

>>         pwc: properly allocate dma-able memory for ISO buffers
>>         pwc: Replace control code with v4l2-ctrls framework
>
> The private controls should get their own range in videodev2.h. Something
> like:
>
> /* Reserve range USER | 0x1000 to USER | 0x1020 for the pwc drivers */
> #define V4L2_CID_USER_PWC_BASE  (V4L2_CTRL_CLASS_USER | 0x1000)
>
> The control IDs themselves should be either added to videodev2.h or to a
> public pwc.h header.

Hmm, note that pwc-ioctl.h already has CID's for these, but they use the
old V4L2_CID_PRIVATE_BASE for this, which the ctrl framework does not
like, so I looked at the private controls from the vivi driver and mimicked
that. If we can somehow make the ctrl framework except these old CID-s,
then that would be great as then we can keep using the same CID-s for now.

> I also wonder if most/all of these controls are not better done as camera
> controls (CLASS_CAMERA).

I agree that it would be better to map these to standardized controls. Proposal:
contour      -> This really is just sharpness I believe, map the sharpness
autocontour  -> Add a new autosharpness CID, this will be a user class control,
                 since sharpness itself is too.
noise_reduction -> new dynamic noise reduction cid. I can see this being available
                 on non cameras too, so I suggest using a user class cid for this.

save_user, restore_user, restore_factory settings buttons, very pwc specific IMHO,
best kept as pwc private controls, preferably using the old CID-s.

> Regarding auto-whitebalance: this 'overwrites' the standard auto-whitebalance
> control: should we perhaps change the standard awb control instead to a menu?

That could work. I'm not sure how unique the pwc is here, it basically has
3 modes:
1) manual
2) auto
3) use a preset setting

Where 3 is split into 3 presets, outdoor, indoor incandescent, indoor fluorescent
Note that in the hardware this is mapped as 0-4 into a single register.

> Or should we add a separate menu control for the lighting condition?

I'm not in favor of that, that only leads to more controls without any added value,
a simple menu with:
auto
manual
outdoor preset
indoor incandescent preset
indoor fluorescent preset

Is best IMHO. I'm not sure if we should make the awb control be a menu always and
standardize on these, since so far I've only seen them on the pwc.

While on the subject of standardizing various controls, I would like to see
the light freq menu be extended with an auto option. Some ov webcams sensors
have a mode where they figure out if they need to filter out 50 or 60 hz flicker
themselves. Currently this is used in gspca, once gspca moves over to the
framework it would be nice if this option would be there so it does not
need to override the std menu control.

While on the subject of white-balance, many many webcams don't have
red + blue balance, but rather they have red + blue + green gains (as well
as a separate over all gain) I would very much like to see 3 new standard
controls for this, currently some drivers hack around this emulating
2 balances, others use private cid-s, etc ...

One issue with adding 3 new COLOR_GAIN CID-s is that V4L2_CID_AUTO_WHITE_BALANCE
is a user control, so these would have to be user controls too, even though
they are more or less camera controls ...

NB quite a few sensors have 2 green gains (one for each green pixel in a
2x2 bayer tile) but I've yet to see any sensor where setting these to 2
different values does anything useful (usually this leads to an ugly checker
board effect), so I think1 green gain cid will be fine.

> With respect to the autocluster part: that needs to be revisited. We need to
> clearly define acceptable behaviors on the part of the driver

Right, see the other thread,

> and codify that
> in the autocluster support of the framework.

Once we've defined the acceptable behavior moving parts of this to the framework
would be great.

Notice that I did the whole caching of values mostly because of
a shortcoming in the framework which can be addressed before we've defined the
acceptable behavior. Currently when a cluster gets set, you can see which values
have actually changed with the is_new flag, but when a volatile cluster gets
read you cannot see which values are actually being read by the application.

If there were a flag for that the caching could be removed.

>
> Another thing that needs to be looked at is the use of the priv field in
> VIDIOC_S_FMT:
>
>          if (f->fmt.pix.priv) {
>                  compression = (f->fmt.pix.priv&  PWC_QLT_MASK)>>
> PWC_QLT_SHIFT;
>                  snapshot = !!(f->fmt.pix.priv&  PWC_FPS_SNAPSHOT);
>                  fps = (f->fmt.pix.priv&  PWC_FPS_FRMASK)>>  PWC_FPS_SHIFT;
>                  if (fps == 0)
>                          fps = pdev->vframes;
>          }
>
> I think at least the fps part should be done through G/S_PARM. What the others
> do is not clear to me.

Yeah, notice I've added this to the deprecation schedule. The plan is
to add G/S_PARM support for FPS, and always choose the lowest compression
which will get the desired FPS. Note that the driver already does the
last bit, if it cannot do the requested fps at the user / module param
selected compression, it automatically ups the compression.

Regards,

Hans

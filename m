Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1514 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2HJGfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 02:35:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR v3.6] Add adv7604/ad9389b drivers
Date: Fri, 10 Aug 2012 08:35:32 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201207231336.15392.hverkuil@xs4all.nl> <5024347A.5000303@redhat.com>
In-Reply-To: <5024347A.5000303@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208100835.32074.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri August 10 2012 00:06:50 Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> It follows a few notes about what I've seen at the two initial patches.
> I didn't review the other ones, as they should follow whatever agreed
> at the API/spec changes.
> 
> It should be noticed that I'm not a monitor-set expert (while I have
> some past experiences playing with monitor's EDID information, due to
> some bugs I noticed in the past with some monitors I used to have).
> So, it would be nice to have someone from drivers/video to do a review
> on this series (or at least, the API/spec changes).

Once I've incorporated your comments, I'll crosspost the new version to
dri-devel as well.

> 
> Regards,
> Mauro
> 
> -
> 
> Em 23-07-2012 08:36, Hans Verkuil escreveu:
> > Hi all!
> > 
> > There haven't been any comments since either RFCv1 or RFCv2.
> > 
> > (http://www.spinics.net/lists/linux-media/msg48529.html and
> > http://www.spinics.net/lists/linux-media/msg50413.html)
> > 
> > So I'm making this pull request now.
> > 
> > The only changes since RFCv2 are some documentation fixes:
> > 
> > - Add a note that the SUBDEV_G/S_EDID ioctls are experimental
> > - Add the proper revision/experimental references.
> > - Update the spec version to 3.6.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit 931efdf58bd83af8d0578a6cc53421675daf6d41:
> > 
> >    Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-07-14 15:45:44 -0300)
> > 
> > are available in the git repository at:
> > 
> > 
> >    git://linuxtv.org/hverkuil/media_tree.git hdmi2
> > 
> > for you to fetch changes up to d3e17e09dfd48ce8a8f7c6d80ca777230b487855:
> > 
> >    ad9389b: driver for the Analog Devices AD9389B video encoder. (2012-07-23 13:34:01 +0200)
> > 
> > ----------------------------------------------------------------
> > Hans Verkuil (7):
> >        v4l2 core: add the missing pieces to support DVI/HDMI/DisplayPort.
> 
> > +struct v4l2_subdev_edid {
> > +	__u32 pad;
> > +	__u32 start_block;
> > +	__u32 blocks;
> > +	__u32 reserved[5];
> > +	__u8 __user *edid;
> > +};
> 
> Hmm.... you'll need compat32 bits for this struct. Maybe also packing it.

Packing shouldn't be necessary (although I'll double check), but you're right
about compat32.

> 
> >        V4L2 spec: document the new DV controls and ioctls.
> 
> >  Documentation/DocBook/media/v4l/controls.xml       | 149 ++++++++++++++++++++
> >  Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
> >  .../DocBook/media/v4l/vidioc-subdev-g-edid.xml     | 152 +++++++++++++++++++++
> >  3 files changed, 302 insertions(+)
> >  create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> > index 6c27f7b..9b0a161 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -4274,4 +4274,153 @@ interface and may change in the future.</para>
> >        </table>
> >  
> >      </section>
> > +
> > +    <section id="dv-controls">
> > +      <title>Digital Video Control Reference</title>
> > +
> > +      <note>
> > +	<title>Experimental</title>
> > +
> > +	<para>This is an <link
> > +	linkend="experimental">experimental</link> interface and may
> > +	change in the future.</para>
> > +      </note>
> > +
> > +      <para>
> > +	The Digital Video control class is intended to control receivers
> > +	and transmitters for VGA, DVI, HDMI and DisplayPort. These controls
> > +	are generally expected to be private to the receiver or transmitter
> > +	subdevice that implements them, so they are only exposed on the
> > +	<filename>/dev/v4l-subdev*</filename> device node.
> > +      </para>
> > +
> > +      <para>Note that these devices can have multiple input or output pads which are
> > +      hooked up to e.g. HDMI connectors. Even though the subdevice will receive or
> > +      transmit video from/to only one of those pads, the other pads can still be
> > +      active when it comes to EDID and HDCP processing, allowing the device
> > +      to do the fairly slow EDID/HDCP handling in advance. This allows for quick
> > +      switching between connectors.</para>
> > +
> > +      <para>These pads appear in several of the controls in this section as
> > +      bitmasks, one bit for each pad starting at bit 0. The maximum value of
> > +      the control is the set of valid pads.</para>
> > +
> > +      <table pgwide="1" frame="none" id="dv-control-id">
> > +      <title>Digital Video Control IDs</title>
> > +
> > +      <tgroup cols="4">
> > +	<colspec colname="c1" colwidth="1*" />
> > +	<colspec colname="c2" colwidth="6*" />
> > +	<colspec colname="c3" colwidth="2*" />
> > +	<colspec colname="c4" colwidth="6*" />
> > +	<spanspec namest="c1" nameend="c2" spanname="id" />
> > +	<spanspec namest="c2" nameend="c4" spanname="descr" />
> > +	<thead>
> > +	  <row>
> > +	    <entry spanname="id" align="left">ID</entry>
> > +	    <entry align="left">Type</entry>
> > +	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
> > +	  </row>
> > +	</thead>
> > +	<tbody valign="top">
> > +	  <row><entry></entry></row>
> > +	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_DV_CLASS</constant></entry>
> > +	    <entry>class</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">The DV class descriptor.</entry>
> 
> Please replace 'DV' by digital video.

Agreed.
 
> Btw, It may be useful to have a glossary with an acronym glossary for the ones we won't
> get rid of it (EDID, DVI, HDCP, ...), if possible pointing to an spec that defines them.

Good point.

> 
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_DV_TX_HOTPLUG</constant></entry>
> > +	    <entry>bitmask</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">Many connectors have a hotplug pin which is high
> > +	    if EDID information is available from the source. This control shows the
> > +	    state of the hotplug pin as seen by the transmitter.
> > +	    Each bit corresponds to an output pad on the transmitter.
> > +	    This read-only control is applicable to DVI-D, HDMI and DisplayPort connectors.
> 
> What's the return code if the driver supports EDID, but the device (or cable) doesn't?
> It should likely be different than when EDID is not supported at all by the driver.

If the connector does not support hotplug (e.g. VGA), then either this control does
not exist, or the bits are 0. Whether or not there is a hotplug pin depends on the
connector type. Those connectors with a hotplug pin will only work if the hotplug
pin is also passed on to the other side, so it is not possible to have, say, an
HDMI connector with a cable that does not pass on the hotplug pin. Such cables
simply do not exist.

I think this answers your question.

BTW: DVI-A and VGA do not have a hotplug pin, but they can have an EDID, just to
keep us driver developers on our toes :-)

> > +	    </entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_DV_TX_RXSENSE</constant></entry>
> > +	    <entry>bitmask</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">Rx Sense is the detection of pull-ups on the TMDS
> > +            clock lines. This normally means that the sink has left/entered standby (i.e.
> > +	    the transmitter can sense that the receiver is ready to receive video).
> > +	    Each bit corresponds to an output pad on the transmitter.
> > +	    This read-only control is applicable to DVI-D and HDMI devices.
> 
> same as above: return codes?

What do you mean with 'return codes'? It's a control, it's either there or not. It doesn't
return any errors.

> 
> > +	    </entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_DV_TX_EDID_PRESENT</constant></entry>
> > +	    <entry>bitmask</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">When the transmitter sees the hotplug signal from the
> > +	    receiver it will attempt to read the EDID. If set, then the transmitter has read
> > +	    at least the first block (= 128 bytes).
> > +	    Each bit corresponds to an output pad on the transmitter.
> > +	    This read-only control is applicable to VGA, DVI-A/D, HDMI and DisplayPort connectors.
> > +	    </entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_DV_TX_MODE</constant></entry>
> > +	    <entry id="v4l2-dv-tx-mode">enum v4l2_dv_tx_mode</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">HDMI transmitters can transmit in DVI-D mode (just video)
> > +	    or in HDMI mode (video + audio + auxiliary data). This control selects which mode
> > +	    to use: V4L2_DV_TX_MODE_DVI_D or V4L2_DV_TX_MODE_HDMI.
> > +	    This control is applicable to HDMI connectors.
> > +	    </entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_DV_TX_RGB_RANGE</constant></entry>
> > +	    <entry id="v4l2-dv-rgb-range">enum v4l2_dv_rgb_range</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">Select the quantization range for RGB output. V4L2_DV_RANGE_AUTO
> > +	    follows the RGB quantization range specified in the standard for the video interface
> > +	    (ie. CEA-861 for HDMI). V4L2_DV_RANGE_LIMITED and V4L2_DV_RANGE_FULL override the standard
> > +	    to be compatible with sinks that have not implemented the standard correctly
> > +	    (unfortunately quite common for HDMI and DVI-D).
> > +	    This control is applicable to VGA, DVI-A/D, HDMI and DisplayPort connectors.
> 
> Hmm... V4L2_DV_RANGE_LIMITED doesn't sound nice, as it doesn't specify what limits.

I'll expand on this a bit (add some reference to a standard and make the range values explicit),
but since the standards all call it 'limited range', I think RANGE_LIMITED is a pretty decent name :-)

> 
> > +	    </entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_DV_RX_POWER_PRESENT</constant></entry>
> > +	    <entry>bitmask</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">Detects whether the receiver receives power from the source
> > +	    (e.g. HDMI carries 5V on one of the pins). This is often used to power an eeprom
> > +	    which contains EDID information, such that the source can read the EDID even if
> > +	    the sink is in standby/power off.
> > +	    Each bit corresponds to an input pad on the receiver.
> > +	    This read-only control is applicable to DVI-D, HDMI and DisplayPort connectors.
> 
> It seems better to say that bit 0 corresponds to pad 0, bit 1 to pad 1 and so on, as one might
> understand it the opposite (same note is also true to the other bitmask fields on this proposal).

There is a paragraph at the top of this DV class section that states that, but it
is perhaps not quite as clear as it can be, so I'll rephrase that.

> 
> > +	    </entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_DV_RX_RGB_RANGE</constant></entry>
> > +	    <entry>enum v4l2_dv_rgb_range</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">Select the quantization range for RGB input. V4L2_DV_RANGE_AUTO
> > +	    follows the RGB quantization range specified in the standard for the video interface
> > +	    (ie. CEA-861 for HDMI). V4L2_DV_RANGE_LIMITED and V4L2_DV_RANGE_FULL override the standard
> > +	    to be compatible with sources that have not implemented the standard correctly
> > +	    (unfortunately quite common for HDMI and DVI-D).
> > +	    This control is applicable to VGA, DVI-A/D, HDMI and DisplayPort connectors.
> 
> Same note as the TX: what precisely "range limited" means?
> 
> > +	    </entry>
> > +	  </row>
> > +	  <row><entry></entry></row>
> > +	</tbody>
> > +      </tgroup>
> > +      </table>
> > +
> > +    </section>
> >  </section>
> > diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> > index eee6908..b251c4b 100644
> > --- a/Documentation/DocBook/media/v4l/v4l2.xml
> > +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> > @@ -581,6 +581,7 @@ and discussions on the V4L mailing list.</revremark>
> >      &sub-subdev-enum-frame-size;
> >      &sub-subdev-enum-mbus-code;
> >      &sub-subdev-g-crop;
> > +    &sub-subdev-g-edid;
> >      &sub-subdev-g-fmt;
> >      &sub-subdev-g-frame-interval;
> >      &sub-subdev-g-selection;
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
> > new file mode 100644
> > index 0000000..05371db
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
> > @@ -0,0 +1,152 @@
> > +<refentry id="vidioc-subdev-g-edid">
> > +  <refmeta>
> > +    <refentrytitle>ioctl VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</refentrytitle>
> > +    &manvol;
> > +  </refmeta>
> > +
> > +  <refnamediv>
> > +    <refname>VIDIOC_SUBDEV_G_EDID</refname>
> > +    <refname>VIDIOC_SUBDEV_S_EDID</refname>
> > +    <refpurpose>Get or set the EDID of a video receiver/transmitter</refpurpose>
> > +  </refnamediv>
> > +
> > +  <refsynopsisdiv>
> > +    <funcsynopsis>
> > +      <funcprototype>
> > +	<funcdef>int <function>ioctl</function></funcdef>
> > +	<paramdef>int <parameter>fd</parameter></paramdef>
> > +	<paramdef>int <parameter>request</parameter></paramdef>
> > +	<paramdef>struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
> > +      </funcprototype>
> > +    </funcsynopsis>
> > +    <funcsynopsis>
> > +      <funcprototype>
> > +	<funcdef>int <function>ioctl</function></funcdef>
> > +	<paramdef>int <parameter>fd</parameter></paramdef>
> > +	<paramdef>int <parameter>request</parameter></paramdef>
> > +	<paramdef>const struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
> > +      </funcprototype>
> > +    </funcsynopsis>
> > +  </refsynopsisdiv>
> > +
> > +  <refsect1>
> > +    <title>Arguments</title>
> > +
> > +    <variablelist>
> > +      <varlistentry>
> > +	<term><parameter>fd</parameter></term>
> > +	<listitem>
> > +	  <para>&fd;</para>
> > +	</listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +	<term><parameter>request</parameter></term>
> > +	<listitem>
> > +	  <para>VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</para>
> > +	</listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +	<term><parameter>argp</parameter></term>
> > +	<listitem>
> > +	  <para></para>
> > +	</listitem>
> > +      </varlistentry>
> > +    </variablelist>
> > +  </refsect1>
> > +
> > +  <refsect1>
> > +    <title>Description</title>
> > +    <para>These ioctls can be used to get or set an EDID associated with an input pad
> > +    from a receiver or an output pad of a transmitter subdevice.</para>
> > +
> > +    <para>To get the EDID data the application has to fill in the <structfield>pad</structfield>,
> > +    <structfield>start_block</structfield>, <structfield>blocks</structfield> and <structfield>edid</structfield>
> > +    fields and call <constant>VIDIOC_SUBDEV_G_EDID</constant>. The current EDID from block
> > +    <structfield>start_block</structfield> and of size <structfield>blocks</structfield>
> > +    will be placed in the memory <structfield>edid</structfield> points to. The <structfield>edid</structfield>
> > +    pointer must point to memory at least <structfield>blocks</structfield>&nbsp;*&nbsp;128 bytes
> > +    large (the size of one block is 128 bytes).</para>
> > +
> > +    <para>If there are fewer blocks than specified, then the driver will set <structfield>blocks</structfield>
> > +    to the actual number of blocks. If there are no EDID blocks available at all, then the error code
> > +    ENODATA is set.</para>
> > +
> > +    <para>If blocks have to be retrieved from the sink, then this call will block until they
> > +    have been read.</para>
> > +
> > +    <para>To set the EDID blocks of a receiver the application has to fill in the <structfield>pad</structfield>,
> > +    <structfield>blocks</structfield> and <structfield>edid</structfield> fields and set
> > +    <structfield>start_block</structfield> to 0. It is not possible to set part of an EDID,
> > +    it is always all or nothing. Setting the EDID data is only valid for receivers as it makes
> > +    no sense for a transmitter.</para>
> > +
> > +    <para>The driver assumes that the full EDID is passed in. If there are more EDID blocks than
> > +    the hardware can handle then the EDID is not written, but instead the error code E2BIG is set
> > +    and <structfield>blocks</structfield> is set to the maximum that the hardware supports.
> > +    If <structfield>start_block</structfield> is any
> > +    value other than 0 then the error code EINVAL is set.</para>
> > +
> > +    <para>To disable an EDID you set <structfield>blocks</structfield> to 0. Depending on the
> > +    hardware this will drive the hotplug pin low and/or block the source from reading the EDID
> > +    data in some way. In any case, the end result is the same: the EDID is no longer available.
> > +    </para>
> > +
> > +    <table pgwide="1" frame="none" id="v4l2-subdev-edid">
> > +      <title>struct <structname>v4l2_subdev_edid</structname></title>
> > +      <tgroup cols="3">
> > +        &cs-str;
> > +	<tbody valign="top">
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>pad</structfield></entry>
> > +	    <entry>Pad for which to get/set the EDID blocks.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>start_block</structfield></entry>
> > +	    <entry>Read the EDID from starting with this block. Must be 0 when setting
> > +	    the EDID.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>blocks</structfield></entry>
> > +	    <entry>The number of blocks to get or set. Must be less or equal to 255 (the
> > +	    maximum block number defined by the standard). When you set the EDID and
> > +	    <structfield>blocks</structfield> is 0, then the EDID is disabled or erased.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u8&nbsp;*</entry>
> > +	    <entry><structfield>edid</structfield></entry>
> > +	    <entry>Pointer to memory that contains the EDID. The minimum size is
> > +	    <structfield>blocks</structfield>&nbsp;*&nbsp;128.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>reserved</structfield>[5]</entry>
> > +	    <entry>Reserved for future extensions. Applications and drivers must
> > +	    set the array to zero.</entry>
> > +	  </row>
> > +	</tbody>
> > +      </tgroup>
> > +    </table>
> > +  </refsect1>
> > +
> > +  <refsect1>
> > +    &return-value;
> > +
> > +    <variablelist>
> > +      <varlistentry>
> > +	<term><errorcode>ENODATA</errorcode></term>
> > +	<listitem>
> > +	  <para>The EDID data is not available.</para>
> > +	</listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +	<term><errorcode>E2BIG</errorcode></term>
> > +	<listitem>
> > +	  <para>The EDID data you provided is more than the hardware can handle.</para>
> > +	</listitem>
> > +      </varlistentry>
> > +    </variablelist>
> > +  </refsect1>
> > +</refentry>
> 
> 
> >        v4l2-subdev: add support for the new edid ioctls.
> >        v4l2-ctrls.c: add support for the new DV controls.
> >        v4l2-common: add CVT and GTF detection functions.
> >        adv7604: driver for the Analog Devices ADV7604 video decoder.
> >        ad9389b: driver for the Analog Devices AD9389B video encoder.
> > 
> >   Documentation/DocBook/media/v4l/compat.xml               |   21 +
> >   Documentation/DocBook/media/v4l/controls.xml             |  149 ++++
> >   Documentation/DocBook/media/v4l/v4l2.xml                 |   14 +-
> >   Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml |  161 +++++
> >   drivers/media/video/Kconfig                              |   23 +
> >   drivers/media/video/Makefile                             |    2 +
> >   drivers/media/video/ad9389b.c                            | 1328 ++++++++++++++++++++++++++++++++++
> >   drivers/media/video/adv7604.c                            | 1959 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >   drivers/media/video/v4l2-common.c                        |  358 +++++++++
> >   drivers/media/video/v4l2-ctrls.c                         |   39 +
> >   drivers/media/video/v4l2-ioctl.c                         |   13 +
> >   drivers/media/video/v4l2-subdev.c                        |    6 +
> >   include/linux/v4l2-subdev.h                              |   10 +
> >   include/linux/videodev2.h                                |   23 +
> >   include/media/ad9389b.h                                  |   49 ++
> >   include/media/adv7604.h                                  |  153 ++++
> >   include/media/v4l2-chip-ident.h                          |    6 +
> >   include/media/v4l2-common.h                              |   13 +
> >   include/media/v4l2-subdev.h                              |    2 +
> >   19 files changed, 4327 insertions(+), 2 deletions(-)
> >   create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
> >   create mode 100644 drivers/media/video/ad9389b.c
> >   create mode 100644 drivers/media/video/adv7604.c
> >   create mode 100644 include/media/ad9389b.h
> >   create mode 100644 include/media/adv7604.h

Regards,

	Hans

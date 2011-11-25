Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab1KYKvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 05:51:24 -0500
Message-ID: <4ECF7328.3040706@redhat.com>
Date: Fri, 25 Nov 2011 08:51:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] V4L2: Add per-device-node capabilities
References: <1321956322-25084-1-git-send-email-hverkuil@xs4all.nl> <dc234659a7b513338583cb48ba9234460e52e9be.1321956058.git.hans.verkuil@cisco.com>
In-Reply-To: <dc234659a7b513338583cb48ba9234460e52e9be.1321956058.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I have a few notes about the wording. See bellow.

Em 22-11-2011 08:05, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If V4L2_CAP_DEVICE_CAPS is set, then the new device_caps field is filled with
> the capabilities of the opened device node.
> 
> The capabilities field traditionally contains the capabilities of the whole
> device. 

Confusing. /dev/video is a "whole device", from kernel POV. 
It should be, instead, "physical device".

Maybe it could be written as:

	"The capabilities field traditionally contains the capabilities of the physical
	 device, being a superset of all capabilities available at the several device nodes."

> E.g., if you open video0, then if it contains VBI caps then that means
> that there is a corresponding vbi node as well. And the capabilities field of
> both the video and vbi node should contain identical caps.
> 
> However, it would be very useful to also have a capabilities field that contains
> just the caps for the currently open device, hence the new CAP bit and field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/compat.xml         |    9 ++++++
>  Documentation/DocBook/media/v4l/v4l2.xml           |    9 +++++-
>  .../DocBook/media/v4l/vidioc-querycap.xml          |   29 +++++++++++++++++--
>  drivers/media/video/cx231xx/cx231xx-417.c          |    1 -
>  drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 -
>  drivers/media/video/v4l2-ioctl.c                   |    6 +++-
>  include/linux/videodev2.h                          |   29 +++++++++++++------
>  7 files changed, 67 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index b68698f..88ea4fc 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2378,6 +2378,15 @@ that used it. It was originally scheduled for removal in 2.6.35.
>          </listitem>
>        </orderedlist>
>      </section>
> +    <section>
> +      <title>V4L2 in Linux 3.3</title>
> +      <orderedlist>
> +        <listitem>
> +	  <para>Added the device_caps field to struct v4l2_capabilities and added the new
> +	  V4L2_CAP_DEVICE_CAPS capability.</para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
>  
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 2ab365c..6b6e584 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -128,6 +128,13 @@ structs, ioctls) must be noted in more detail in the history chapter
>  applications. -->
>  
>        <revision>
> +	<revnumber>3.3</revnumber>
> +	<date>2011-11-22</date>
> +	<authorinitials>hv</authorinitials>
> +	<revremark>Added device_caps field to struct v4l2_capabilities.</revremark>
> +      </revision>
> +
> +      <revision>
>  	<revnumber>3.2</revnumber>
>  	<date>2011-08-26</date>
>  	<authorinitials>hv</authorinitials>
> @@ -417,7 +424,7 @@ and discussions on the V4L mailing list.</revremark>
>  </partinfo>
>  
>  <title>Video for Linux Two API Specification</title>
> - <subtitle>Revision 3.2</subtitle>
> + <subtitle>Revision 3.3</subtitle>
>  
>    <chapter id="common">
>      &sub-common;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> index e3664d6..632ad13 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> @@ -124,12 +124,29 @@ printf ("Version: %u.%u.%u\n",
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>capabilities</structfield></entry>
> -	    <entry>Device capabilities, see <xref
> -		linkend="device-capabilities" />.</entry>
> +	    <entry>Device capabilities of the physical device as a whole, see <xref
> +		linkend="device-capabilities" />. The same physical device can export
> +		multiple devices in /dev (e.g. /dev/videoX, /dev/vbiY and /dev/radioZ).
> +		For all those devices the capabilities field returns the same set of
> +		capabilities. This allows applications to open just the video device
> +		and discover whether vbi or radio is also supported.

I would write it as:

	    <entry>Available capabilities of the physical device as a whole, see <xref
		linkend="device-capabilities" />. The same physical device can export
		multiple devices in /dev (e.g. /dev/videoX, /dev/vbiY and /dev/radioZ).
		The capabilities field should contain an union of all capabilities available
		around the several V4L2 devices exported to userspace.
		For all those devices the capabilities field returns the same set of
		capabilities. This allows applications to open just one of the devices
		(typically the video device) and discover whether video, vbi and/or radio are
		also supported.


> +	    </entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved</structfield>[4]</entry>
> +	    <entry><structfield>device_caps</structfield></entry>
> +	    <entry>Device capabilities of the open device, see <xref
> +		linkend="device-capabilities" />. This is the set of capabilities
> +		of just the open device. So <structfield>device_caps</structfield>
> +		of a radio device will only contain radio related capabilities and
> +		no video capabilities. This field is only set if the <structfield>capabilities</structfield>
> +		field contains the <constant>V4L2_CAP_DEVICE_CAPS</constant>
> +		capability.

I would write it as:

	    <entry>Device capabilities of the opened device, see <xref
		linkend="device-capabilities" />. Should contain the available
		capabilities via that specific device node. So, for example,
		<structfield>device_caps</structfield> of a radio device will only 
		contain radio related capabilities and 	no video or vbi capabilities. 
	        This field is only set if the <structfield>capabilities</structfield>
		field contains the <constant>V4L2_CAP_DEVICE_CAPS</constant>
		capability.

> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[3]</entry>
>  	    <entry>Reserved for future extensions. Drivers must set
>  this array to zero.</entry>
>  	  </row>
> @@ -276,6 +293,12 @@ linkend="async">asynchronous</link> I/O methods.</entry>
>  	    <entry>The device supports the <link
>  linkend="mmap">streaming</link> I/O method.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_CAP_DEVICE_CAPS</constant></entry>
> +	    <entry>0x80000000</entry>
> +	    <entry>The driver fills the <structfield>device_caps</structfield>
> +	    field.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
> index f8f0e59..d4327da 100644
> --- a/drivers/media/video/cx231xx/cx231xx-417.c
> +++ b/drivers/media/video/cx231xx/cx231xx-417.c
> @@ -1686,7 +1686,6 @@ static struct v4l2_capability pvr_capability = {
>  	.capabilities   = (V4L2_CAP_VIDEO_CAPTURE |
>  			   V4L2_CAP_TUNER | V4L2_CAP_AUDIO | V4L2_CAP_RADIO |
>  			 V4L2_CAP_STREAMING | V4L2_CAP_READWRITE),
> -	.reserved       = {0, 0, 0, 0}
>  };
>  static int vidioc_querycap(struct file *file, void  *priv,
>  				struct v4l2_capability *cap)
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> index ce7ac45..e98b414 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> @@ -95,7 +95,6 @@ static struct v4l2_capability pvr_capability ={
>  	.capabilities   = (V4L2_CAP_VIDEO_CAPTURE |
>  			   V4L2_CAP_TUNER | V4L2_CAP_AUDIO | V4L2_CAP_RADIO |
>  			   V4L2_CAP_READWRITE),
> -	.reserved       = {0,0,0,0}
>  };
>  
>  static struct v4l2_fmtdesc pvr_fmtdesc [] = {
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index e1da8fc..ae716c2 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -538,10 +538,12 @@ static long __video_do_ioctl(struct file *file,
>  		if (!ret)
>  			dbgarg(cmd, "driver=%s, card=%s, bus=%s, "
>  					"version=0x%08x, "
> -					"capabilities=0x%08x\n",
> +					"capabilities=0x%08x, "
> +					"device_caps=0x%08x\n",
>  					cap->driver, cap->card, cap->bus_info,
>  					cap->version,
> -					cap->capabilities);
> +					cap->capabilities,
> +					cap->device_caps);
>  		break;
>  	}
>  
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4b752d5..c185707 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -235,16 +235,25 @@ struct v4l2_fract {
>  	__u32   denominator;
>  };
>  
> -/*
> - *	D R I V E R   C A P A B I L I T I E S
> - */
> +/**
> +  * struct v4l2_capability - Describes V4L2 device caps returned by VIDIOC_QUERYCAP
> +  *
> +  * @driver:	   name of the driver module (e.g. "bttv")
> +  * @card:	   name of the card (e.g. "Hauppauge WinTV")
> +  * @bus_info:	   name of the bus (e.g. "PCI:" + pci_name(pci_dev) )
> +  * @version:	   KERNEL_VERSION
> +  * @capabilities: capabilities of the physical device as a whole
> +  * @device_caps:  capabilities accessed via this particular device (node)
> +  * @reserved:	   reserved fields for future extensions
> +  */
>  struct v4l2_capability {
> -	__u8	driver[16];	/* i.e. "bttv" */
> -	__u8	card[32];	/* i.e. "Hauppauge WinTV" */
> -	__u8	bus_info[32];	/* "PCI:" + pci_name(pci_dev) */
> -	__u32   version;        /* should use KERNEL_VERSION() */
> -	__u32	capabilities;	/* Device capabilities */
> -	__u32	reserved[4];
> +	__u8	driver[16];
> +	__u8	card[32];
> +	__u8	bus_info[32];
> +	__u32   version;
> +	__u32	capabilities;
> +	__u32	device_caps;
> +	__u32	reserved[3];
>  };
>  
>  /* Values for 'capabilities' field */
> @@ -274,6 +283,8 @@ struct v4l2_capability {
>  #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>  #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
>  
> +#define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
> +
>  /*
>   *	V I D E O   I M A G E   F O R M A T
>   */


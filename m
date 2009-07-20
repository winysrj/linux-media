Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43587 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZGTRLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 13:11:55 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFC: String controls
Date: Mon, 20 Jul 2009 19:12:53 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200907201723.02534.hverkuil@xs4all.nl>
In-Reply-To: <200907201723.02534.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907201912.54287.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 20 July 2009 17:23:02 Hans Verkuil wrote:
> Hi all,
>
> For the si4713 FM transmitter driver from Eduardo we need to add support
> for string controls so that the user can set things like the RDS Program
> Name.
>
> The v4l2_ext_control struct has been designed with the possibility of
> things like this in mind, so adding this isn't very difficult. There are a
> few details that need to be sorted out first, though.
>
> The struct looks like this right now:
>
> struct v4l2_ext_control {
>         __u32 id;
>         __u32 reserved2[2];
>         union {
>                 __s32 value;
>                 __s64 value64;
>                 void *reserved;
>         };
> } __attribute__ ((packed));
>
> For string controls we need to change it to this:
>
> struct v4l2_ext_control {
>         __u32 id;
> 	__u32 length;
>         __u32 reserved2;
>         union {
>                 __s32 value;
>                 __s64 value64;
> 		char *string;
>         };
> } __attribute__ ((packed));
>
> The new length field is setup by the caller and contains the size in bytes
> of the memory that the string field points to. This length will be used as
> well by any future pointer control type, so it is not string specific. Note
> that for string controls the length has to be strlen(string) + 1 to make
> room for the terminating zero.
>
> An added bonus is that we can use the length field in v4l2-compat-ioctl32.c
> in order to do the right pointer transformation from 32 to 64 bits since
> length is only non-zero for pointer types.
>
> While it is possible to do a copy_from_user in v4l2-ioctl.c for the string
> in a string control I have decided not to do this. For any pointer control
> it is the driver that will have to do this step. The reason is that there
> is no limit on these lengths, so rather than copying it to a temporary
> piece of kernel memory and then again copying it in the driver to whatever
> the final destination is, I think it is much more efficient to just let the
> driver handle it.
>
> We also need a new string type, of course: V4L2_CTRL_TYPE_STRING.

Should we standardize on a particular encoding ?

> There is one remaining problem: how to determine how big the string memory
> has to be? When retrieving a string control the application has to know how
> much memory to allocate for the result. Or at the minimum it has to know
> when it didn't allocate enough memory.
>
> The first part of the solution is to utilize the minimum and maximum fields
> in v4l2_queryctrl: these can be set to the minimum and maximum length of
> the string control. This can be useful when creating a GUI control element
> in that the GUI knows how to present the string control and to implement
> simple input validation. The maximum value can also be used to allocate
> sufficient memory when retrieving a string control. In case there is no
> maximum (other than the amount of available memory) the maximum field can
> be left at 0. I am not sure whether the min and max fields should refer to
> the string length or the memory size. The latter is one higher due to the
> terminating zero. I think I prefer the string length as that makes more
> sense from a GUI perspective (which is really what v4l2_queryctrl is all
> about).
>
> I see no use for the default_value and step fields, so these should be left
> at 0.
>
> The second part of the solution is that when retrieving a string control
> the length field is set by the driver to the minimum required length if the
> original length was too short. In that case the g_ext_ctrls ioctl returns
> ENOSPC as error and it is up to the application to re-allocate enough
> memory and retry the ioctl. Setting length to 0 initially will always force
> an ENOSPC error and can be used to discover the length up front.
>
> I think that this is a reasonable solution.

This might not be enough to accommodate string controls are varying lengths. 
Let's say a given string controls needs 16 bytes to hold the string value. The 
userspace application queries the driver with a 0 length and receives a -
ENOSPC error with the required length. At that point the application retries 
the call with a 16 bytes buffer, but the string values changes and now 
requires 32 bytes. The application will receive -ENOSPC once again. This can 
go on for a few iterations.

I'm not sure it would be wise to allow for a 0 maximum length value in 
response to a control query. Do you have use cases in mind where the driver 
can't compute the maximum string size in advance ?

Regards,

Laurent Pinchart


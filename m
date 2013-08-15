Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60932 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754056Ab3HOIXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 04:23:38 -0400
Date: Thu, 15 Aug 2013 11:23:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 02/10] v4l2: add matrix support.
Message-ID: <20130815082332.GB19221@valkosipuli.retiisi.org.uk>
References: <1376305113-17128-1-git-send-email-hverkuil@xs4all.nl>
 <1376305113-17128-3-git-send-email-hverkuil@xs4all.nl>
 <20130814143313.GA19221@valkosipuli.retiisi.org.uk>
 <520C7695.7020405@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520C7695.7020405@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Aug 15, 2013 at 08:35:01AM +0200, Hans Verkuil wrote:
> On 08/14/2013 04:33 PM, Sakari Ailus wrote:
...
> >> + * @columns:	number of columns in the matrix
> >> + * @rows:	number of rows in the matrix
> > 
> > Two dimensions only? How about one or three? I could imagine use for one, at
> > the very least.
> 
> For one you just set rows to 1. A vector is after all a matrix of one row.
> Should we need a third dimension, then there are enough reserved fields to make
> that possible. I can't think of a single use-case that would require a three
> dimensional matrix.

Fine for me.

> >> + * @elem_min:	minimum matrix element value
> >> + * @elem_max:	maximum matrix element value
> >> + * @elem_size:	size in bytes each matrix element
> >> + * @reserved:	future extensions, applications and drivers must zero this.
> >> + */
> >> +struct v4l2_query_matrix {
> >> +	__u32 type;
> >> +	union {
> >> +		__u32 raw[4];
> >> +	} ref;
> >> +	__u32 columns;
> >> +	__u32 rows;
> >> +	union {
> >> +		__s64 val;
> >> +		__u64 uval;
> >> +		__u32 raw[4];
> >> +	} elem_min;
> >> +	union {
> >> +		__s64 val;
> >> +		__u64 uval;
> >> +		__u32 raw[4];
> >> +	} elem_max;
> > 
> > How about step; do you think it'd make sense to specify that? I have to
> > admit the step in controls hasn't been extemely useful to me: much of the
> > time the value of the control should have just been divided by the step,
> > with the exception of controls that have a standardised unit, but even then
> > step won't do good on them since there's typically no 1:1 mapping between
> > possible values and the actual values which leads the driver writer choosing
> > step of one.
> 
> You just explained why I decided against adding a step :-)
> 
> I also can't really see a use-case for a step in a matrix.

I agree --- I brought it up mostly since controls already do have step.

> >> +	__u32 elem_size;
> >> +	__u32 reserved[12];
> >> +} __attribute__ ((packed));
> >> +
> >> +/**
> >> + * struct v4l2_matrix - VIDIOC_G/S_MATRIX argument
> >> + * @type:	matrix type
> >> + * @ref:	reference to some object (if any) owning the matrix
> >> + * @rect:	which part of the matrix to get/set
> > 
> > In some cases it might be possible to choose the size of the matrix. If this
> > isn't supported now, do you have ideas how to add it? Perhaps using rect
> > woulnd't be possible. A new IOCTL could be one possibility as well; that'd
> > make it quite clear and drivers not supporting it wouldn't implement it. I
> > think it might quite well make it together with S_MATRIX, though, e.g. a
> > flags field with a flag telling that the dimension fields are valid.
> 
> Would it be an idea to add a flags field to both v4l2_matrix and v4l2_query_matrix?
> We don't have flags yet, but that makes it easy to add. For a feature such as you
> describe it would be easy enough to implement that by setting an e.g.
> V4L2_MATRIX_FL_NEW_SIZE flag. In query_matrix you would than have a
> V4L2_QMATRIX_FL_HAS_NEW_SIZE (or perhaps in query_matrix it should be called
> 'capabilities' instead).
> 
> I can also just leave it out and use one of the reserved fields when such a feature
> is needed.

I propose adding the flags fields once they're actually needed.

> >> + * @matrix:	pointer to the matrix of size (in bytes):
> >> + *		elem_size * rect.width * rect.height
> >> + * @reserved:	future extensions, applications and drivers must zero this.
> >> + */
> >> +struct v4l2_matrix {
> >> +	__u32 type;
> >> +	union {
> >> +		__u32 raw[4];
> >> +	} ref;
> >> +	struct v4l2_rect rect;
> >> +	void __user *matrix;
> >> +	__u32 reserved[12];
> >> +} __attribute__ ((packed));
> >> +
> >>  /*
> >>   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
> >>   *
> >> @@ -1946,6 +2004,12 @@ struct v4l2_create_buffers {
> >>     Never use these in applications! */
> >>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
> >>  
> >> +/* Experimental, these three ioctls may change over the next couple of kernel
> >> +   versions. */
> >> +#define VIDIOC_QUERY_MATRIX	_IOWR('V', 103, struct v4l2_query_matrix)
> >> +#define VIDIOC_G_MATRIX		_IOWR('V', 104, struct v4l2_matrix)
> >> +#define VIDIOC_S_MATRIX		_IOWR('V', 105, struct v4l2_matrix)
> >> +
> >>  /* Reminder: when adding new ioctls please add support for them to
> >>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> >>  
> > 
> 
> Thanks for the review!
> 
> I'll prepare a new version this weekend dropping the ref fields and integrating the ID
> space into that of the controls.

Thanks! :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

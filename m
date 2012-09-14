Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4499 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2INR7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 13:59:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [RFCv3 API PATCH 31/31] Add vfl_dir field documentation.
Date: Fri, 14 Sep 2012 19:59:12 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <77a2489dac81a471ef53aeffa172b11f676ae3c7.1347619766.git.hans.verkuil@cisco.com> <50536AC0.8070003@gmail.com>
In-Reply-To: <50536AC0.8070003@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209141959.12728.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 14 2012 19:34:56 Sylwester Nawrocki wrote:
> On 09/14/2012 12:57 PM, Hans Verkuil wrote:
> > Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> > ---
> >   Documentation/video4linux/v4l2-framework.txt |    9 ++++++++-
> >   1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> > index 89318be..20f1c05 100644
> > --- a/Documentation/video4linux/v4l2-framework.txt
> > +++ b/Documentation/video4linux/v4l2-framework.txt
> > @@ -583,11 +583,18 @@ You should also set these fields:
> >
> >   - name: set to something descriptive and unique.
> >
> > +- vfl_dir: set to VFL_DIR_TX for output devices and VFL_DIR_M2M for mem2mem
> > +  (codec) devices.
> > +
> 
> No need to document VFL_DIR_RX ?

Oops. Just because it is the default doesn't mean that I shouldn't document it.

I'll change this to:

- vfl_dir: set this to VFL_DIR_RX for capture devices (VFL_DIR_RX has value 0,
  so this is normally already the default), set to VFL_DIR_TX for output
  devices and VFL_DIR_M2M for mem2mem (codec) devices.

Thanks for all the reviews/acks!

Regards,

	Hans

> 
> >   - fops: set to the v4l2_file_operations struct.
> >
> >   - ioctl_ops: if you use the v4l2_ioctl_ops to simplify ioctl maintenance
> >     (highly recommended to use this and it might become compulsory in the
> > -  future!), then set this to your v4l2_ioctl_ops struct.
> > +  future!), then set this to your v4l2_ioctl_ops struct. The vfl_type and
> > +  vfl_dir fields are used to disable ops that do not match the type/dir
> > +  combination. E.g. VBI ops are disabled for non-VBI nodes, and output ops
> > +  are disabled for a capture device. This makes it possible to provide
> > +  just one v4l2_ioctl_ops struct for both vbi and video nodes.
> >
> >   - lock: leave to NULL if you want to do all the locking in the driver.
> >     Otherwise you give it a pointer to a struct mutex_lock and before the
> 
> --
> 
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

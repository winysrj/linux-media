Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33623 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab0EEXaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 19:30:06 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 5 May 2010 18:29:54 -0500
Subject: RE: [videobuf] Query: Condition bytesize limit in videobuf_reqbufs
 -> buf_setup() call?
Message-ID: <A24693684029E5489D1D202277BE894455257ED2@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com>
 <4BE1FE22.8000909@redhat.com>
In-Reply-To: <4BE1FE22.8000909@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> Sent: Wednesday, May 05, 2010 6:24 PM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org
> Subject: Re: [videobuf] Query: Condition bytesize limit in
> videobuf_reqbufs -> buf_setup() call?
> 
> Aguirre, Sergio wrote:
> > Hi all,
> >
> > While working on an old port of the omap3 camera-isp driver,
> > I have faced some problem.
> >
> > Basically, when calling VIDIOC_REQBUFS with a certain buffer
> > Count, we had a software limit for total size, calculated depending on:
> >
> >   Total bytesize = bytesperline x height x count
> >
> > So, we had an arbitrary limit to, say 32 MB, which was generic.
> >
> > Now, we want to condition it ONLY when MMAP buffers will be used.
> > Meaning, we don't want to keep that policy when the kernel is not
> > allocating the space
> >
> > But the thing is that, according to videobuf documentation, buf_setup is
> > the one who should put a RAM usage limit. BUT the memory type passed to
> > reqbufs is not propagated to buf_setup, therefore forcing me to go to a
> > non-standard memory limitation in my reqbufs callback function, instead
> > of doing it properly inside buf_setup.
> >
> > Is this scenario a good consideration to change buf_setup API, and
> > propagate buffers memory type aswell?
> 
> I don't see any problem on propagating the memory type to buffer_setup, if
> this is really needed. Yet, I can't see why you would restrict the buffer
> size to 32 MB on one case, and not restrict the size at all with non-MMAP
> types.

Ok, my reason for doing that is because I thought that there should be a memory limit in whichever place you're doing the buffer allocations.

MMAP is allocating buffers in kernel, so kernel should provide a memory restriction, if applies.

USERPTR is allocating buffers in userspace, so userspace should provide a memory restriction, if applies.

Please correct me if my reasoning is not correct.

Regards,
Sergio

> 
> > I'll appreciate your inputs on this matter.
> >
> > Regards,
> > Sergio
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> 
> Cheers,
> Mauro

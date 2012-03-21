Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59302 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab2CUNpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 09:45:17 -0400
Received: by yenl12 with SMTP id l12so907564yen.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 06:45:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120319225402.GB6284@valkosipuli.localdomain>
References: <20120311165650.GA4220@valkosipuli.localdomain>
	<4F67A970.8090606@redhat.com>
	<20120319225402.GB6284@valkosipuli.localdomain>
Date: Wed, 21 Mar 2012 19:15:16 +0530
Message-ID: <CA+V-a8vsKHRxbvgxoFqCACS16iojhxE4fcDSqC9R5yvRJ46OQg@mail.gmail.com>
Subject: Re: [GIT PULL FOR v3.4] V4L2 subdev and sensor control changes and
 SMIA++ driver
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>, teturtia@gmail.com,
	pradeep.sawlani@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,

On Tue, Mar 20, 2012 at 4:24 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Mauro,
>
> On Mon, Mar 19, 2012 at 06:47:28PM -0300, Mauro Carvalho Chehab wrote:
>> Em 11-03-2012 13:56, Sakari Ailus escreveu:
>> > Hi Mauro,
>> >
>> > This patchset adds
>> >
>> > - Integer menu controls,
>> > - Selection IOCTL for subdevs,
>> > - Sensor control improvements,
>> > - link_validate() media entity and V4L2 subdev pad ops,
>> > - OMAP 3 ISP driver improvements,
>> > - SMIA++ sensor driver and
>> > - Other V4L2 and media improvements (see individual patches)
>> >
>> > The previous patchset can be found here:
>> >
>> > <URL:http://www.spinics.net/lists/linux-media/msg45052.html>
>> >
>> > Compared to the patchset, I've dropped the rm-696 camera board code and will
>> > submit it through linux-omap later on. Other changes done to address review
>> > comments have been also done --- see the URL above for details.
>> >
>> > The following changes since commit 632fba4d012458fd5fedc678fb9b0f8bc59ceda2:
>> >
>> >   [media] cx25821: Add a card definition for "No brand" cards that have: subvendor = 0x0000 subdevice = 0x0000 (2012-03-08 12:42:28 -0300)
>> >
>> > are available in the git repository at:
>> >   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.4
>> >
>> > Jesper Juhl (1):
>> >       adp1653: Remove unneeded include of version.h
>> >
>> > Laurent Pinchart (3):
>> >       omap3isp: Prevent pipelines that contain a crashed entity from starting
>> >       omap3isp: Fix crash caused by subdevs now having a pointer to devnodes
>> >       omap3isp: Fix frame number propagation
>> >
>> > Sakari Ailus (37):
>> >       v4l: Introduce integer menu controls
>> >       v4l: Document integer menu controls
>> >       vivi: Add an integer menu test control
>> >       v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
>> >       v4l: vdev_to_v4l2_subdev() should have return type "struct v4l2_subdev *"
>> >       v4l: Check pad number in get try pointer functions
>> >       v4l: Support s_crop and g_crop through s/g_selection
>> >       v4l: Add subdev selections documentation: svg and dia files
>> >       v4l: Add subdev selections documentation
>>
>> This patch broke docbook compilation:
>>
>>   HTML    Documentation/DocBook/media_api.html
>> warning: failed to load external entity "/home/v4l/v4l/patchwork/Documentation/DocBook/vidioc-subdev-g-selection.xml"
>> /home/v4l/v4l/patchwork/Documentation/DocBook/dev-subdev.xml:310: parser error : Failure to process entity sub-subdev-g-selection
>>       size configured using &sub-subdev-g-selection; and
>>                                                     ^
>> /home/v4l/v4l/patchwork/Documentation/DocBook/dev-subdev.xml:310: parser error : Entity 'sub-subdev-g-selection' not defined
>>       size configured using &sub-subdev-g-selection; and
>>                                                     ^
>> /home/v4l/v4l/patchwork/Documentation/DocBook/dev-subdev.xml:468: parser error : chunk is not well balanced
>>
>> ^
>> /home/v4l/v4l/patchwork/Documentation/DocBook/v4l2.xml:476: parser error : Failure to process entity sub-dev-subdev
>>     <section id="subdev"> &sub-dev-subdev; </section>
>>                                           ^
>> /home/v4l/v4l/patchwork/Documentation/DocBook/v4l2.xml:476: parser error : Entity 'sub-dev-subdev' not defined
>>     <section id="subdev"> &sub-dev-subdev; </section>
>>                                           ^
>> /usr/bin/xmlto: line 568:  3232 Segmentation fault      "/usr/bin/xsltproc" --nonet --xinclude --param passivetex.extensions '1' -o "/tmp/xmlto.J0M0go/media_api.proc" "/tmp/xmlto-xsl.GKa5kH" "/home/v4l/v4l/patchwork/Documentation/DocBook/media_api.xml"
>> /bin/cp: cannot stat `*.*htm*': No such file or directory
>> make[1]: *** [Documentation/DocBook/media_api.html] Error 1
>> make: *** [htmldocs] Error 2
>>
>> Please fix.
>
> I'm pretty sure it compiles for me --- I just tested it myself on a
> different machine. Do you think you could possibly have e.g. old
> Documentation/DocBook/media-entities.tmpl in your tree? This file
> sometimes isn't getting rebuilt even when it would be needed to.
>
  Even I am facing a similar kind of issue where
 Documentation/DocBook/media-entities.tmpl is not getting rebuilt how to fix it?

Regards,
--Prabhakar Lad

> Kind regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

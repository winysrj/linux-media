Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1565 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbZFSMmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 08:42:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [PATCH 3/11 - v3] dm355 ccdc module for vpfe capture driver
Date: Fri, 19 Jun 2009 14:42:16 +0200
Cc: m-karicheri2@ti.com, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com> <1245269484-8325-4-git-send-email-m-karicheri2@ti.com> <208cbae30906171451x789f00ak94799447c9a012a5@mail.gmail.com>
In-Reply-To: <208cbae30906171451x789f00ak94799447c9a012a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906191442.17151.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 June 2009 23:51:43 Alexey Klimov wrote:
> Hello,
> one more small comment
>
> On Thu, Jun 18, 2009 at 12:11 AM, <m-karicheri2@ti.com> wrote:
> > From: Muralidharan Karicheri <m-karicheri2@ti.com>
> >
> > DM355 CCDC hw module
> >
> > Adds ccdc hw module for DM355 CCDC. This registers with the bridge
> > driver a set of hw_ops for configuring the CCDC for a specific
> > decoder device connected to vpfe.
> >
> > The module description and owner information added
>
> <snip>
>
> > +static int dm355_ccdc_init(void)
> > +{
> > +       printk(KERN_NOTICE "dm355_ccdc_init\n");
> > +       if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
> > +               return -1;
>
> Don't you want to rewrite this to return good error code?
> int ret;
> printk();
> ret = vpfe_register_ccdc_device();
> if (ret < 0)
> return ret;
>
> I know you have tight/fast track/hard schedule, so you can do this
> improvement later, after merging this patch.

I haven't changed this or the similar comment in patch 4/11, but it is 
something that Muralidharan should look at and fix later.

Regards,

	Hans

>
> > +       printk(KERN_NOTICE "%s is registered with vpfe.\n",
> > +               ccdc_hw_dev.name);
> > +       return 0;
> > +}
> > +
> > +static void dm355_ccdc_exit(void)
> > +{
> > +       vpfe_unregister_ccdc_device(&ccdc_hw_dev);
> > +}



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

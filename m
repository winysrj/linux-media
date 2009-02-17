Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4349 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZBQXGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 18:06:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: Minimum kernel version supported by v4l-dvb
Date: Wed, 18 Feb 2009 00:06:38 +0100
Cc: Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <20090217142327.1678c1a6@hyperion.delvare> <200902172324.03697.laurent.pinchart@skynet.be>
In-Reply-To: <200902172324.03697.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902180006.38763.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 17 February 2009 23:24:03 Laurent Pinchart wrote:
> Hi Jean,
>
> On Tuesday 17 February 2009 14:23:27 Jean Delvare wrote:
> > Hi Mauro,
> >
> > These days I am helping Hans Verkuil convert the last users of the
> > legacy i2c device driver binding model to the new, standard binding
> > model. It turns out to be a very complex task because the v4l-dvb
> > repository is supposed to still support kernels as old as 2.6.16, while
> > the initial support for the new i2c binding model was added in kernel
> > 2.6.22 (and even that is somewhat different from what is upstream now.)
> > This forces us to add quirks all around the place, which will surely
> > result in bugs because the code becomes hard to read, understand and
> > maintain.
> >
> > In fact, without this need for backwards compatibility, I would
> > probably have been able to convert most of the drivers myself, without
> > Hans' help, and this would already be all done. But as things stand
> > today, he has to do most of the work, and our progress is slow.
> >
> > So I would like you to consider changing the minimum kernel version
> > supported by the v4l-dvb repository from 2.6.16 to at least 2.6.22.
> > Ideal for us would even be 2.6.26, but I would understand that this is
> > too recent for you. Kernel 2.6.22 is one year and a half old, I
> > honestly doubt that people fighting to get their brand new TV adapter
> > to work are using anything older. As a matter of fact, kernel 2.6.22 is
> > what openSUSE 10.3 has, and this is the oldest openSUSE product that is
> > still maintained.
>
> Dropping pre-2.6.22 support may not be an issue for desktop systems that
> probably already run newer kernel versions. It might be a different story
> for embedded systems, as many users are stuck with old vendor-provided
> kernels.
>
> I have no idea how many users we're talking about, but I know that the
> UVC driver is used with a 2.6.10 kernel on an embedded system by at least
> one person.
>
> > I understand and respect your will to let a large range of users build
> > the v4l-dvb repository, but at some point the cost for developers seems
> > to be too high, so there's a balance to be found between users and
> > developers. At the moment the balance isn't right IMHO.
>
> I won't vote against setting the minimum kernel version to 2.6.22, but we
> should at least be aware that embedded users, even if they're not very
> vocal, are lurking out there in the darkness of vendor-provided kernels.

Embedded users tend to make a snapshot of a particular kernel/driver and 
they don't usually upgrade either one. I do think that we need to make a 
branch (can hg do that?) or a copy of the repository just before dropping 
support for older kernels. So people who need to compile for a pre-2.6.22 
kernel can still get older, but working sources.

But we are developing drivers for inclusion into the linux kernel, not 
providing an unpaid (!) service for the few people who cannot/will not 
upgrade to a newer kernel. Especially companies like Texas Instruments that 
are working on new v4l2 drivers for the embedded space (omap, davinci) are 
quite annoyed and confused by all the backwards compatibility stuff that 
we're dragging along. I find it much more important to cater to their needs 
than to support a driver on an ancient kernel for some anonymous company. 
If they need it, then pay someone to backport the driver.

And of course, I have to do way too much work to keep it all running on 
older kernels. It's really not what I want to spend my time on.

It's great to be able to support older kernels, but only as long as it is 
technically not too much of a burden. And that might mean that at some 
stage we have to stop supporting all or most of the older kernels if some 
core kernel change was made that would require a unreasonable amount of 
work to keep it running on older kernels.

By going to 2.6.22 we can at least go back to providing i2c drivers without 
too much compatibility obfuscation. A driver like wm8739 would look like 
this:

-----------------------------------------------
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
static int wm8739_probe(struct i2c_client *client,
                        const struct i2c_device_id *id)
#else
static int wm8739_probe(struct i2c_client *client)
#endif
{
        struct wm8739_state *state;

	...
}

static int wm8739_remove(struct i2c_client *client)
{
        struct v4l2_subdev *sd = i2c_get_clientdata(client);

        v4l2_device_unregister_subdev(sd);
        kfree(to_state(sd));
        return 0;
}

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
static const struct i2c_device_id wm8739_id[] = {
        { "wm8739", 0 },
        { }
};
MODULE_DEVICE_TABLE(i2c, wm8739_id);
#endif

static struct i2c_driver wm8739_driver = {
        .name = "wm8739",
        .command = wm8739_command,
        .probe = wm8739_probe,
        .remove = wm8739_remove,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
        .id_table = wm8739_id,
#endif
};

static int __init wm8739_init(void)
{
        return i2c_add_driver(&wm8739_driver);
}


static void __exit v4l2_i2c_drv_cleanup(void)
{
        i2c_del_driver(&wm8739ver);
}

module_init(wm8739_init);
module_exit(wm8739_cleanup);
-----------------------------------------------

So that's three #ifdef's per i2c driver. I would personally prefer to take 
2.6.26 as the cut-off point, but I suspect that's not going to happen.

I hope I'm not ranting too much, but these backwards compatibility 
constraints are really counter productive and slowing down progress. We're 
mostly unpaid volunteers and we should not have to spend time on this.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

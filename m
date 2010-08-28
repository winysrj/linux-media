Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4226 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0H1JoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Aug 2010 05:44:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: matti.j.aaltonen@nokia.com
Subject: Re: [PATCH v7 4/5] V4L2: WL1273 FM Radio: Controls for the FM radio.
Date: Sat, 28 Aug 2010 11:43:52 +0200
Cc: ext pramodh ag <pramodhag@yahoo.co.in>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com> <555961.26177.qm@web95110.mail.in2.yahoo.com> <1282546417.14489.191.camel@masi.mnp.nokia.com>
In-Reply-To: <1282546417.14489.191.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008281143.52387.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Monday, August 23, 2010 08:53:37 Matti J. Aaltonen wrote:
> Hi.
> 
> On Fri, 2010-08-20 at 14:04 +0200, ext pramodh ag wrote:
> > Hello,
> > 
> > > +static ssize_t wl1273_fm_fops_write(struct file *file, const char __user 
> > *buf,
> > > +                    size_t count, loff_t *ppos)
> > > +{
> > > +    struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> > > +    u16 val;
> > > +    int r;
> > > +
> > > +    dev_dbg(radio->dev, "%s\n", __func__);
> > > +
> > > +    if (radio->core->mode != WL1273_MODE_TX)
> > > +        return count;
> > > +
> > > +    if (!radio->rds_on) {
> > > +        dev_warn(radio->dev, "%s: RDS not on.\n", __func__);
> > > +        return 0;
> > > +    }
> > 
> > Aren't you planning to use extended controls "V4L2_CID_RDS_TX_RADIO_TEXT", 
> > "V4L2_CID_RDS_TX_PI", etc to handle FM TX RDS data?
> 
> In principle yes, but we haven't yet decided to implement those now, at
> the moment the RDS interpretation is left completely to user space
> applications.

Matti, is it even possible to use the current FM TX RDS API for this chip?
That API expects that the chip can generate the correct RDS packets based on
high-level data. If the chip can only handle 'raw' RDS packets (requiring a
userspace RDS encoder), then that API will never work.

But if this chip can indeed handle raw RDS only, then we need to add some
capability flags to signal that to userspace.

Regards,

	Hans

> 
> Best Regards,
> Matti
> 
> > 
> > Thanks and regards,
> > Pramodh
> > 
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

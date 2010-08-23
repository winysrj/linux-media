Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.233]:39139 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0HWGxv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 02:53:51 -0400
Subject: Re: [PATCH v7 4/5] V4L2: WL1273 FM Radio: Controls for the FM
 radio.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext pramodh ag <pramodhag@yahoo.co.in>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
In-Reply-To: <555961.26177.qm@web95110.mail.in2.yahoo.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-3-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-4-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-5-git-send-email-matti.j.aaltonen@nokia.com>
	 <555961.26177.qm@web95110.mail.in2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 09:53:37 +0300
Message-ID: <1282546417.14489.191.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi.

On Fri, 2010-08-20 at 14:04 +0200, ext pramodh ag wrote:
> Hello,
> 
> > +static ssize_t wl1273_fm_fops_write(struct file *file, const char __user 
> *buf,
> > +                    size_t count, loff_t *ppos)
> > +{
> > +    struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> > +    u16 val;
> > +    int r;
> > +
> > +    dev_dbg(radio->dev, "%s\n", __func__);
> > +
> > +    if (radio->core->mode != WL1273_MODE_TX)
> > +        return count;
> > +
> > +    if (!radio->rds_on) {
> > +        dev_warn(radio->dev, "%s: RDS not on.\n", __func__);
> > +        return 0;
> > +    }
> 
> Aren't you planning to use extended controls "V4L2_CID_RDS_TX_RADIO_TEXT", 
> "V4L2_CID_RDS_TX_PI", etc to handle FM TX RDS data?

In principle yes, but we haven't yet decided to implement those now, at
the moment the RDS interpretation is left completely to user space
applications.

Best Regards,
Matti

> 
> Thanks and regards,
> Pramodh
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


